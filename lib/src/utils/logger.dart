import '../models/config.dart';

class NotificationLogger {
  final Logger _logger;

  const NotificationLogger(this._logger);

  void info(String message) => _logger.info('[NotificationSDK] $message');
  void warn(String message) => _logger.warn('[NotificationSDK] $message');
  void error(String message) => _logger.error('[NotificationSDK] $message');
  void debug(String message) => _logger.debug('[NotificationSDK] $message');
}
