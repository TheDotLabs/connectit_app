import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectit_app/data/model/user.dart';
import 'package:connectit_app/modules/startup_detail/utils/constants.dart';
import 'package:connectit_app/utils/top_level_utils.dart';
import 'package:connectit_app/widgets/SectionContainer.dart';
import 'package:connectit_app/widgets/app_loader.dart';
import 'package:connectit_app/widgets/header.dart';
import 'package:connectit_app/widgets/stream_loading.dart';
import 'package:flutter/material.dart';

class FoundersSection extends StatelessWidget {
  List list;

  FoundersSection(this.list);

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Header("FOUNDERS (${list?.length ?? 0})"),
          if (list != null)
            for (var i = 0; i < list.length; i++)
              FutureBuilder<DocumentSnapshot>(
                future: (list[i] as DocumentReference).get(),
                builder: (_, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    final user = User.fromJson(snapshot.data.data);
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          user.avatar,
                        ),
                      ),
                      title: Text(user.name),
                      isThreeLine: checkIfNotEmpty(user.tagline) ? true : false,
                      subtitle: checkIfNotEmpty(user.tagline)
                          ? Text(user.tagline)
                          : null,
                    );
                  } else {
                    return AppLoader();
                  }
                },
              ),
        ],
      ),
    );
  }
}
