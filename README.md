# Notification SDK — Flutter

SDK Flutter/Dart untuk service notifikasi WebSocket — real-time notification client untuk platform multi-tenant.

## Fitur

-   Koneksi WebSocket (Socket.io) dengan autentikasi otomatis
-   Subscribe / Unsubscribe ke channel notifikasi
-   Menerima notifikasi real-time via event listener
-   Fetch semua notifikasi (publik & private)
-   Mark as read, mark all as read, mark as delete
-   Auto-reconnect dengan exponential backoff
-   Type-safe — semua model dart:class

## Instalasi

```yaml
dependencies:
  notification_sdk:
    git:
      url: https://github.com/your-org/notification_sdk_flutter.git
```

Atau local:

```yaml
dependencies:
  notification_sdk:
    path: ../notification_sdk_flutter
```

## Quick Start

```dart
import 'package:notification_sdk/notification_sdk.dart';

final client = NotificationClient(
  NotificationClientConfig(
    serverUrl: 'https://notif.regarmarket.id',
    projectToken: 'your-project-token',
    origin: 'regarmarket',
  ),
);

client.onNotification((notif) {
  print('[${notif.type}] ${notif.title}: ${notif.message}');
});

client.join('regarmarket', 'orders', 'user123');

final result = await client.getNotifications(['orders', 'system'], 'user123');
```

## Dokumentasi Lengkap

- [docs/INSTALL.md](docs/INSTALL.md) — Cara instalasi dan build
- [docs/USAGE.md](docs/USAGE.md) — Panduan penggunaan lengkap
- [docs/API.md](docs/API.md) — API Reference
- [docs/CHANGELOG.md](docs/CHANGELOG.md) — Riwayat perubahan

## API Mirip dengan Version TypeScript

SDK ini memiliki API yang konsisten dengan version TypeScript (Next.js) sehingga developer dapat berpindah platform dengan mudah.
