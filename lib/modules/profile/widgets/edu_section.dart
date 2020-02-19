import 'package:connectit_app/data/model/user.dart';
import 'package:connectit_app/utils/top_level_utils.dart';
import 'package:connectit_app/widgets/SectionContainer.dart';
import 'package:connectit_app/widgets/header.dart';
import 'package:flutter/material.dart';

class EducationSection extends StatelessWidget {
  final List<Education> list;

  EducationSection(this.list);

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Header("EDUCATION"),
          for (final education in list)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  education.college ?? "--",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                Text(
                  "(${education.startYear ?? ''} - ${education.endYear ?? ''})",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                if (checkIfNotEmpty(education.description))
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: Text(
                      education.description,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
              ],
            ),

          // Text(tagline),
        ],
      ),
    );
  }
}
