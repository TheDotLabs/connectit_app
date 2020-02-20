import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectit_app/data/model/user.dart';
import 'package:connectit_app/modules/profile/widgets/edu_section.dart';
import 'package:connectit_app/modules/profile/widgets/profile_header.dart';
import 'package:connectit_app/modules/profile/widgets/startups_section.dart';
import 'package:connectit_app/modules/profile/widgets/tag_section.dart';
import 'package:connectit_app/utils/top_level_utils.dart';
import 'package:connectit_app/widgets/my_divider.dart';
import 'package:connectit_app/widgets/stream_error.dart';
import 'package:flutter/material.dart';

import 'bloc.dart';
import 'widgets/logout_button.dart';

class VisitorProfilePage extends StatefulWidget {
  final User user;
  VisitorProfilePage(this.user);
  @override
  _VisitorProfilePageState createState() => _VisitorProfilePageState();
}

class _VisitorProfilePageState extends State<VisitorProfilePage> {
  final _bloc = ProfileBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        title: Text("Profile"),
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _bloc.fetchVisitorInfo(widget.user.id),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final user = User.fromJson(snapshot.data.data).copyWith(
              id: snapshot.data.documentID,
            );
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  ProfileHeader(user: user),
                  MyDivider(),
                  if (checkIfNotEmpty(user.tagline)) TaglineSection(user),
                  if (checkIfNotEmpty(user.tagline)) MyDivider(),
                  if (checkIfListIsNotEmpty(user.educations))
                    EducationSection(user),
                  if (checkIfListIsNotEmpty(user.educations)) MyDivider(),
                  if (checkIfListIsNotEmpty(user.works)) EducationSection(user),
                  if (checkIfListIsNotEmpty(user.works)) MyDivider(),
                  if (checkIfListIsNotEmpty(user.startups))
                    StartupSection(user.startups),
                  if (checkIfListIsNotEmpty(user.startups)) MyDivider(),
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
      ),
    );
  }
}
