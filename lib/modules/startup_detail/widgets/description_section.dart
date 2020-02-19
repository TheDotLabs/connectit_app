import 'package:connectit_app/modules/startup_detail/utils/constants.dart';
import 'package:connectit_app/widgets/SectionContainer.dart';
import 'package:connectit_app/widgets/header.dart';
import 'package:flutter/material.dart';

class DescriptionSection extends StatelessWidget {
  String message;

  DescriptionSection(this.message);

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Header("DESCRIPTION"),
          Text(message),
          SizedBox(
            height: Constants.sectionVPadding,
          ),
         
        ],
      ),
    );
  }
}
