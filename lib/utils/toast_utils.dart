import 'package:bot_toast/bot_toast.dart';

import 'constants.dart';

class ToastUtils {
  ToastUtils._();

  static void show(String message) {
    BotToast.showText(text: message);
  }

  static void showSomethingWrong() {
    show(Constants.somethingWrong);
  }
}
