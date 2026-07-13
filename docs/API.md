# API Reference — Flutter SDK

## NotificationClient

### Constructor

```dart
NotificationClient(NotificationClientConfig config)
```

### Properties

| Property | Type | Deskripsi |
|---|---|---|
| `connectionState` | `ConnectionState` | Status koneksi |
| `serverUrl` | `String` | URL server |
| `origin` | `String` | Origin platform |

### Methods

#### `Future<void> connect()`
Membuka koneksi WebSocket.

#### `Future<void> disconnect()`
Menutup koneksi.

#### `Future<void> destroy()`
Menutup koneksi + hapus semua listener.

#### `void join(String destination, String channel, [String? userUniqueCode])`
Subscribe ke channel.

#### `void leave(String destination, String channel, [String? userUniqueCode])`
Unsubscribe dari channel.

#### `void leaveAll()`
Unsubscribe dari semua channel.

#### `void Function() onConnect(void Function() listener)`
#### `void Function() onDisconnect(void Function(String reason) listener)`
#### `void Function() onReconnecting(void Function(int attempt) listener)`
#### `void Function() onError(void Function(dynamic error) listener)`
#### `void Function() onNotification(void Function(NotificationPayload) listener)`

Semua method listener mengembalikan fungsi callback untuk unsubscribe.

#### `Future<GetNotificationsResponse> getNotifications(List<String> channels, String userUniqueCode)`
Fetch notifikasi via WebSocket.

#### `Future<ApiResponse> markAsRead(String notifId, String userId, {String? origin})`
#### `Future<ApiResponse> markAllAsRead(List<String> notifIds, String userId, {String? origin})`
#### `Future<ApiResponse> markAsDelete(String notifId, String userId, {String? origin})`

#### `void setProjectToken(String token)`
#### `void setOrigin(String origin)`

## Models

### NotificationClientConfig

```dart
NotificationClientConfig({
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

### NotificationPayload

```dart
class NotificationPayload {
  final String id;           // _id dari MongoDB
  final String ownerId;
  final String room;         // "public" | "private"
  final String title;
  final String message;
  final String link;
  final String? userUniqueCode;
  final String? type;
  final NotificationMeta meta;
  final bool isRead;
  final String createdAt;
  final String updatedAt;
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
  final String label; // "Hari Ini", "Kemarin", dll
  final List<NotificationPayload> notifications;
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
