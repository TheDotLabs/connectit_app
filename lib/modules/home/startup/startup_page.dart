import 'package:connectit_app/modules/home/widgets/menu_header.dart';
import 'package:flutter/material.dart';

import 'new_startup_list.dart';
import 'trending_startup_list.dart';
import 'upcoming_startup_list.dart';

class StartupPage extends StatefulWidget {
  @override
  _StartupPageState createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(children: [
        SizedBox(
          height: 6,
        ),
        MenuHeader("TRENDING STARTUPS"),
        TrendingStartupList(),
        SizedBox(
          height: 2,
        ),
        MenuHeader("NEW STARTUPS"),
        NewStartupList(),
        SizedBox(
          height: 2,
        ),
        MenuHeader("UPCOMING STARTUPS"),
        UpcomingStartupList(),
        SizedBox(
          height: 12,
        ),
      ]),
    );
  }
}
