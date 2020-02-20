import 'package:connectit_app/data/repo/user/base/user_repository.dart';
import 'package:connectit_app/data/repo/user/user_repository_impl.dart';
import 'package:connectit_app/di/injector.dart';
import 'package:connectit_app/routes/routes.dart';
import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget {
  final VoidCallback onTap;
  CancelButton(this.onTap);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      child: RaisedButton(
        onPressed: onTap,
        color: Colors.white,
        elevation: 0,
        highlightElevation: 0,
        child: Text(
          'CANCEL',
          style: TextStyle(
            color: Colors.black38,
          ),
        ),
      ),
    );
  }
}
