import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectit_app/data/model/startup.dart';
import 'package:connectit_app/data/repo/user/base/user_repository.dart';
import 'package:connectit_app/di/injector.dart';
import 'package:connectit_app/modules/startup_detail/widgets/admin_section.dart';
import 'package:connectit_app/modules/startup_detail/widgets/description_section.dart';
import 'package:connectit_app/modules/startup_detail/widgets/facebook_section.dart';
import 'package:connectit_app/modules/startup_detail/widgets/founders_section.dart';
import 'package:connectit_app/modules/startup_detail/widgets/linkedin_section.dart';
import 'package:connectit_app/modules/startup_detail/widgets/website_section.dart';
import 'package:connectit_app/utils/constants.dart';
import 'package:connectit_app/utils/top_level_utils.dart';
import 'package:connectit_app/widgets/my_divider.dart';
import 'package:connectit_app/widgets/stream_error.dart';
import 'package:connectit_app/widgets/stream_loading.dart';
import 'package:connectit_app/widgets/verified_badge.dart';
import 'package:flutter/material.dart';

class StartupDetailPage extends StatefulWidget {
  final Startup startup;

  StartupDetailPage(this.startup);

  @override
  _StartupDetailPageState createState() => _StartupDetailPageState();
}

class _StartupDetailPageState extends State<StartupDetailPage> {
  StreamTransformer<DocumentSnapshot, Startup> get _streamTransformer =>
      StreamTransformer.fromHandlers(
        handleData: (DocumentSnapshot value, EventSink<Startup> sink) {
          sink.add(
            Startup.fromJson(value.data).copyWith(
              id: value.documentID,
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
        brightness: Brightness.light,
      ),
      body: StreamBuilder<Startup>(
          stream: _getStream(),
          initialData: widget.startup,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              final startup = snapshot.data;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: startup.avatar ?? Constants.defaultStartupImage,
                      fit: BoxFit.fitHeight,
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                    ),
                    Divider(
                      height: 1,
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                startup.name,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(letterSpacing: 1.05),
                              ),
                              if (startup.isVerified)
                                SizedBox(
                                  width: 6,
                                ),
                              if (startup.isVerified) VerifiedBadge()
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            startup.tagline,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    MyDivider(),
                    SizedBox(
                      height: 8,
                    ),
                    DescriptionSection(
                      startup,
                      edit: _shouldEdit(startup),
                    ),
                    MyDivider(),
                    FoundersSection(startup.founders),
                    MyDivider(),
                    AdminSection(startup),
                    MyDivider(),
                    if (checkIfNotEmpty(startup.website))
                      WebsiteSection(startup.website),
                    if (checkIfNotEmpty(startup.website)) MyDivider(),
                    if (checkIfNotEmpty(startup.facebook))
                      Facebook_Section(startup.facebook),
                    if (checkIfNotEmpty(startup.facebook)) MyDivider(),
                    if (checkIfNotEmpty(startup.linkedIn))
                      LinkedInSection(startup.linkedIn),
                    if (checkIfNotEmpty(startup.linkedIn)) MyDivider(),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return StreamErrorWidget();
            } else {
              return StreamLoadingWidget();
            }
          }),
    );
  }

  bool _shouldEdit(Startup startup) {
    final currentUser = injector<UserRepository>().getLoggedInUser();
    if (checkIfListIsNotEmpty(startup.admins)) {
      if (startup.admins
          .map((e) => (e as DocumentReference).documentID)
          .contains(currentUser.id)) {
        return true;
      }
    }
    return false;
  }

  Stream<Startup> _getStream() {
    return injector<Firestore>()
        .collection('startups')
        .document(widget.startup.id)
        .snapshots()
        .transform(_streamTransformer);
  }
}
