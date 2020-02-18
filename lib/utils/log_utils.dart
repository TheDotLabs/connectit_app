import 'package:connectit_app/utils/log/my_logger.dart';

import 'log/i_log.dart';

final logger = LogUtils();

class LogUtils implements ILog {
  ILog _logger;

  LogUtils() {
    _logger = MyLogger();
  }

  @override
  void d(dynamic object) {
    _logger.d(object);
  }

  @override
  void e(dynamic object, StackTrace s) {
    _logger.e(object, s);
  }

  @override
  void i(dynamic object) {
    _logger.i(object);
  }

  @override
  void v(dynamic object) {
    _logger.v(object);
  }

  @override
  void w(dynamic object) {
    _logger.w(object);
  }

  @override
  void wtf(dynamic object) {
    _logger.wtf(object);
  }
}
