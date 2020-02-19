import 'package:connectit_app/modules/startup_detail/utils/constants.dart';
import 'package:connectit_app/widgets/header.dart';
import 'package:flutter/material.dart';

class WebsiteSection extends StatelessWidget {
  String url;

  WebsiteSection(this.url);

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
          Header("WEBSITE"),
          Text(url),
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
