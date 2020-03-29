import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectit_app/constants/images.dart';
import 'package:connectit_app/data/model/skill.dart';
import 'package:connectit_app/di/injector.dart';
import 'package:connectit_app/utils/top_level_utils.dart';
import 'package:connectit_app/widgets/app_loader.dart';
import 'package:connectit_app/widgets/cancel_button.dart';
import 'package:connectit_app/widgets/header.dart';
import 'package:connectit_app/widgets/my_divider.dart';
import 'package:connectit_app/widgets/stream_error.dart';
import 'package:connectit_app/widgets/stream_loading.dart';
import 'package:connectit_app/widgets/update_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:rxdart/rxdart.dart';

class SkillsEditPage extends StatefulWidget {
  SkillsEditPage();

  @override
  _MyEditingDialogState createState() => _MyEditingDialogState();
}

class _MyEditingDialogState extends State<SkillsEditPage> {
  TextEditingController _textController;

  bool _isLoading = false;

  int currentYear = DateTime.now().year;

  BehaviorSubject<QuerySnapshot> _stream;

  String _text;

  @override
  void initState() {
    super.initState();

    _textController = TextEditingController.fromValue(
      TextEditingValue(text: ""),
    );
    _textController.addListener(() {
      setState(() {
        _text = _textController.text;
      });
    });
    _stream =
        injector<Firestore>().collection('skills').snapshots().shareValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Your Skills",
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Opacity(
              opacity: 0.9,
              child: SvgPicture.asset(
                Images.ADD_STARTUP,
                width: MediaQuery.of(context).size.width / 3,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            MyDivider(),
            SizedBox(
              height: 16,
            ),
            Header(
              "ADD SKILL",
              marginBottom: 0,
            ),
            SizedBox(
              height: 4,
            ),
            TextField(
              controller: _textController,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: "Search your skill...",
                suffixIcon: Icon(
                  LineAwesomeIcons.search,
                  size: 20,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 6, vertical: 14),
                border: InputBorder.none,
              ),
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            MyDivider(),
            SizedBox(
              height: 8,
            ),
            StreamBuilder<List<Skill>>(
                stream: _getStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null)
                    return Expanded(
                      child: snapshot.data.isNotEmpty
                          ? ListView(
                              children: <Widget>[
                                ...snapshot.data.map(
                                  (e) => ListTile(
                                    dense: true,
                                    title: Text(e.name),
                                    leading: checkIfNotEmpty(e.image)
                                        ? CachedNetworkImage(
                                            imageUrl: e.image,
                                            height: 24,
                                          )
                                        : SizedBox(
                                            height: 24,
                                          ),
                                  ),
                                )
                              ],
                            )
                          : Center(
                              child: Text(
                                "No items found",
                              ),
                            ),
                    );
                  else if (snapshot.hasError)
                    return StreamErrorWidget();
                  else
                    return StreamLoadingWidget();
                }),
            MyDivider(),
            if (_isLoading)
              AppLoader()
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  UpdateButton(
                    () {},
                    text: "UPDATE",
                  ),
                  MyDivider(),
                  CancelButton(
                    () {
                      Navigator.pop(context);
                    },
                  ),
                  MyDivider(),
                ],
              ),
          ],
        ),
      ),
    );
  }

  StreamTransformer<QuerySnapshot, List<Skill>> get streamTransformer =>
      StreamTransformer.fromHandlers(
        handleData: (QuerySnapshot value, EventSink<List<Skill>> sink) {
          final list = value.documents
              .map((e) => Skill.fromJson(e.data).copyWith(id: e.documentID))
              .toList();
          if (checkIfNotEmpty(_text)) {
            list.retainWhere(
                (element) => element.name.toLowerCase().contains(_text));
          }
          sink.add(list);
        },
      );

  Stream<List<Skill>> _getStream() {
    return _stream.transform(streamTransformer);
  }

  @override
  void dispose() {
    _stream.close();
    super.dispose();
  }
}
