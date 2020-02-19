import 'package:connectit_app/widgets/header.dart';
import 'package:flutter/material.dart';

class Facebook_Section extends StatelessWidget {
  String facebook;

  Facebook_Section(this.facebook);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Header("FACEBOOK"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(facebook),
        ),
        SizedBox(
          height: 8,
        ),
        Divider(
          height: 1,
        ),
      ],
    );
  }
}
