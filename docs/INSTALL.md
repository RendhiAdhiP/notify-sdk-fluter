# Instalasi

## Prasyarat

- Flutter >= 3.16 / Dart SDK >= 3.2
- Project Flutter sudah diinisialisasi

## Install dari Git (Private Repository)

Di `pubspec.yaml`:

```yaml
dependencies:
  rws_sdk:
    git:
      url: https://github.com/RendhiAdhiP/rws-dart.git
      ref: main
```

Atau via SSH:

```yaml
dependencies:
  rws_sdk:
    git:
      url: git@github.com:RendhiAdhiP/rws-dart.git
      ref: main
```

## Install dari Local Path (Development)

Jika SDK berada di sibling directory:

```yaml
dependencies:
  rws_sdk:
    path: ../rws-dart
```

## Import

```dart
import 'package:rws_sdk/rws_sdk.dart';
```

## Install Dependencies

```bash
cd rws-dart
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
