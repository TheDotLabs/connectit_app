import 'package:flutter/material.dart';

class MenuHeader extends StatelessWidget {
  final String title;

  MenuHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.overline.copyWith(
                  fontSize: 13,
                ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            child: Text(
              "View All",
              style: TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
          )
        ],
      ),
    );
  }
}
