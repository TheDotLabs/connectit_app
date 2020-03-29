import 'package:flutter/material.dart';

class UpdateButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  UpdateButton(this.onTap, {this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      child: RaisedButton(
        onPressed: onTap,
        color: Colors.transparent,
        elevation: 0,
        highlightElevation: 0,
        child: Text(
          text ?? 'UPDATE',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
