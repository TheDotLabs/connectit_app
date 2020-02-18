import 'package:bot_toast/bot_toast.dart';
import 'package:connectit_app/modules/home/home_page.dart';
import 'package:connectit_app/modules/login/index.dart';
import 'package:connectit_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'config/theme/theme.dart';
import 'data/local/prefs/prefs_helper.dart';
import 'di/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Injector().init();
  final theme = ThemeModel();
  final _defaultHome = prefsHelper.isLogin ? HomePage() : LoginScreen();

  runApp(
    BotToastInit(
      child: MaterialApp(
        title: 'Connect IT',
        debugShowCheckedModeBanner: false,
        theme: theme.lightTheme,
        darkTheme: theme.lightTheme,
        home: _defaultHome,
        navigatorObservers: [BotToastNavigatorObserver()],
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    ),
  );
}
