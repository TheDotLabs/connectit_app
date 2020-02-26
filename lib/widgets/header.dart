import 'package:connectit_app/utils/constants.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;
  final double marginBottom;
  final bool required;

  Header(
    this.title, {
    this.marginBottom = Constants.headerSeparatorHeight,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: marginBottom),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.overline.copyWith(
                  fontSize: 13,
                ),
          ),
          if (required)
            Text(
              " *",
              style: Theme.of(context).textTheme.overline.copyWith(
                    fontSize: 13,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
            ),
        ],
      ),
    );
  }
}
