# Penggunaan

## Inisialisasi Client

```dart
import 'package:rws/rws.dart';

final client = RWSClient(
  RWSConfig(
    serverUrl: 'https://notif.regarmarket.id',
    projectToken: 'eyJhbGciOiJIUzI1NiIs...',
    origin: 'regarmarket',
    autoConnect: true,
    timeout: 10000,
    reconnection: ReconnectionConfig(
      enabled: true,
      maxAttempts: 10,
      initialDelay: 1000,
      maxDelay: 30000,
      backoffMultiplier: 2.0,
    ),
  ),
);
```

### Opsi Konfigurasi

| Parameter | Tipe | Default | Deskripsi |
|---|---|---|---|
| `serverUrl` | `String` | — | URL server WebSocket (wajib) |
| `projectToken` | `String` | — | Token autentikasi project (wajib) |
| `origin` | `String` | — | Origin platform (wajib) |
| `autoConnect` | `bool` | `true` | Auto-connect saat inisialisasi |
| `timeout` | `int` | `10000` | Timeout koneksi (ms) |
| `reconnection` | `ReconnectionConfig` | `ReconnectionConfig()` | Auto-reconnect |
| `logger` | `Logger?` | `null` | Custom logger |

## Event Listeners

```dart
// Subscribe
final unsub = client.onNotification((notif) {
  print('[${notif.type}] ${notif.title}');
});

// Unsubscribe via returned callback
unsub();
```

### Daftar Event

| Method | Callback | Deskripsi |
|---|---|---|
| `onConnect` | `void Function()` | Terkoneksi |
| `onDisconnect` | `void Function(String reason)` | Terputus |
| `onReconnecting` | `void Function(int attempt)` | Reconnect |
| `onError` | `void Function(dynamic error)` | Error |
| `onNotification` | `void Function(RWSPayload)` | Notif baru |

## Channel Management

```dart
// Public channel
client.join('regarmarket', 'orders');

// Private channel
client.join('regarmarket', 'orders', 'user123');

// Leave
client.leave('regarmarket', 'orders');

// Leave all
client.leaveAll();
```

## Fetch Notifications

```dart
try {
  final result = await client.getNotifications(
    ['orders', 'system'],
    'user123',
  );

  print('Total: ${result.total}');
  print('Unread: ${result.totalUnread}');

  for (final channel in result.data) {
    print('Channel: ${channel.channel}');
    for (final group in channel.data) {
      print('  ${group.label}: ${group.notifications.length} notif');
    }
  }
} catch (err) {
  print('Failed: $err');
}
```

## Mark Notifications

```dart
// Mark as read
await client.markAsRead('notifId123', 'user123');

// Mark all as read
await client.markAllAsRead(
  ['notifId1', 'notifId2'],
  'user123',
);

// Mark as delete
await client.markAsDelete('notifId123', 'user123');
```

## Connection Lifecycle

```dart
// Manual connect (jika autoConnect: false)
await client.connect();

// Cek status
print(client.connectionState);

// Disconnect
await client.disconnect();

// Destroy (cleanup semua listener)
await client.destroy();
```

## Update Credentials

```dart
client.setProjectToken('new-token');
client.setOrigin('new-origin');

// Untuk menggunakan kredensial baru, disconnect lalu connect ulang
await client.disconnect();
await client.connect();
```

## Error Handling

```dart
client.onError((err) {
  print('SDK Error: $err');
});

client.onDisconnect((reason) {
  if (reason == 'io server disconnect') {
    print('Server disconnected us — tidak akan auto-reconnect');
  }
});
```
