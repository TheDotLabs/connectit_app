import 'package:connectit_app/data/repo/user/base/user_repository.dart';
import 'package:connectit_app/data/repo/user/user_repository_impl.dart';
import 'package:connectit_app/di/injector.dart';
import 'package:connectit_app/routes/routes.dart';
import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      child: RaisedButton(
        onPressed: () {
          injector<UserRepository>().logoutUser();
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.login, (route) => false);
        },
        color: Colors.white,
        elevation: 0,
        highlightElevation: 0,
        child: Text(
          'LOGOUT',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
