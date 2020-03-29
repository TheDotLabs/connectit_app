import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectit_app/data/model/startup.dart';
import 'package:connectit_app/data/model/user.dart';
import 'package:connectit_app/routes/routes.dart';
import 'package:connectit_app/utils/constants.dart';
import 'package:connectit_app/utils/top_level_utils.dart';
import 'package:connectit_app/widgets/header.dart';
import 'package:flutter/material.dart';

class StartupSection extends StatelessWidget {
  final User user;
  final bool edit;

  StartupSection(
    this.user, {
    this.edit = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Header("IN STARTUPS"),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (checkIfListIsNotEmpty(user.startups))
                for (final ref in user.startups)
                  FutureBuilder<DocumentSnapshot>(
                    future: _getStartup(ref),
                    builder: (_, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.data != null &&
                          snapshot.data.data != null) {
                        final startup = Startup.fromJson(snapshot.data.data)
                            .copyWith(id: snapshot.data.documentID);

                        return ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.startupDetails,
                              arguments: startup,
                            );
                          },
                          leading: Container(
                            child: CachedNetworkImage(
                              imageUrl: startup.avatar ??
                                  Constants.defaultStartupImage,
                              height: 56,
                              width: 56,
                            ),
                          ),
                          title: Text(startup.name),
                          subtitle: Text(startup.tagline),
                        );
                      } else
                        return Container();
                    },
                  ),
              if (edit)
                Container(
                  height: 40.0,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        Routes.startupEdit,
                        arguments: [false, null],
                      );
                      /*  showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => SimpleDialog(
                          contentPadding: EdgeInsets.all(0),
                          children: <Widget>[
                            StartupEditPage(),
                          ],
                        ),
                      );*/
                    },
                    color: Colors.transparent,
                    elevation: 0,
                    highlightElevation: 0,
                    child: Text(
                      '+ ADD YOUR STARTUP',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
            ],
          )
          // Text(tagline),
        ],
      ),
    );
  }

  Future _getStartup(DocumentReference ref) {
    return ref.get(source: Source.serverAndCache);
  }
}
