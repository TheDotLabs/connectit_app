import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectit_app/constants/images.dart';
import 'package:connectit_app/modules/home/feeds/feeds_page.dart';
import 'package:connectit_app/modules/home/startup/startup_page.dart';
import 'package:connectit_app/modules/home/talents/talent_page.dart';
import 'package:connectit_app/modules/profile/index.dart';
import 'package:connectit_app/routes/routes.dart';
import 'package:connectit_app/widgets/svg_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    StartupPage(),
    FeedPage(),
    TalentPage(),
    ProfilePage(),
  ];

  int _messages = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMessageFuture();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            SvgIcon(
              assetName: Images.logo,
              height: 32,
              width: 32,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              "Connect IT- Demo",
            ),
          ],
        ),
        actions: <Widget>[
          Stack(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  LineAwesomeIcons.envelope,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, Routes.chatRoom);
                },
              ),
              if (_messages > 0)
                Positioned(
                  right: 6,
                  top: 8,
                  child: Container(
                    height: 18,
                    width: 18,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.redAccent,
                    ),
                    child: Text(
                      '${_messages.toString()}',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                )
            ],
          )
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: _onTabTapped,
        // new
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(LineAwesomeIcons.home),
            title: new Text('Startups'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(LineAwesomeIcons.copy),
            title: new Text('Feeds'),
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

  Future<QuerySnapshot> _getMessageFuture() async {
    final FirebaseUser _currentUser = await FirebaseAuth.instance.currentUser();
    Firestore.instance
        .collection("chats")
        .where('users', arrayContains: _currentUser.uid)
        .snapshots()
        .listen(
      (event) {
        setState(() {
          _messages = 0;
        });
        event.documents.forEach((element) async {
          final docs = await element.reference
              .collection('messages')
              .where('receiverId', isEqualTo: _currentUser.uid)
              .where(
                'read',
                isEqualTo: false,
              )
              .getDocuments(source: Source.serverAndCache);

          final count = docs.documents.length;
          if (mounted) {
            setState(() {
              print("message: " + _messages.toString());
              print("count: " + count.toString());
              _messages = _messages + count;
            });
          }
        });
      },
    );
  }
}
