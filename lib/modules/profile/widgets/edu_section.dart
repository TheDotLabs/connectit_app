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
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(fontSize: 16),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  "(${education.startYear ?? ''} - ${education.endYear ?? ''})",
                  style: Theme.of(context).textTheme.headline4.copyWith(
                        fontSize: 14,
                      ),
                ),
                if (checkIfNotEmpty(education.description))
                  Container(
                    margin: EdgeInsets.only(top: 10),
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
