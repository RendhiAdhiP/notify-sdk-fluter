# Instalasi

## Prasyarat

- Flutter >= 3.16 / Dart SDK >= 3.2
- Project Flutter sudah diinisialisasi

## Install dari Git (Private Repository)

Di `pubspec.yaml`:

```yaml
dependencies:
  notification_sdk:
    git:
      url: https://github.com//RendhiAdhiP/notify-sdk/
      ref: main
```

Atau via SSH:

```yaml
dependencies:
  notification_sdk:
    git:
      url: git@github.com:RendhiAdhiP/notify-sdk/
      ref: main
```

## Install dari Local Path (Development)

Jika SDK berada di sibling directory:

```yaml
dependencies:
  notification_sdk:
    path: ../notification_sdk_flutter
```

## Install Dependencies

```bash
cd notification_sdk_flutter
dart pub get
```

## Menjalankan Analisis

```bash
dart analyze
```

## Menjalankan Test

```bash
dart test
```
