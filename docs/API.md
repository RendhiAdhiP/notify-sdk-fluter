# API Reference — Flutter SDK

## RWSClient

Package: `rws` | Import: `package:rws/rws.dart`

### Constructor

```dart
RWSClient(RWSConfig config)
```

### Properties

| Property | Type | Deskripsi |
|---|---|---|
| `connectionState` | `ConnectionState` | Status koneksi |
| `serverUrl` | `String` | URL server |
| `origin` | `String` | Origin platform |

### Methods

#### `Future<void> connect()`
Membuka koneksi WebSocket. Otomatis dipanggil jika `autoConnect: true`.

#### `Future<void> disconnect()`
Menutup koneksi dan menghapus semua room.

#### `Future<void> destroy()`
Menutup koneksi + hapus semua event listener.

#### `void join(String destination, String channel, [String? userUniqueCode])`
Subscribe ke channel. Format room: `destination:channel[:userUniqueCode]`.

#### `void leave(String destination, String channel, [String? userUniqueCode])`
Unsubscribe dari channel.

#### `void leaveAll()`
Unsubscribe dari semua channel.

#### Listener Methods

Semua listener method mengembalikan `VoidCallback` untuk unsubscribe.

```dart
VoidCallback onConnect(void Function() listener)
VoidCallback onDisconnect(void Function(String reason) listener)
VoidCallback onReconnecting(void Function(int attempt) listener)
VoidCallback onError(void Function(dynamic error) listener)
VoidCallback onNotification(void Function(RWSPayload) listener)
```

#### `Future<GetNotificationsResponse> getNotifications(List<String> channels, String userUniqueCode)`
Fetch notifikasi via WebSocket.

#### `Future<ApiResponse> markAsRead(String notifId, String userId, {String? origin})`
#### `Future<ApiResponse> markAllAsRead(List<String> notifIds, String userId, {String? origin})`
#### `Future<ApiResponse> markAsDelete(String notifId, String userId, {String? origin})`

#### `void setProjectToken(String token)`
#### `void setOrigin(String origin)`

## Models

### RWSConfig

```dart
RWSConfig({
  required String serverUrl,
  required String projectToken,
  required String origin,
  bool autoConnect = true,
  ReconnectionConfig reconnection = ReconnectionConfig(),
  int timeout = 10000,
  Logger? logger,
})
```

### ReconnectionConfig

```dart
ReconnectionConfig({
  bool enabled = true,
  int maxAttempts = 10,
  int initialDelay = 1000,
  int maxDelay = 30000,
  double backoffMultiplier = 2.0,
})
```

### RWSPayload

```dart
class RWSPayload {
  final String id;             // _id dari MongoDB
  final String ownerId;
  final String room;           // "public" | "private"
  final String title;
  final String message;
  final String link;
  final String? userUniqueCode;
  final String? type;
  final RWSNotificationMeta meta;
  final bool isRead;
  final String createdAt;
  final String updatedAt;
}
```

### RWSNotificationMeta

```dart
class RWSNotificationMeta {
  final String destination;
  final String channel;
  final String? origin;
}
```

### GetNotificationsResponse

```dart
class GetNotificationsResponse {
  final int total;
  final int totalIsRead;
  final int totalUnread;
  final List<ChannelGroup> data;
}

class ChannelGroup {
  final String channel;
  final int total;
  final int totalIsRead;
  final int totalUnread;
  final List<DateGroup> data;
}

class DateGroup {
  final String label;           // "Hari Ini", "Kemarin", dll
  final List<RWSPayload> notifications;
}
```

### ApiResponse

```dart
class ApiResponse {
  final String status;   // "success", "fail", "error"
  final int code;
  final String message;
  final dynamic data;
  bool get isSuccess;
}
```

### ConnectionState

```dart
enum ConnectionState { disconnected, connecting, connected, reconnecting }
```
