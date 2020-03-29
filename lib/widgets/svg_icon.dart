import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgIcon extends StatelessWidget {
  final String assetName;
  final double height;
  final double width;
  final Color color;

  const SvgIcon({
    Key key,
    @required this.assetName,
    this.color,
    this.height = 24,
    this.width = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: SvgPicture.asset(
        assetName,
        color: color,
      ),
    );
  }
}
