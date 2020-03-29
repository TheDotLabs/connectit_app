import 'package:connectit_app/data/repo/user/base/user_repository.dart';
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
          _showDialog(context);
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

  Future<void> _showDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Proceed"),
              onPressed: () {
                injector<UserRepository>().logoutUser();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.login,
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
