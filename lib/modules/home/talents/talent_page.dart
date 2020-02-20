import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectit_app/data/model/user.dart';
import 'package:connectit_app/modules/home/widgets/menu_header.dart';
import 'package:connectit_app/routes/routes.dart';
import 'package:connectit_app/utils/top_level_utils.dart';
import 'package:connectit_app/widgets/stream_error.dart';
import 'package:connectit_app/widgets/stream_loading.dart';
import 'package:connectit_app/widgets/under_construction.dart';
import 'package:connectit_app/widgets/verified_badge.dart';
import 'package:flutter/material.dart';

class TalentPage extends StatefulWidget {
  @override
  _TalentPageState createState() => _TalentPageState();
}

class _TalentPageState extends State<TalentPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _getStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return ListView(
              children: <Widget>[
                SizedBox(
                  height: 8,
                ),
                MenuHeader("EXPLORE TALENTS"),
                ...snapshot.data.documents
                    .map(
                        (e) => User.fromJson(e.data).copyWith(id: e.documentID))
                    .map(
                      (user) => Container(
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.visitorProfile,
                              arguments: user,
                            );
                          },
                          leading: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                              user.avatar,
                            ),
                          ),
                          title: Row(
                            children: <Widget>[
                              Text(user.name),
                              SizedBox(
                                width: 4,
                              ),
                              if (user.isVerified) VerifiedBadge()
                            ],
                          ),
                          subtitle: checkIfNotEmpty(user.tagline)
                              ? Text(user.tagline)
                              : null,
                        ),
                      ),
                    ),
              ],
            );
          } else if (snapshot.hasError)
            return StreamErrorWidget();
          else
            return StreamLoadingWidget();
        });
  }

  _getStream() {
    return Firestore.instance.collection('users').snapshots();
  }
}
