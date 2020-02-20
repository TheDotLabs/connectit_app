import 'package:connectit_app/utils/constants.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;
  final double marginBottom;

  Header(
    this.title, {
    this.marginBottom = Constants.headerSeparatorHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: marginBottom),
      child: Text(
        title,
        style: Theme.of(context).textTheme.overline.copyWith(
              fontSize: 13,
            ),
      ),
    );
  }
}
