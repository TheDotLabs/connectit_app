import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectit_app/data/model/user.dart';
import 'package:connectit_app/widgets/SectionContainer.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final User user;

  const ProfileHeader({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SectionContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: <Widget>[
            SizedBox(width: 16.0),
            CircleAvatar(
              radius: (size.height * 0.1) / 2,
              backgroundImage: CachedNetworkImageProvider(user.avatar),
            ),
            SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  user.email,
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
