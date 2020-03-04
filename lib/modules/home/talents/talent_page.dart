import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectit_app/data/model/user.dart';
import 'package:connectit_app/data/repo/user/base/user_repository.dart';
import 'package:connectit_app/di/injector.dart';
import 'package:connectit_app/routes/routes.dart';
import 'package:connectit_app/utils/top_level_utils.dart';
import 'package:connectit_app/widgets/stream_error.dart';
import 'package:connectit_app/widgets/stream_loading.dart';
import 'package:connectit_app/widgets/verified_badge.dart';
import 'package:flutter/material.dart';

class TalentPage extends StatefulWidget {
  @override
  _TalentPageState createState() => _TalentPageState();
}

class _TalentPageState extends State<TalentPage> {
  User _currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentUser = injector<UserRepository>().getLoggedInUser();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _getStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      if (!injector<UserRepository>().isComplete())
                        Card(
                          elevation: 0,
                          margin: EdgeInsets.only(left: 8, right: 8, top: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.redAccent.withOpacity(0.7),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ListTile(
                                leading: Icon(
                                  Icons.info,
                                  color: Colors.redAccent,
                                ),
                                title: Text(
                                  "Please complete your profile to get listed here!",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      SizedBox(
                        height:
                            (!injector<UserRepository>().isComplete()) ? 8 : 0,
                      ),
                      ...snapshot.data.documents
                          .map((e) =>
                              User.fromJson(e.data).copyWith(id: e.documentID))
                          .where((element) =>
                              checkIfListIsNotEmpty(element.educations))
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
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 2,
                                ),
                                leading: CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                    user.avatar,
                                  ),
                                ),
                                title: Row(
                                  children: <Widget>[
                                    Text(
                                      user.name,
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    if (user.isVerified) VerifiedBadge()
                                  ],
                                ),
                                subtitle: checkIfNotEmpty(user.tagline)
                                    ? Text(
                                        user.tagline,
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                          ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
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
    return Firestore.instance
        .collection('users')
        .where('tagline', isGreaterThan: "")
        .snapshots();
  }
}
