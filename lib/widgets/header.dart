import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;

  Header(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.overline.copyWith(
                  fontSize: 13,
                ),
          ),
        ],
      ),
    );
  }
}
