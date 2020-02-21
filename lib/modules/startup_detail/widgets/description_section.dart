import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectit_app/data/model/startup.dart';
import 'package:connectit_app/di/injector.dart';
import 'package:connectit_app/modules/startup_detail/utils/constants.dart';
import 'package:connectit_app/utils/log_utils.dart';
import 'package:connectit_app/utils/toast_utils.dart';
import 'package:connectit_app/widgets/SectionContainer.dart';
import 'package:connectit_app/widgets/app_loader.dart';
import 'package:connectit_app/widgets/cancel_button.dart';
import 'package:connectit_app/widgets/header.dart';
import 'package:connectit_app/widgets/my_divider.dart';
import 'package:connectit_app/widgets/update_button.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class DescriptionSection extends StatelessWidget {
  final Startup startup;
  final bool edit;

  DescriptionSection(
    this.startup, {
    this.edit = false,
  });

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Header("DESCRIPTION"),
                Text(startup.description),
                SizedBox(
                  height: Constants.sectionVPadding,
                ),
              ],
            ),
          ),
          if (edit)
            IconButton(
              onPressed: () {
                _onEdit(context);
              },
              icon: Icon(
                LineAwesomeIcons.edit,
                size: 20,
              ),
            )
        ],
      ),
    );
  }

  void _onEdit(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SimpleDialog(
        contentPadding: EdgeInsets.all(0),
        children: <Widget>[
          MyEditingDialog(startup),
        ],
      ),
    );
  }
}

class MyEditingDialog extends StatefulWidget {
  final Startup startup;
  MyEditingDialog(this.startup);

  @override
  _MyEditingDialogState createState() => _MyEditingDialogState();
}

class _MyEditingDialogState extends State<MyEditingDialog> {
  TextEditingController _controller;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController.fromValue(
      TextEditingValue(text: widget.startup.description ?? ""),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Header("TAGLINE"),
          TextField(
            controller: _controller,
            maxLines: null,
            minLines: 5,
            autofocus: true,
            keyboardType: TextInputType.multiline,
            style: TextStyle(fontSize: 14),
            maxLength: 1000,
          ),
          SizedBox(
            height: 16,
          ),
          MyDivider(),
          if (_isLoading)
            AppLoader()
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CancelButton(() {
                  Navigator.pop(context);
                }),
                UpdateButton(() {
                  _onUpdate(_controller.text, context);
                }),
              ],
            ),
        ],
      ),
    );
  }

  void _onUpdate(String text, BuildContext context) async {
    try {
      injector<Firestore>()
          .collection('startups')
          .document(widget.startup.id)
          .updateData(
        {
          "description": text,
        },
      );
      ToastUtils.show("Description updated!");
      Navigator.pop(context);
    } catch (e, s) {
      logger.e(e, s);
      ToastUtils.showSomethingWrong();
    }
  }
}
