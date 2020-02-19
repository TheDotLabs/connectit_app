import 'package:connectit_app/widgets/SectionContainer.dart';
import 'package:connectit_app/widgets/header.dart';
import 'package:flutter/material.dart';

class TaglineSection extends StatelessWidget {
  final String tagline;

  TaglineSection(this.tagline);

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Header("TAGLINE"),
          Text(tagline),
        ],
      ),
    );
  }
}
