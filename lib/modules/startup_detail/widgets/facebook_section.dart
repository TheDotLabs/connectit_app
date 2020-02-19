import 'package:connectit_app/modules/startup_detail/utils/constants.dart';
import 'package:connectit_app/utils/url_utils.dart';
import 'package:connectit_app/widgets/SectionContainer.dart';
import 'package:connectit_app/widgets/header.dart';
import 'package:flutter/material.dart';

class Facebook_Section extends StatelessWidget {
  String facebook;

  Facebook_Section(this.facebook);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        UrlUtils.launchURL(facebook);
      },
      child: SectionContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Header("FACEBOOK"),
            Text(facebook),
            SizedBox(
              height: Constants.sectionVPadding,
            ),
          ],
        ),
      ),
    );
  }
}
