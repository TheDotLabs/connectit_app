import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectit_app/data/model/startup.dart';
import 'package:connectit_app/routes/routes.dart';
import 'package:connectit_app/utils/constants.dart';
import 'package:connectit_app/widgets/verified_badge.dart';
import 'package:flutter/material.dart';

class StartupCard extends StatelessWidget {
  final Startup item;

  StartupCard(this.item);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.4,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 2,
        ),
        child: InkWell(
          onTap: () {
            _onTap(context);
          },
          child: Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              side: BorderSide(color: Theme.of(context).dividerColor),
            ),
            elevation: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1.8,
                    child: CachedNetworkImage(
                      imageUrl: item.avatar ?? Constants.defaultStartupImage,
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            item.name ?? "--",
                            style:
                                Theme.of(context).textTheme.subtitle1.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      letterSpacing: 1.05,
                                    ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          if (item.isVerified) VerifiedBadge(),
                        ],
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        item.tagline ?? "--",
                        style: Theme.of(context)
                            .textTheme
                            .display1
                            .copyWith(fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context) {
    Navigator.pushNamed(context, Routes.startupDetails, arguments: item);
  }
}
