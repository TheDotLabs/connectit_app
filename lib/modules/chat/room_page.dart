import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectit_app/data/model/room.dart';
import 'package:connectit_app/data/model/user.dart';
import 'package:connectit_app/data/repo/user/base/user_repository.dart';
import 'package:connectit_app/di/injector.dart';
import 'package:connectit_app/routes/routes.dart';
import 'package:connectit_app/utils/top_level_utils.dart';
import 'package:connectit_app/widgets/no_chats.dart';
import 'package:connectit_app/widgets/stream_error.dart';
import 'package:connectit_app/widgets/stream_loading.dart';
import 'package:connectit_app/widgets/verified_badge.dart';
import 'package:flutter/material.dart';

class RoomPage extends StatefulWidget {
  RoomPage();

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  User _currentUser;

  StreamTransformer<QuerySnapshot, List<Room>> get _streamTransformer =>
      StreamTransformer.fromHandlers(
          handleData: (QuerySnapshot value, EventSink<List<Room>> sink) {
        final list = value.documents
            .map((e) => Room.fromJson(e.data).copyWith(id: e.documentID))
            .toList();
        sink.add(list);
      });

  @override
  void initState() {
    super.initState();
    _currentUser = injector<UserRepository>().getLoggedInUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 4,
        title: Text("Inbox"),
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
        brightness: Brightness.light,
      ),
      body: StreamBuilder<List<Room>>(
          stream: _getStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              final list = snapshot.data ?? [];
              //final list = [];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: list.isNotEmpty
                        ? ListView(
                            padding: EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 4,
                            ),
                            children: <Widget>[
                              for (var i = 0; i < list.length; i++)
                                FutureBuilder<DocumentSnapshot>(
                                  future: _getReceiverUser(list[i].users),
                                  builder: (_, snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data != null) {
                                      final user =
                                          User.fromJson(snapshot.data.data)
                                              .copyWith(
                                                  id: snapshot.data.documentID);
                                      return ListTile(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            Routes.chat,
                                            arguments: [
                                              _currentUser,
                                              user,
                                            ],
                                          );
                                        },
                                        leading: CircleAvatar(
                                          backgroundImage:
                                              CachedNetworkImageProvider(
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
                                      );
                                    } else {
                                      return ListTile(
                                        title: Text(""),
                                        subtitle: Text(""),
                                      );
                                    }
                                  },
                                )
                            ],
                          )
                        : NoChats(),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return StreamErrorWidget();
            } else {
              return StreamLoadingWidget();
            }
          }),
    );
  }

  Stream<List<Room>> _getStream() {
    final collectionReference = Firestore.instance
        .collection("chats")
        .where('users', arrayContains: _currentUser.id)
        .orderBy('time');
    return collectionReference.snapshots().transform(_streamTransformer);
  }

  _getReceiverUser(List<String> users) {
    final receiverId =
        users.firstWhere((element) => element != _currentUser.id);

    return Firestore.instance
        .collection("users")
        .document(receiverId)
        .get(source: Source.cache);
  }
}
