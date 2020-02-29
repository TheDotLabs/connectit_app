import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectit_app/data/model/user.dart';
import 'package:connectit_app/data/repo/user/base/user_repository.dart';
import 'package:connectit_app/di/injector.dart';
import 'package:connectit_app/modules/home/feeds/models/feed.dart';
import 'package:connectit_app/routes/routes.dart';
import 'package:connectit_app/utils/log_utils.dart';
import 'package:connectit_app/utils/toast_utils.dart';
import 'package:connectit_app/utils/top_level_utils.dart';
import 'package:connectit_app/widgets/add_image.dart';
import 'package:connectit_app/widgets/app_loader.dart';
import 'package:connectit_app/widgets/cancel_button.dart';
import 'package:connectit_app/widgets/header.dart';
import 'package:connectit_app/widgets/my_divider.dart';
import 'package:connectit_app/widgets/stream_error.dart';
import 'package:connectit_app/widgets/stream_loading.dart';
import 'package:connectit_app/widgets/update_button.dart';
import 'package:connectit_app/widgets/verified_badge.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:path/path.dart' as Path;
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
                        margin: EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        child: Card(
                          elevation: 0,
                          margin: EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                                              'dd MMM yy hh:mm a')
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
                              if (checkIfNotEmpty(feed.avatar))
                                ConstrainedBox(
                                  constraints: BoxConstraints(maxHeight: 220),
                                  child: CachedNetworkImage(
                                    imageUrl: feed.avatar,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              if ((feed.author as DocumentReference)
                                      .documentID !=
                                  injector<UserRepository>()
                                      .getLoggedInUser()
                                      .id)
                                MyDivider(),
                              if ((feed.author as DocumentReference)
                                      .documentID !=
                                  injector<UserRepository>()
                                      .getLoggedInUser()
                                      .id)
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
                                      return Container(
                                        height: 48.0,
                                        child: RaisedButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              Routes.chat,
                                              arguments: [
                                                injector<UserRepository>()
                                                    .getLoggedInUser(),
                                                user,
                                              ],
                                            );
                                          },
                                          color: Colors.white,
                                          elevation: 0,
                                          highlightElevation: 0,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Icon(
                                                LineAwesomeIcons.comments,
                                                color: Colors.blue,
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                'MESSAGE',
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),

                              /*if (us
                              er.id !=
                                  injector<UserRepository>().getLoggedInUser().id)
                                Container(
                                  height: 48.0,
                                  child: RaisedButton(
                                    onPressed: () {
                                      */ /* injector<UserRepository>().logoutUser();
                          Navigator.pushNamedAndRemoveUntil(
                              context, Routes.login, (route) => false);*/ /*
                                      Navigator.pushNamed(
                                        context,
                                        Routes.chat,
                                        arguments: [
                                          injector<UserRepository>().getLoggedInUser(),
                                          widget.user,
                                        ],
                                      );
                                    },
                                    color: Colors.white,
                                    elevation: 0,
                                    highlightElevation: 0,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Icon(
                                          LineAwesomeIcons.comments,
                                          color: Colors.blue,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          'MESSAGE',
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),*/
                            ],
                          ),
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
      },
    );
  }

  Stream<List<Feed>> _getStream() {
    return Firestore.instance
        .collection('feeds')
        .orderBy('time', descending: true)
        .where('hidden', isEqualTo: false)
        .limit(20)
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
  File _file;

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
            "POST SOMETHING",
            marginBottom: 0,
          ),
          SizedBox(
            height: 8,
          ),
          AddImage(_file, _onImageTap),
          TextField(
            controller: _descController,
            maxLines: null,
            minLines: 2,
            decoration: InputDecoration(hintText: "..."),
            style: TextStyle(fontSize: 14),
            maxLength: 1000,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.multiline,
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
                UpdateButton(
                  () {
                    _onUpdate(context, _descController.text);
                  },
                  text: "CREATE",
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _onUpdate(BuildContext context, String text) async {
    try {
      if (!checkIfNotEmpty(text)) {
        ToastUtils.show("Post can't be empty!");
        return;
      }
      setState(() {
        _isLoading = true;
      });
      final _currentUser = injector<UserRepository>().getLoggedInUser();
      final _userRef =
          injector<Firestore>().collection('users').document(_currentUser.id);

      String avatar;

      if (_file != null) {
        final storageReference =
            FirebaseStorage().ref().child('feeds/${Path.basename(_file.path)}');
        final uploadTask = storageReference.putFile(_file);
        await uploadTask.onComplete;
        logger.d('File Uploaded');
        avatar = await storageReference.getDownloadURL();
      }
      await injector<Firestore>().collection('feeds').document().setData({
        'author': _userRef,
        'hidden': false,
        'time': DateTime.now().millisecondsSinceEpoch,
        'description': text,
        'avatar': avatar,
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

  void _onImageTap() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
    );

    setState(() {
      _file = image;
    });
  }
}
