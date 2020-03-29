import 'package:connectit_app/constants/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UnderConstruction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SvgPicture.asset(
            Images.CONSTRUCTION,
            height: 100,
          ),
          const SizedBox(
            height: 32,
          ),
          Text(
            "Hang on! Its still under construction...",
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ],
      ),
    );
  }
}
