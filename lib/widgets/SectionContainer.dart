import 'package:flutter/material.dart';

class SectionContainer extends StatelessWidget {
  final Widget child;

  const SectionContainer({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
      child: child,
    );
  }
}
