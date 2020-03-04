import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectit_app/data/model/user.dart';
import 'package:connectit_app/data/repo/user/base/user_repository.dart';
import 'package:connectit_app/di/injector.dart';
import 'package:connectit_app/utils/toast_utils.dart';
import 'package:connectit_app/widgets/SectionContainer.dart';
import 'package:connectit_app/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailSection extends StatefulWidget {
  final User user;
  final bool edit;

  EmailSection(
    this.user, {
    this.edit = false,
  });

  @override
  _EmailSectionState createState() => _EmailSectionState();
}

class _EmailSectionState extends State<EmailSection> {
  bool _showEmail = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _showEmail = widget.user.showEmail ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Header("EMAIL"),
                if (_showEmail)
                  Container(
                    margin: EdgeInsets.only(bottom: 4),
                    child: GestureDetector(
                      onTap: onMailTap,
                      child: Text(
                        "${widget.user.email ?? "-"}",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                if (widget.edit)
                  CheckboxListTile(
                    value: _showEmail,
                    dense: true,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text("Show email on profile"),
                    onChanged: (value) {
                      setState(() {
                        _showEmail = value;
                      });
                      injector<Firestore>()
                          .collection('users')
                          .document(widget.user.id)
                          .updateData(
                        {
                          "showEmail": _showEmail,
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onMailTap() async {
    var url =
        'mailto:${widget.user.email}?subject=Let\'s connect&body=Hi ${widget.user.name},%0A%0AGreetings of the day%0A%0A...%0A%0ARegards,%0A${injector<UserRepository>().getLoggedInUser().name}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ToastUtils.show('Couldnt open mail');
    }
  }
}
