import 'package:connectit_app/modules/startup_detail/utils/constants.dart';
import 'package:connectit_app/widgets/header.dart';
import 'package:flutter/material.dart';

class DescriptionSection extends StatelessWidget {
  String message;

  DescriptionSection(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Constants.sectionVPadding,
        horizontal: Constants.sectionHPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Header("DESCRIPTION"),
          Text(message),
          SizedBox(
            height: Constants.sectionVPadding,
          ),
          Divider(
            height: 1,
          ),
        ],
      ),
    );
  }
}
