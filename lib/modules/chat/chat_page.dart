import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectit_app/data/model/chat.dart';
import 'package:connectit_app/data/model/startup.dart';
import 'package:connectit_app/data/model/user.dart';
import 'package:connectit_app/data/repo/user/base/user_repository.dart';
import 'package:connectit_app/di/injector.dart';
import 'package:connectit_app/utils/top_level_utils.dart';
import 'package:connectit_app/widgets/start_chat.dart';
import 'package:connectit_app/widgets/stream_error.dart';
import 'package:connectit_app/widgets/stream_loading.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class ChatPage extends StatefulWidget {
  final User sender;
  final User receiver;

  ChatPage(this.sender, this.receiver);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();

  bool _showSendBtn = false;

  StreamTransformer<QuerySnapshot, List<Chat>> get _streamTransformer =>
      StreamTransformer.fromHandlers(
          handleData: (QuerySnapshot value, EventSink<List<Chat>> sink) {
        final list = value.documents
            .map((e) => Chat.fromJson(e.data).copyWith(id: e.documentID))
            .toList();
        sink.add(list);
      });

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller.addListener(() {
      if (checkIfNotEmpty(_controller.text)) {
        setState(() {
          _showSendBtn = true;
        });
      } else {
        setState(() {
          _showSendBtn = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 4,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              maxRadius: 18,
              backgroundImage: CachedNetworkImageProvider(
                widget.receiver.avatar,
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Text("${widget.receiver.name}"),
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
        brightness: Brightness.light,
      ),
      body: StreamBuilder<List<Chat>>(
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
                              ...list
                                  .map((e) => ChatBox(e, widget.sender))
                                  .toList()
                            ],
                          )
                        : StartChat(),
                  ),
                  BottomAppBar(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Start typing here..."),
                              maxLines: null,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          IconButton(
                            icon: Icon(LineAwesomeIcons.paper_plane),
                            color: Colors.blueAccent,
                            onPressed: _showSendBtn ? _sendMessage : null,
                          )
                        ],
                      ),
                    ),
                  )
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

  Stream<List<Chat>> _getStream() {
    final id = widget.receiver.id.hashCode ^ widget.sender.id.hashCode;

    final collectionReference = Firestore.instance
        .collection("chats")
        .document(id.toString())
        .collection('messages')
        .orderBy('time');
    return collectionReference.snapshots().transform(_streamTransformer);
  }

  void _sendMessage() async {
    final text = _controller.text;
    final chat = Chat(
      senderId: widget.sender.id,
      receiverId: widget.receiver.id,
      message: text,
      time: DateTime.now().millisecondsSinceEpoch,
      read: true,
    );
    _controller.clear();
    final id = widget.receiver.id.hashCode ^ widget.sender.id.hashCode;

    injector<Firestore>()
        .collection('chats')
        .document(id.toString())
        .collection('messages')
        .add(chat.toJson())
        .then((value) => print(value.path));
    final doc = await injector<Firestore>()
        .collection('chats')
        .document(id.toString())
        .get();
    if (doc != null && doc.exists) {
      injector<Firestore>()
          .collection('chats')
          .document(id.toString())
          .updateData({
        'users': [
          widget.sender.id,
          widget.receiver.id,
        ],
        'time': DateTime.now().millisecondsSinceEpoch,
      });
    } else {
      injector<Firestore>().collection('chats').document(id.toString()).setData(
        {
          'users': [
            widget.sender.id,
            widget.receiver.id,
          ],
          'time': DateTime.now().millisecondsSinceEpoch,
        },
        merge: true,
      );
    }
    injector<Firestore>()
        .collection('chats')
        .document(id.toString())
        .collection('messages')
        .where('read', isEqualTo: false)
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        element.reference.updateData({
          "read": true,
        });
      });
    });
  }
}

class ChatBox extends StatelessWidget {
  final Chat chat;
  final User sender;

  ChatBox(
    this.chat,
    this.sender,
  );

  @override
  Widget build(BuildContext context) {
    return sender.id == chat.senderId
        ? Container(
            margin: EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 4,
            ),
            child: Row(
              children: <Widget>[
                Spacer(),
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * (2 / 3)),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          chat.message ?? "--",
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          DateFormat('dd MMM yy hh:mm').format(
                              DateTime.fromMillisecondsSinceEpoch(chat.time)),
                          textAlign: TextAlign.end,
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container(
            margin: EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 4,
            ),
            child: Row(
              children: <Widget>[
                Flexible(
                  flex: 2,
                  fit: FlexFit.loose,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(chat.message ?? "--"),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          DateFormat('dd MMM yy hh:mm').format(
                              DateTime.fromMillisecondsSinceEpoch(chat.time)),
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
          );
  }
}
