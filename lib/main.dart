import 'package:bot_toast/bot_toast.dart';
import 'package:connectit_app/modules/home/home_page.dart';
import 'package:connectit_app/modules/login/index.dart';
import 'package:connectit_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'data/local/prefs/prefs_helper.dart';
import 'di/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Injector().init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final _defaultHome = prefsHelper.isLogin ? HomePage() : LoginScreen();

    return BotToastInit(
      child: MaterialApp(
        title: 'Connect IT',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.grey[50],
          iconTheme: IconThemeData(
            color: Colors.black87,
          ),
          textTheme: GoogleFonts.muliTextTheme(textTheme),
          appBarTheme: AppBarTheme(
            brightness: Brightness.light,
            color: Colors.white,
            elevation: 1,
            iconTheme: IconThemeData(
              color: Colors.black87,
            ),
            textTheme: TextTheme(
              title: GoogleFonts.nunito(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          iconTheme: IconThemeData(),
          textTheme: GoogleFonts.muliTextTheme(
            ThemeData(brightness: Brightness.dark).textTheme,
          ),
          appBarTheme: AppBarTheme(
            brightness: Brightness.dark,
            elevation: 1,
            textTheme: TextTheme(
              title: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        home: _defaultHome,
        navigatorObservers: [BotToastNavigatorObserver()],
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
