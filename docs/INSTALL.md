# Instalasi

## Prasyarat

- Flutter >= 3.16 / Dart >= 3.2
- Project Flutter sudah diinisialisasi

## Install dari Git (Private Repository)

Di `pubspec.yaml`:

```yaml
dependencies:
  rws:
    git:
      url: https://github.com/RendhiAdhiP/rws-dart.git
      ref: main
```

Atau via SSH:

```yaml
dependencies:
  rws:
    git:
      url: git@github.com:RendhiAdhiP/rws-dart.git
      ref: main
```

## Install dari Local Path (Development)

Jika Package berada di sibling directory:

```yaml
dependencies:
  rws:
    path: ../rws-dart
```

## Import

```dart
import 'package:rws/rws.dart';
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
