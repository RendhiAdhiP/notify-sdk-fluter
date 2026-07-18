import '../models/notification.dart';

typedef VoidCallback = void Function();
typedef NotificationCallback = void Function(RWSPayload notification);
typedef ErrorCallback = void Function(dynamic error);
typedef DisconnectCallback = void Function(String reason);
typedef ReconnectCallback = void Function(int attempt);

class EventHandler {
  final _listeners = <String, List<Function>>{};

  String _addListener(String event, Function listener) {
    _listeners.putIfAbsent(event, () => []);
    _listeners[event]!.add(listener);
    return event;
  }

  void _removeListener(String event, Function listener) {
    _listeners[event]?.remove(listener);
  }

  void _emit(String event, [List<dynamic> args = const []]) {
    _listeners[event]?.forEach((listener) {
      try {
        Function.apply(listener, args);
      } catch (err) {
        print('[RWSSDK] Error in $event listener: $err');
      }
    });
  }

  void removeAll() {
    _listeners.clear();
  }

  // --- typed API ---

  VoidCallback onConnect(VoidCallback listener) {
    _addListener('connect', listener);
    return () => _removeListener('connect', listener);
  }

  VoidCallback onDisconnect(DisconnectCallback listener) {
    _addListener('disconnect', listener);
    return () => _removeListener('disconnect', listener);
  }

  VoidCallback onReconnecting(ReconnectCallback listener) {
    _addListener('reconnecting', listener);
    return () => _removeListener('reconnecting', listener);
  }

  VoidCallback onError(ErrorCallback listener) {
    _addListener('error', listener);
    return () => _removeListener('error', listener);
  }

  VoidCallback onNotification(NotificationCallback listener) {
    _addListener('notification', listener);
    return () => _removeListener('notification', listener);
  }

  // --- internal emit ---

  void emitConnect() => _emit('connect');
  void emitDisconnect(String reason) => _emit('disconnect', [reason]);
  void emitReconnecting(int attempt) => _emit('reconnecting', [attempt]);
  void emitError(dynamic error) => _emit('error', [error]);
  void emitNotification(RWSPayload notification) =>
      _emit('notification', [notification]);
}
