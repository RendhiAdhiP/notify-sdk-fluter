# Changelog

## [1.0.0] - 2026-07-01

### Added

-   Initial release Flutter SDK
-   `NotificationClient` — WebSocket client dengan Socket.io + auto-reconnect
-   Event listener system (onConnect, onDisconnect, onReconnecting, onError, onNotification)
-   Channel subscription (join, leave, leaveAll)
-   Fetch notifikasi via WebSocket (getNotifications)
-   REST API wrapper untuk markAsRead, markAllAsRead, markAsDelete
-   ReconnectionManager dengan exponential backoff
-   AuthManager untuk project token & origin
-   Full type-safe models
-   API konsisten dengan version TypeScript SDK
