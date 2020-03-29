import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectit_app/data/model/user.dart';
import 'package:connectit_app/di/injector.dart';
import 'package:connectit_app/routes/routes.dart';
import 'package:connectit_app/utils/log_utils.dart';
import 'package:connectit_app/utils/toast_utils.dart';
import 'package:connectit_app/utils/top_level_utils.dart';
import 'package:connectit_app/widgets/app_loader.dart';
import 'package:connectit_app/widgets/cancel_button.dart';
import 'package:connectit_app/widgets/header.dart';
import 'package:connectit_app/widgets/my_divider.dart';
import 'package:connectit_app/widgets/update_button.dart';
import 'package:flutter/material.dart';

class SkillSection extends StatelessWidget {
  final User user;
  final bool edit;

  SkillSection(
    this.user, {
    this.edit = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Header("SKILLS"),
          if (checkIfListIsNotEmpty(user.skills))
            for (final skill in user.skills)
              if (checkIfNotEmpty(skill))
                Container(
                  margin: EdgeInsets.only(top: 4),
                  child: Text(
                    skill ?? "-",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
          // Text(tagline),
          if (edit)
            Container(
              height: 40.0,
              child: RaisedButton(
                onPressed: () {
                  _onEdit(context, Education());
                },
                color: Colors.transparent,
                elevation: 0,
                highlightElevation: 0,
                child: Text(
                  '+ ADD SKILLS',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _onEdit(BuildContext context, Education education) {
    Navigator.pushNamed(context, Routes.skillsEdit);
  }

  void _onRemove(BuildContext context, Education education) {
    try {
      injector<Firestore>().collection('users').document(user.id).updateData({
        "educations": FieldValue.arrayRemove([education.toJson()])
      });

      ToastUtils.show("Education updated!");
    } catch (e, s) {
      logger.e(e, s);
      ToastUtils.showSomethingWrong();
    }
  }
}

class _MyEditingDialog extends StatefulWidget {
  final User user;
  final Education education;

  _MyEditingDialog(this.user, this.education);

  @override
  _MyEditingDialogState createState() => _MyEditingDialogState();
}

class _MyEditingDialogState extends State<_MyEditingDialog> {
  TextEditingController _collegeController;
  TextEditingController _descController;
  TextEditingController _degreeController;

  bool _isLoading = false;

  int _startYear;
  int _endYear;

  int currentYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _startYear = widget.education.startYear;
    _endYear = widget.education.endYear;

    _collegeController = TextEditingController.fromValue(
      TextEditingValue(text: widget.education.college ?? ""),
    );

    _descController = TextEditingController.fromValue(
      TextEditingValue(text: widget.education.description ?? ""),
    );
    _degreeController = TextEditingController.fromValue(
      TextEditingValue(text: widget.education.degree ?? ""),
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
          Header(
            "COLLEGE",
            marginBottom: 0,
          ),
          TextField(
            controller: _collegeController,
            maxLines: null,
            style: TextStyle(fontSize: 14),
            decoration: InputDecoration(hintText: "..."),
            maxLength: 70,
          ),
          Header(
            "DEGREE",
            marginBottom: 0,
          ),
          TextField(
            controller: _degreeController,
            maxLines: null,
            style: TextStyle(fontSize: 14),
            decoration: InputDecoration(hintText: "..."),
            maxLength: 50,
          ),
          Header(
            "START YEAR",
            marginBottom: 0,
          ),
          DropdownButton<int>(
            isExpanded: true,
            items: [
              for (int i = currentYear - 70; i < (currentYear + 2); i++)
                DropdownMenuItem(
                  child: Text(i.toString()),
                  value: i,
                )
            ],
            value: _startYear ?? currentYear,
            onChanged: (value) {
              FocusScope.of(context).requestFocus(new FocusNode());

              setState(() {
                _startYear = value;
              });
            },
          ),
          SizedBox(
            height: 12,
          ),
          Header(
            "END YEAR",
            marginBottom: 0,
          ),
          DropdownButton<int>(
            isExpanded: true,
            items: [
              for (int i = currentYear - 70; i < currentYear + 10; i++)
                DropdownMenuItem(
                  child: Text(i.toString()),
                  value: i,
                )
            ],
            value: _endYear ?? currentYear,
            onChanged: (value) {
              FocusScope.of(context).requestFocus(new FocusNode());

              setState(() {
                _endYear = value;
              });
            },
          ),
          SizedBox(
            height: 12,
          ),
          Header(
            "DESCRIPTION",
            marginBottom: 0,
          ),
          TextField(
            controller: _descController,
            maxLines: null,
            style: TextStyle(fontSize: 14),
            maxLength: 300,
            decoration: InputDecoration(hintText: "..."),
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
                  final newEducation = widget.education.copyWith(
                    college: _collegeController.text?.trim(),
                    description: _descController.text?.trim(),
                    startYear: _startYear,
                    endYear: _endYear,
                    degree: _degreeController.text?.trim(),
                  );
                  _onUpdate(widget.education, newEducation, context);
                }),
              ],
            ),
        ],
      ),
    );
  }

  void _onUpdate(
      Education oldModel, Education model, BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });
      injector<Firestore>()
          .collection('users')
          .document(widget.user.id)
          .updateData({
        "educations": FieldValue.arrayRemove([oldModel.toJson()])
      });
      injector<Firestore>()
          .collection('users')
          .document(widget.user.id)
          .updateData({
        "educations": FieldValue.arrayUnion([model.toJson()])
      });

      ToastUtils.show("Education updated!");
      Navigator.pop(context);
    } catch (e, s) {
      logger.e(e, s);
      setState(() {
        _isLoading = false;
      });
      ToastUtils.showSomethingWrong();
    }
  }
}
