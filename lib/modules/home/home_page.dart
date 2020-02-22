import 'package:connectit_app/modules/home/startup/startup_page.dart';
import 'package:connectit_app/modules/home/talents/talent_page.dart';
import 'package:connectit_app/modules/profile/index.dart';
import 'package:connectit_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [StartupPage(), TalentPage(), ProfilePage()];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        title: Text("Connect IT- Demo"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              LineAwesomeIcons.envelope,
              color: Colors.black87,
            ),
            onPressed: () {
              Navigator.pushNamed(context, Routes.chatRoom);
            },
          )
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTabTapped, // new
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(LineAwesomeIcons.home),
            title: new Text('Startups'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(LineAwesomeIcons.users),
            title: new Text('Talents'),
          ),
          BottomNavigationBarItem(
            icon: Icon(LineAwesomeIcons.user),
            title: Text('Profile'),
          )
        ],
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
