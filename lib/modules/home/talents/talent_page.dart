import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectit_app/data/model/user.dart';
import 'package:connectit_app/modules/home/widgets/menu_header.dart';
import 'package:connectit_app/widgets/stream_error.dart';
import 'package:connectit_app/widgets/stream_loading.dart';
import 'package:connectit_app/widgets/under_construction.dart';
import 'package:flutter/material.dart';

class TalentPage extends StatefulWidget {
  @override
  _TalentPageState createState() => _TalentPageState();
}

class _TalentPageState extends State<TalentPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return ListView(
              children: <Widget>[
                SizedBox(
                  height: 8,
                ),
                MenuHeader("EXPLORE TALENTS"),
                GridView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.9,
                  ),
                  children: <Widget>[
                    ...snapshot.data.documents
                        .map((e) => User.fromJson(e.data))
                        .map(
                          (e) => Container(
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              margin: EdgeInsets.all(0),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                side: BorderSide(
                                    color: Theme.of(context).dividerColor),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Expanded(
                                    child: Image.network(
                                      e.avatar,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          e.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          "Description",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                  ],
                ),
                SizedBox(
                  height: 32,
                ),
                UnderConstruction(),
                SizedBox(
                  height: 32,
                ),
              ],
            );
          } else if (snapshot.hasError)
            return StreamErrorWidget();
          else
            return StreamLoadingWidget();
        });
  }
}
