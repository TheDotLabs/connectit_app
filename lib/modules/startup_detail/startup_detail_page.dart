import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectit_app/data/model/startup.dart';
import 'package:connectit_app/modules/startup_detail/widgets/description_section.dart';
import 'package:connectit_app/modules/startup_detail/widgets/facebook_section.dart';
import 'package:connectit_app/modules/startup_detail/widgets/founders_section.dart';
import 'package:connectit_app/modules/startup_detail/widgets/linkedin_section.dart';
import 'package:connectit_app/modules/startup_detail/widgets/website_section.dart';
import 'package:connectit_app/utils/constants.dart';
import 'package:connectit_app/utils/top_level_utils.dart';
import 'package:connectit_app/widgets/my_divider.dart';
import 'package:connectit_app/widgets/verified_badge.dart';
import 'package:flutter/material.dart';

class StartupDetailPage extends StatefulWidget {
  final Startup item;

  StartupDetailPage(this.item);

  @override
  _StartupDetailPageState createState() => _StartupDetailPageState();
}

class _StartupDetailPageState extends State<StartupDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
        brightness: Brightness.light,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: widget.item.avatar ?? Constants.defaultStartupImage,
              fit: BoxFit.fitHeight,
              height: 200,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
            ),
            Divider(
              height: 1,
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.item.name,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(letterSpacing: 1.05),
                      ),
                      if (widget.item.isVerified)
                        SizedBox(
                          width: 6,
                        ),
                      if (widget.item.isVerified) VerifiedBadge()
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    widget.item.tagline,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
            MyDivider(),
            SizedBox(
              height: 8,
            ),
            DescriptionSection(widget.item.description),
            MyDivider(),
            FoundersSection(widget.item.founders),
            MyDivider(),
            if (checkIfNotEmpty(widget.item.website))
              WebsiteSection(widget.item.website),
            if (checkIfNotEmpty(widget.item.website)) MyDivider(),
            if (checkIfNotEmpty(widget.item.facebook))
              Facebook_Section(widget.item.facebook),
            if (checkIfNotEmpty(widget.item.facebook)) MyDivider(),
            if (checkIfNotEmpty(widget.item.linkedIn))
              LinkedInSection(widget.item.linkedIn),
            if (checkIfNotEmpty(widget.item.linkedIn)) MyDivider(),
          ],
        ),
      ),
    );
  }
}
