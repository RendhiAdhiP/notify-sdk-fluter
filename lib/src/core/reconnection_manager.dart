import 'dart:async';
import 'dart:math';
import '../models/config.dart';

class ReconnectionManager {
  final ReconnectionConfig config;
  int _attempt = 0;
  Timer? _timer;

  ReconnectionManager({this.config = const ReconnectionConfig()});

  bool get enabled => config.enabled;
  int get maxAttempts => config.maxAttempts;
  int get currentAttempt => _attempt;

  void Function(int attempt, int delay)? onAttempt;

  void reset() {
    _attempt = 0;
    cancel();
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  int get delay {
    final initial = config.initialDelay;
    final maxDelay = config.maxDelay;
    final multiplier = config.backoffMultiplier;
    final calculated =
        (initial * pow(multiplier, _attempt)).toInt();
    return min(calculated, maxDelay) + Random().nextInt(1000);
  }

  bool schedule(VoidCallback callback) {
    if (!enabled) return false;
    if (_attempt >= maxAttempts) return false;

    _attempt++;
    final d = delay;
    onAttempt?.call(_attempt, d);
    _timer = Timer(Duration(milliseconds: d), callback);
    return true;
  }
}
