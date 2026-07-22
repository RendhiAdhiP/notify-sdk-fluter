import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'models/config.dart';
import 'models/notification.dart';
import 'models/responses.dart';
import 'core/auth_manager.dart';
import 'core/reconnection_manager.dart';
import 'handlers/event_handler.dart';
import 'utils/logger.dart';
import 'utils/helpers.dart';

class RWSClient {
  io.Socket? _socket;
  final RWSConfig _config;
  final AuthManager _authManager;
  final ReconnectionManager _reconnectionManager;
  final EventHandler _eventHandler;
  final RWSLogger _logger;
  ConnectionState _state = ConnectionState.disconnected;
  final _joinedRooms = <String>{};
  bool _destroyed = false;
  Future<void>? _connectPromise;

  RWSClient(RWSConfig config)
      : _config = config,
        _authManager = AuthManager(
          projectToken: config.projectToken,
          origin: config.origin,
        ),
        _reconnectionManager = ReconnectionManager(
          config: config.reconnection,
        ),
        _eventHandler = EventHandler(),
        _logger = RWSLogger(config.logger ?? Logger.silent) {
    _reconnectionManager.onAttempt = (attempt, delay) {
      _logger.info('Reconnection attempt $attempt in ${delay}ms');
      _eventHandler.emitReconnecting(attempt);
    };

    if (config.autoConnect) {
      connect();
    }
  }

  ConnectionState get connectionState => _state;
  String get serverUrl => _config.serverUrl;
  String get origin => _authManager.origin;

  void _setState(ConnectionState newState) {
    _state = newState;
  }

  Future<void> connect() async {
    if (_socket?.connected == true) {
      return;
    }

    if (_connectPromise != null) {
      return _connectPromise;
    }

    _destroyed = false;

    if (_socket != null) {
      _cleanupSocket();
    }

    _setState(ConnectionState.connecting);
    _logger.info('Connecting to ${_config.serverUrl}');

    final completer = Completer<void>();
    final connectFuture = completer.future;
    _connectPromise = connectFuture;
    final timeoutMs = _config.timeout;
    Timer? timeoutTimer;

    try {
      _socket = io.io(
        _config.serverUrl,
        io.OptionBuilder()
            .setAuth(_authManager.socketAuth)
            .setTransports(['websocket', 'polling'])
            .setForceNew(true)
            .build(),
      );

      timeoutTimer = Timer(Duration(milliseconds: timeoutMs), () {
        _connectPromise = null;
        _cleanupSocket();
        _setState(ConnectionState.disconnected);
        if (!completer.isCompleted) {
          completer.completeError(
            Exception('Connection timeout after ${timeoutMs}ms'),
          );
        }
      });

      _socket!.onConnect((_) {
        timeoutTimer?.cancel();
        _connectPromise = null;
        _setState(ConnectionState.connected);
        _reconnectionManager.reset();
        _logger.info('Connected');
        _eventHandler.emitConnect();
        _rejoinRooms();
        if (!completer.isCompleted) completer.complete();
      });

      _socket!.onDisconnect((reason) {
        _connectPromise = null;
        _setState(ConnectionState.disconnected);
        _logger.info('Disconnected: $reason');
        _eventHandler.emitDisconnect(reason ?? 'unknown');

        if (!_destroyed && reason != 'io client disconnect') {
          _handleReconnect();
        }
      });

      _socket!.onConnectError((data) {
        timeoutTimer?.cancel();
        _logger.error('Connection error: $data');
        _eventHandler.emitError(data);
        if (!completer.isCompleted) {
          completer.completeError(data ?? 'Connection failed');
        }
      });

      _socket!.on('notification:new', (data) {
        if (data is Map<String, dynamic>) {
          final notif = RWSPayload.fromJson(data);
          _eventHandler.emitNotification(notif);
        }
      });
    } catch (err) {
      _connectPromise = null;
      timeoutTimer?.cancel();
      _cleanupSocket();
      _setState(ConnectionState.disconnected);
      _logger.error('Failed to create socket: $err');
      if (!completer.isCompleted) completer.completeError(err);
    }

    return connectFuture;
  }

  void _cleanupSocket() {
    if (_socket != null) {
      _socket!.clearListeners();
      _socket!.disconnect();
      _socket = null;
    }
  }

  void _handleReconnect() {
    _connectPromise = null;
    _reconnectionManager.schedule(() {
      if (_destroyed) return;
      _logger.info('Attempting reconnection...');
      connect().catchError((err) {
        _logger.error('Reconnection failed: $err');
        _eventHandler.emitError(err);
      });
    });
  }

  void _rejoinRooms() {
    if (_joinedRooms.isEmpty) return;
    _logger.info('Rejoining ${_joinedRooms.length} room(s)');
    for (final room in _joinedRooms) {
      _socket?.emit('room:join', room);
    }
  }

  Future<void> disconnect() async {
    _destroyed = true;
    _connectPromise = null;
    _reconnectionManager.cancel();
    _joinedRooms.clear();
    _cleanupSocket();
    _setState(ConnectionState.disconnected);
    _logger.info('Disconnected');
  }

