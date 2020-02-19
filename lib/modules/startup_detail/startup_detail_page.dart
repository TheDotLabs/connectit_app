import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectit_app/data/model/startup.dart';
import 'package:connectit_app/modules/startup_detail/widgets/description_section.dart';
import 'package:connectit_app/modules/startup_detail/widgets/facebook_section.dart';
import 'package:connectit_app/modules/startup_detail/widgets/founders_section.dart';
import 'package:connectit_app/modules/startup_detail/widgets/linkedin_section.dart';
import 'package:connectit_app/modules/startup_detail/widgets/website_section.dart';
import 'package:connectit_app/utils/constants.dart';
import 'package:connectit_app/utils/top_level_utils.dart';
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
              fit: BoxFit.cover,
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
                  Text(
                    widget.item.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    widget.item.tagline,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
            ),
            SizedBox(
              height: 8,
            ),
            DescriptionSection(widget.item.description),
            FoundersSection(widget.item.founders),
            if (checkIfNotEmpty(widget.item.website)) WebsiteSection(widget.item.website),
            if (checkIfNotEmpty(widget.item.facebook)) Facebook_Section(widget.item.facebook),
            if (checkIfNotEmpty(widget.item.linkedIn)) LinkedInSection(widget.item.linkedIn),
          ],
        ),
      ),
    );
  }
}
