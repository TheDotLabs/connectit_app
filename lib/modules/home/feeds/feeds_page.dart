import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectit_app/data/model/user.dart';
import 'package:connectit_app/data/repo/user/base/user_repository.dart';
import 'package:connectit_app/di/injector.dart';
import 'package:connectit_app/modules/home/feeds/models/feed.dart';
import 'package:connectit_app/routes/routes.dart';
import 'package:connectit_app/utils/log_utils.dart';
import 'package:connectit_app/utils/toast_utils.dart';
import 'package:connectit_app/widgets/app_loader.dart';
import 'package:connectit_app/widgets/cancel_button.dart';
import 'package:connectit_app/widgets/header.dart';
import 'package:connectit_app/widgets/my_divider.dart';
import 'package:connectit_app/widgets/stream_error.dart';
import 'package:connectit_app/widgets/stream_loading.dart';
import 'package:connectit_app/widgets/update_button.dart';
import 'package:connectit_app/widgets/verified_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  StreamTransformer<QuerySnapshot, List<Feed>> get streamTransformer =>
      StreamTransformer.fromHandlers(
        handleData: (QuerySnapshot value, EventSink<List<Feed>> sink) {
          final list = value.documents
              .map((e) => Feed.fromJson(e.data).copyWith(id: e.documentID))
              .toList();
          sink.add(list);
        },
      );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Feed>>(
        stream: _getStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    children: <Widget>[
                      ...snapshot.data.map(
                        (feed) => Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              FutureBuilder<DocumentSnapshot>(
                                  future: _getUser(feed.author),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data != null) {
                                      final user =
                                          User.fromJson(snapshot.data.data)
                                              .copyWith(
                                        id: snapshot.data.documentID,
                                      );
                                      return InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            Routes.visitorProfile,
                                            arguments: user,
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          child: Row(
                                            children: <Widget>[
                                              CircleAvatar(
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                  user.avatar,
                                                ),
                                                radius: 18,
                                              ),
                                              SizedBox(
                                                width: 12,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          user.name,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 4,
                                                        ),
                                                        if (user.isVerified)
                                                          VerifiedBadge()
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 2,
                                                    ),
                                                    Text(
                                                      DateFormat(
                                                              'dd MMM yy hh:mm')
                                                          .format(
                                                        DateTime
                                                            .fromMillisecondsSinceEpoch(
                                                                feed.time),
                                                      ),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline4
                                                          .copyWith(
                                                              fontSize: 12),
                                                    )
                                                  ],
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return ListTile(
                                        title: Text("--"),
                                        subtitle: Text("--"),
                                      );
                                    }
                                  }),
                              MyDivider(),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 8,
                                ),
                                child: Linkify(
                                  text: feed.description ?? "--",
                                  onOpen: (link) async {
                                    if (await canLaunch(link.url)) {
                                      await launch(link.url);
                                    } else {
                                      ToastUtils.show('Could not open link!');
                                    }
                                  },
                                  linkStyle: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                MyDivider(),
                Container(
                  height: 44.0,
                  child: RaisedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => SimpleDialog(
                          contentPadding: EdgeInsets.all(0),
                          children: <Widget>[
                            _MyEditingDialog(),
                          ],
                        ),
                      );
                    },
                    color: Colors.white,
                    elevation: 0,
                    highlightElevation: 0,
                    child: Text(
                      '+ CREATE POST',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              ],
            );
          } else if (snapshot.hasError)
            return StreamErrorWidget();
          else
            return StreamLoadingWidget();
        });
  }

  Stream<List<Feed>> _getStream() {
    return Firestore.instance
        .collection('feeds')
        .where('hidden', isEqualTo: false)
        .orderBy('time', descending: true)
        .snapshots()
        .transform(streamTransformer);
  }

  Future<DocumentSnapshot> _getUser(author) {
    return (author as DocumentReference).get();
  }
}

class _MyEditingDialog extends StatefulWidget {
  _MyEditingDialog();

  @override
  _MyEditingDialogState createState() => _MyEditingDialogState();
}

class _MyEditingDialogState extends State<_MyEditingDialog> {
  TextEditingController _descController;

  bool _isLoading = false;

  int currentYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();

    _descController = TextEditingController.fromValue(
      TextEditingValue(text: ""),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Header(
            "DESCRIPTION",
            marginBottom: 0,
          ),
          TextField(
            controller: _descController,
            maxLines: null,
            decoration: InputDecoration(hintText: "..."),
            style: TextStyle(fontSize: 14),
            maxLength: 1000,
          ),
          SizedBox(
            height: 16,
          ),
          MyDivider(),
          if (_isLoading)
            AppLoader()
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CancelButton(() {
                  Navigator.pop(context);
                }),
                UpdateButton(() {
                  _onUpdate(context, _descController.text);
                }, text: "CREATE"),
              ],
            ),
        ],
      ),
    );
  }

  void _onUpdate(BuildContext context, String text) async {
    try {
      setState(() {
        _isLoading = true;
      });
      final _currentUser = injector<UserRepository>().getLoggedInUser();
      final _userRef =
          injector<Firestore>().collection('users').document(_currentUser.id);
      await injector<Firestore>().collection('feeds').document().setData({
        'author': _userRef,
        'hidden': false,
        'time': DateTime.now().millisecondsSinceEpoch,
        'description': text,
      });
      ToastUtils.show("Post created!");
      Navigator.pop(context);
    } catch (e, s) {
      logger.e(e, s);
      setState(() {
        _isLoading = false;
      });
      ToastUtils.showSomethingWrong();
    }
  }
}