  Future<void> destroy() async {
    _eventHandler.removeAll();
    await disconnect();
  }

  void join(String destination, String channel, [String? userUniqueCode]) {
    final rooms = <String>[];
    rooms.add(buildRoomName(destination, channel));
    if (userUniqueCode != null) {
      rooms.add(buildRoomName(destination, channel, userUniqueCode));
    }

    for (final room in rooms) {
      _joinedRooms.add(room);

      if (_socket?.connected == true) {
        _socket!.emit('room:join', room);
      }
    }
  }

  void leave(String destination, String channel, [String? userUniqueCode]) {
    final rooms = <String>[];
    rooms.add(buildRoomName(destination, channel));
    if (userUniqueCode != null) {
      rooms.add(buildRoomName(destination, channel, userUniqueCode));
    }

    for (final room in rooms) {
      _joinedRooms.remove(room);

      if (_socket?.connected == true) {
        _socket!.emit('room:leave', room);
      }
    }
  }

  void leaveAll() {
    for (final room in _joinedRooms) {
      if (_socket?.connected == true) {
        _socket!.emit('room:leave', room);
      }
    }
    _joinedRooms.clear();
  }

  // --- typed listeners ---

  VoidCallback onConnect(VoidCallback listener) =>
      _eventHandler.onConnect(listener);

  VoidCallback onDisconnect(DisconnectCallback listener) =>
      _eventHandler.onDisconnect(listener);

  VoidCallback onReconnecting(ReconnectCallback listener) =>
      _eventHandler.onReconnecting(listener);

  VoidCallback onError(ErrorCallback listener) =>
      _eventHandler.onError(listener);

  VoidCallback onNotification(NotificationCallback listener) =>
      _eventHandler.onNotification(listener);

  // --- notification methods ---

  Future<GetNotificationsResponse> getNotifications(
    List<String> channels,
    String userUniqueCode,
  ) {
    final completer = Completer<GetNotificationsResponse>();

    if (_socket?.connected != true) {
      completer.completeError(Exception('Socket not connected'));
      return completer.future;
    }

    var settled = false;

    void Function(dynamic) cleanup = (_) {};

    void done() {
      if (settled) return;
      settled = true;
      cleanup(null);
    }

    void listener(dynamic response) {
      done();
      if (response is Map<String, dynamic>) {
        completer.complete(GetNotificationsResponse.fromJson(response));
      } else {
        completer.completeError(Exception('Invalid response format'));
      }
    }

    void onDisconnect(dynamic reason) {
      done();
      if (!completer.isCompleted) {
        completer.completeError(
          Exception('Socket disconnected while fetching notifications'),
        );
      }
    }

    cleanup = (dynamic _) {
      _socket?.off('notification:list', listenerA: listener);
      _socket?.off('disconnect', listenerA: onDisconnect);
    };

    _socket!.on('notification:list', listener);
    _socket!.on('disconnect', onDisconnect);

    _socket!.emit('notification:list', {
      'channels': channels,
      'origin': _authManager.origin,
      'user_unique_code': userUniqueCode,
      'private': '${_authManager.origin}:all:$userUniqueCode',
      'public': '${_authManager.origin}:all',
    });

    Timer(Duration(milliseconds: _config.timeout), () {
      done();
      if (!completer.isCompleted) {
        completer.completeError(Exception('getNotifications timeout'));
      }
    });

    return completer.future;
  }

  Future<ApiResponse> markAsRead(
    String notifId,
    String userId, {
    String? origin,
  }) {
    return _httpPost(
      '${_getBaseUrl()}/api/notification/$notifId/read',
      {
        'user_id': userId,
        'origin': origin ?? _authManager.origin,
      },
    );
  }

  Future<ApiResponse> markAllAsRead(
    List<String> notifIds,
    String userId, {
    String? origin,
  }) {
    return _httpPost(
      '${_getBaseUrl()}/api/notification/read-all',
      {
        'user_id': userId,
        'notif_ids': notifIds,
        'origin': origin ?? _authManager.origin,
      },
    );
  }

  Future<ApiResponse> markAsDelete(
    String notifId,
    String userId, {
    String? origin,
  }) {
    return _httpPost(
      '${_getBaseUrl()}/api/notification/mark-as-delete/$notifId',
      {
        'user_id': userId,
        'origin': origin ?? _authManager.origin,
      },
    );
  }

  // --- internal ---

  String _getBaseUrl() => _config.serverUrl.replaceAll(RegExp(r'/+$'), '');

  Future<ApiResponse> _httpPost(String url, Map<String, dynamic> body) async {
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: _authManager.httpHeaders,
            body: jsonEncode(body),
          )
          .timeout(Duration(milliseconds: _config.timeout));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      }

      throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
    } catch (err) {
      _logger.error('HTTP request failed: $err');
      rethrow;
    }
  }

  void setProjectToken(String token) {
    _authManager.projectToken = token;
  }

  void setOrigin(String origin) {
    _authManager.origin = origin;
  }
}
