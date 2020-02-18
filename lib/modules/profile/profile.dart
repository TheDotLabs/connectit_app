import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectit_app/constants/images.dart';
import 'package:connectit_app/data/model/result.dart';
import 'package:connectit_app/data/model/user.dart';
import 'package:connectit_app/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import 'bloc.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _bloc = ProfileBloc();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Result<User>>(
      future: _bloc.fetchUserInfo(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? snapshot.data.when(
                (result) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      ProfileHeader(user: result),
                      HelpAndSupportContainer(),
                      LogoutButton(),
                    ],
                  ),
                ),
                loading: () {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
                error: (error) {
                  return Container(
                    child: Text(error?.toString() ?? "some error"),
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final User user;

  const ProfileHeader({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ProfileContainer(
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

class BagAndOrderContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProfileContainer(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: SvgIcon(assetName: Images.RECEIPT),
            title: Text('Orders'),
          ),
          Divider(height: 1.0),
          ListTile(
            leading: SvgIcon(assetName: Images.SHOPPING_BAG),
            title: Text('My Bag'),
          ),
          Divider(height: 1.0),
          ListTile(
            leading: Icon(
              LineAwesomeIcons.heart_o,
              color: Colors.black,
            ),
            title: Text('Wishlist'),
          ),
        ],
      ),
    );
  }
}

class AddressAndPaymentContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProfileContainer(
        child: Column(
      children: <Widget>[
        ListTile(
          leading: Icon(
            LineAwesomeIcons.map_signs,
            color: Colors.black,
          ),
          title: Text('Address'),
        ),
        Divider(height: 1.0),
        ListTile(
          leading: Icon(
            LineAwesomeIcons.credit_card,
            color: Colors.black,
          ),
          title: Text('Payments'),
        )
      ],
    ));
  }
}

class HelpAndSupportContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProfileContainer(
        child: Column(
      children: <Widget>[
        ListTile(
          leading: Icon(
            LineAwesomeIcons.info_circle,
            color: Colors.black,
          ),
          title: Text('Help & FAQ\'s'),
        ),
        Divider(height: 1.0),
        ListTile(
          leading: Icon(
            LineAwesomeIcons.phone,
            color: Colors.black,
          ),
          title: Text('Connect with us'),
        )
      ],
    ));
  }
}

class ProfileContainer extends StatelessWidget {
  final Widget child;

  const ProfileContainer({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: child,
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        height: 48.0,
        child: RaisedButton(
          onPressed: () {},
          color: Colors.white,
          elevation: 0.5,
          highlightElevation: 0.5,
          child: Text(
            'LOGOUT',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
}
