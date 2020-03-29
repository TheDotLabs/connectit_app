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
        color: Colors.transparent,
        elevation: 0,
        highlightElevation: 0,
        child: Text(
          'CANCEL',
          style: Theme.of(context).textTheme.display1.copyWith(fontSize: 14),
        ),
      ),
    );
  }
}
