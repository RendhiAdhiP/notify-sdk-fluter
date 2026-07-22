# RWS SDK — Flutter

**RWS SDK** versi Flutter/Dart — Realtime WebSocket client untuk notifikasi, chat, dan event realtime multi-tenant.

Package: `rws` | Import: `package:rws/rws.dart` | Class: `RWSClient`

## Fitur

-   Koneksi WebSocket (Socket.io) dengan autentikasi otomatis (`project_token` + `origin`)
-   Subscribe / Unsubscribe ke channel notifikasi
-   Menerima notifikasi real-time via event listener
-   Fetch semua notifikasi (publik & private)
-   Mark as read, mark all as read, mark as delete
-   Auto-reconnect dengan exponential backoff
-   Type-safe — semua model dart:class
-   API konsisten dengan version TypeScript SDK

## Instalasi

```yaml
dependencies:
  rws:
    git:
      url: https://github.com/RendhiAdhiP/rws-dart.git
      ref: main
```

Atau local:

```yaml
dependencies:
  rws:
    path: ../rws-dart
```

## Quick Start

```dart
import 'package:rws/rws.dart';

final client = RWSClient(
  RWSConfig(
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
