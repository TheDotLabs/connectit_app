import 'package:flutter/material.dart';

class VerifiedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 14,
      width: 14,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blueAccent),
      child: Icon(
        Icons.done,
        color: Colors.white,
        size: 12,
      ),
    );
  }
}
