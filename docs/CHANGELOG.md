# Changelog

## [2.0.0] - 2026-07-18

### Changed
-   **Package renamed**: `notification_sdk` → `rws_sdk` (import `package:rws_sdk/rws_sdk.dart`)
-   **Class renamed**: `NotificationClient` → `RWSClient`
-   **Config renamed**: `NotificationClientConfig` → `RWSConfig`
-   **Models renamed**: `NotificationPayload` → `RWSPayload`, `NotificationMeta` → `RWSNotificationMeta`
-   API konsisten dengan version TypeScript SDK (`rws-sdk` v2.0.0)

### Added
-   `setOrigin()` method
-   `origin` getter property
-   `Logger` class with `Logger.silent` default
-   Auto room re-join on reconnect

## [1.0.0] - 2026-07-01

### Added
-   Initial release Flutter SDK
-   `NotificationClient` — WebSocket client dengan Socket.io + auto-reconnect
-   Event listener system (`onConnect`, `onDisconnect`, `onReconnecting`, `onError`, `onNotification`)
-   Channel subscription (`join`, `leave`, `leaveAll`)
-   Fetch notifikasi via WebSocket (`getNotifications`)
-   REST API wrapper untuk `markAsRead`, `markAllAsRead`, `markAsDelete`
-   ReconnectionManager dengan exponential backoff
-   AuthManager untuk project token & origin
-   Full type-safe models
-   API konsisten dengan version TypeScript SDK
