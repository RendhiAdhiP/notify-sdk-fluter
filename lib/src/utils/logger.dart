import '../models/config.dart';

class RWSLogger {
  final Logger _logger;

  const RWSLogger(this._logger);

  void info(String message) => _logger.info('[RWSSDK] $message');
  void warn(String message) => _logger.warn('[RWSSDK] $message');
  void error(String message) => _logger.error('[RWSSDK] $message');
  void debug(String message) => _logger.debug('[RWSSDK] $message');
}
