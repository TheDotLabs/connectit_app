import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectit_app/data/model/user.dart';
import 'package:connectit_app/widgets/SectionContainer.dart';
import 'package:connectit_app/widgets/verified_badge.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final User user;
  final bool showEmail;

  const ProfileHeader({
    Key key,
    @required this.user,
    this.showEmail = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SectionContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: <Widget>[
            SizedBox(width: 16.0),
            CircleAvatar(
              radius: 30,
              backgroundImage: CachedNetworkImageProvider(user.avatar),
            ),
            SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    if (user.isVerified) VerifiedBadge(),
                  ],
                ),
                if (showEmail)
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
