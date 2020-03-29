import 'package:connectit_app/data/model/user.dart';
import 'package:connectit_app/data/repo/user/base/user_repository.dart';
import 'package:connectit_app/di/injector.dart';
import 'package:connectit_app/modules/profile/widgets/edu_section.dart';
import 'package:connectit_app/modules/profile/widgets/profile_header.dart';
import 'package:connectit_app/modules/profile/widgets/startups_section.dart';
import 'package:connectit_app/modules/profile/widgets/tag_section.dart';
import 'package:connectit_app/utils/top_level_utils.dart';
import 'package:connectit_app/widgets/my_divider.dart';
import 'package:connectit_app/widgets/stream_error.dart';
import 'package:flutter/material.dart';

import 'bloc.dart';
import 'widgets/email_section.dart';
import 'widgets/logout_button.dart';
import 'widgets/work_section.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _bloc = ProfileBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: _bloc.fetchUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final user = snapshot.data;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                if (!injector<UserRepository>().isComplete())
                  Card(
                    elevation: 0,
                    margin: EdgeInsets.only(left: 8, right: 8, top: 6),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.redAccent.withOpacity(0.7),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Icon(
                                Icons.info,
                                color: Colors.redAccent,
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              fit: FlexFit.tight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Text(
                                      "Please complete your profile!",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      if (!checkIfNotEmpty(user.tagline))
                                        Text(
                                          "- Add Tagline",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      if (!checkIfListIsNotEmpty(
                                          user.educations))
                                        Text(
                                          "- Add Education",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ProfileHeader(
                  user: user,
                  showEmail: true,
                ),
                MyDivider(),
                TaglineSection(
                  user,
                  edit: true,
                ),
                MyDivider(),
                EmailSection(
                  user,
                  edit: true,
                ),
                MyDivider(),
                EducationSection(
                  user,
                  edit: true,
                ),
                MyDivider(),
                WorkSection(
                  user,
                  edit: true,
                ),
                MyDivider(),
                StartupSection(
                  user,
                  edit: true,
                ),
                MyDivider(),
                /* SkillSection(
                  user,
                  edit: true,
                ),
                MyDivider(),*/
                LogoutButton(),
                MyDivider(),
              ],
            ),
          );
        } else if (snapshot.hasError)
          return StreamErrorWidget();
        else
          return Center(
            child: CircularProgressIndicator(),
          );
      },
    );
  }
}
