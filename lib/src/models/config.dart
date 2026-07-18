class RWSConfig {
  final String serverUrl;
  final String projectToken;
  final String origin;
  final bool autoConnect;
  final ReconnectionConfig reconnection;
  final int timeout;
  final Logger? logger;

  const RWSConfig({
    required this.serverUrl,
    required this.projectToken,
    required this.origin,
    this.autoConnect = true,
    this.reconnection = const ReconnectionConfig(),
    this.timeout = 10000,
    this.logger,
  });
}

class ReconnectionConfig {
  final bool enabled;
  final int maxAttempts;
  final int initialDelay;
  final int maxDelay;
  final double backoffMultiplier;

  const ReconnectionConfig({
    this.enabled = true,
    this.maxAttempts = 10,
    this.initialDelay = 1000,
    this.maxDelay = 30000,
    this.backoffMultiplier = 2.0,
  });
}

class Logger {
  final void Function(String message) info;
  final void Function(String message) warn;
  final void Function(String message) error;
  final void Function(String message) debug;

  const Logger({
    required this.info,
    required this.warn,
    required this.error,
    required this.debug,
  });

  static const Logger silent = Logger(
    info: _noop,
    warn: _noop,
    error: _noop,
    debug: _noop,
  );

  static void _noop(String message) {}
}

enum ConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting;
}
