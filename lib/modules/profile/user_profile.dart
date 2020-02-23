import 'package:connectit_app/data/model/user.dart';
import 'package:connectit_app/modules/profile/widgets/edu_section.dart';
import 'package:connectit_app/modules/profile/widgets/profile_header.dart';
import 'package:connectit_app/modules/profile/widgets/startups_section.dart';
import 'package:connectit_app/modules/profile/widgets/tag_section.dart';
import 'package:connectit_app/widgets/my_divider.dart';
import 'package:connectit_app/widgets/stream_error.dart';
import 'package:flutter/material.dart';

import 'bloc.dart';
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
