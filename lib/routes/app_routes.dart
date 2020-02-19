import 'package:connectit_app/modules/home/home_page.dart';
import 'package:connectit_app/modules/login/index.dart';
import 'package:connectit_app/modules/startup_detail/startup_detail_page.dart';
import 'package:flutter/material.dart';

import 'routes.dart';

class AppRoutes {
  /// Add entry for new route here
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case Routes.home:
        return MaterialPageRoute(builder: (_) => HomePage());
      case Routes.startupDetails:
        return MaterialPageRoute(builder: (_) => StartupDetailPage(settings.arguments));
      /*case Routes.PROFILE:
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case Routes.SHOP:
        return MaterialPageRoute(builder: (_) => ShopScreen());
      case Routes.cart:
        return MaterialPageRoute(builder: (_) => CartScreen());*/
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
