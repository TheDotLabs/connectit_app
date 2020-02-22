import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectit_app/data/model/user.dart';
import 'package:connectit_app/routes/routes.dart';
import 'package:connectit_app/utils/top_level_utils.dart';
import 'package:connectit_app/widgets/SectionContainer.dart';
import 'package:connectit_app/widgets/header.dart';
import 'package:connectit_app/widgets/verified_badge.dart';
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
          Header("TEAM MEMBERS (${list?.length ?? 0})"),
          if (list != null)
            for (var i = 0; i < list.length; i++)
              FutureBuilder<DocumentSnapshot>(
                future:
                    (list[i] as DocumentReference).get(source: Source.cache),
                builder: (_, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    final user = User.fromJson(snapshot.data.data)
                        .copyWith(id: snapshot.data.documentID);
                    return ListTile(
                      onTap: () {
                        Navigator.pushNamed(
                          _,
                          Routes.visitorProfile,
                          arguments: user,
                        );
                      },
                      leading: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
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
              ),
        ],
      ),
    );
  }
}
