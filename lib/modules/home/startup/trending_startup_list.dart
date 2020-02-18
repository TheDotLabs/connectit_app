import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectit_app/data/model/startup.dart';
import 'package:connectit_app/di/injector.dart';
import 'package:connectit_app/modules/home/startup/widgets/startup_card.dart';
import 'package:connectit_app/utils/constants.dart';
import 'package:connectit_app/widgets/empty.dart';
import 'package:connectit_app/widgets/stream_error.dart';
import 'package:connectit_app/widgets/stream_loading.dart';
import 'package:flutter/material.dart';

class TrendingStartupList extends StatelessWidget {
  StreamTransformer<QuerySnapshot, List<Startup>> get streamTransformer => StreamTransformer.fromHandlers(handleData: (QuerySnapshot value, EventSink<List<Startup>> sink) {
        final list = value.documents.map((e) => Startup.fromJson(e.data)).toList();
        sink.add(list);
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Constants.startupListHeight,
      child: StreamBuilder<List<Startup>>(
          stream: _getStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              final list = snapshot.data;
              if (list.isEmpty) return EmptyWidget();

              return ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: 4,
                ),
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  for (int i = 0; i < list.length; i++) StartupCard(list[i]),
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

  Stream<List<Startup>> _getStream() {
    return injector<Firestore>().collection(Constants.startupsCollection).where(Constants.isTrending, isEqualTo: true).snapshots().transform(streamTransformer);
  }
}
