import 'package:flutter/material.dart';
import 'package:rws/rws.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notifikasi Demo',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const NotificationDemo(),
    );
  }
}

class NotificationDemo extends StatefulWidget {
  const NotificationDemo({super.key});

  @override
  State<NotificationDemo> createState() => _NotificationDemoState();
}

class _NotificationDemoState extends State<NotificationDemo> {
  late final RWSClient _client;
  ConnectionState _connectionState = ConnectionState.disconnected;
  List<RWSPayload> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _client = RWSClient(
      RWSConfig(
        serverUrl: const String.fromEnvironment('NOTIF_SERVER_URL',
            defaultValue: 'https://notif.regarmarket.id'),
        projectToken: const String.fromEnvironment('NOTIF_PROJECT_TOKEN',
            defaultValue: 'your-token'),
        origin: const String.fromEnvironment('NOTIF_ORIGIN',
            defaultValue: 'regarmarket'),
        autoConnect: false,
      ),
    );

    _client.onConnect(() {
      setState(() => _connectionState = ConnectionState.connected);
      _client.join('regarmarket', 'orders', 'user123');
      _client.join('regarmarket', 'system');
      _loadNotifications();
    });

    _client.onDisconnect((reason) {
      setState(() => _connectionState = ConnectionState.disconnected);
    });

    _client.onReconnecting((attempt) {
      setState(() => _connectionState = ConnectionState.reconnecting);
    });

    _client.onError((err) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $err'), backgroundColor: Colors.red),
        );
      }
    });

    _client.onNotification((notif) {
      setState(() {
        _notifications.insert(0, notif);
        _unreadCount++;
      });
    });
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    try {
      final result = await _client.getNotifications(
        ['orders', 'system', 'messages'],
        'user123',
      );
      setState(() {
        _notifications = result.data
            .expand((g) => g.data)
            .expand((g) => g.notifications)
            .toList();
        _unreadCount = result.totalUnread;
      });
    } catch (err) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat: $err')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _markAsRead(RWSPayload notif) async {
    await _client.markAsRead(notif.id, 'user123');
    setState(() {
      final idx = _notifications.indexWhere((n) => n.id == notif.id);
      if (idx != -1) {
        _notifications[idx] = RWSPayload(
          id: _notifications[idx].id,
          ownerId: _notifications[idx].ownerId,
          room: _notifications[idx].room,
          title: _notifications[idx].title,
          message: _notifications[idx].message,
          link: _notifications[idx].link,
          userUniqueCode: _notifications[idx].userUniqueCode,
          type: _notifications[idx].type,
          meta: _notifications[idx].meta,
          isRead: true,
          createdAt: _notifications[idx].createdAt,
          updatedAt: _notifications[idx].updatedAt,
        );
        _unreadCount = _unreadCount > 0 ? _unreadCount - 1 : 0;
      }
    });
  }

  @override
  void dispose() {
    _client.destroy();
    super.dispose();
  }

  String _stateLabel(ConnectionState state) {
    switch (state) {
      case ConnectionState.disconnected:
        return 'Terputus';
      case ConnectionState.connecting:
        return 'Menghubungkan...';
      case ConnectionState.connected:
        return 'Terhubung';
      case ConnectionState.reconnecting:
        return 'Reconnect...';
    }
  }

  Color _stateColor(ConnectionState state) {
    switch (state) {
      case ConnectionState.disconnected:
        return Colors.grey;
      case ConnectionState.connecting:
        return Colors.orange;
      case ConnectionState.connected:
        return Colors.green;
      case ConnectionState.reconnecting:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _stateColor(_connectionState).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, size: 8, color: _stateColor(_connectionState)),
                const SizedBox(width: 4),
                Text(
                  _stateLabel(_connectionState),
                  style: TextStyle(fontSize: 12, color: _stateColor(_connectionState)),
                ),
              ],
            ),
          ),
          if (_connectionState != ConnectionState.connected)
            IconButton(
              icon: const Icon(Icons.link),
              onPressed: () => _client.connect(),
              tooltip: 'Hubungkan',
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadNotifications,
              tooltip: 'Refresh',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? const Center(
                  child: Text('Belum ada notifikasi',
                      style: TextStyle(color: Colors.grey)))
              : RefreshIndicator(
                  onRefresh: _loadNotifications,
                  child: ListView.separated(
                    itemCount: _notifications.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final notif = _notifications[index];
                      return ListTile(
                        leading: Icon(
                          notif.isRead
                              ? Icons.notifications_none
                              : Icons.notifications_active,
                          color: notif.isRead ? Colors.grey : Colors.blue,
                        ),
                        title: Text(
                          notif.title,
                          style: TextStyle(
                            fontWeight:
                                notif.isRead ? FontWeight.normal : FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(notif.message, maxLines: 2),
                            const SizedBox(height: 4),
                            Text(
                              _formatDate(notif.createdAt),
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        trailing: notif.isRead
                            ? null
                            : TextButton(
                                onPressed: () => _markAsRead(notif),
                                child: const Text('Baca'),
                              ),
                        onTap: notif.isRead ? null : () => _markAsRead(notif),
                      );
                    },
                  ),
                ),
    );
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      final now = DateTime.now();
      final diff = now.difference(dt);

      if (diff.inDays == 0) return 'Hari ini';
      if (diff.inDays == 1) return 'Kemarin';
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return iso;
    }
  }
}
