import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectit_app/data/model/user.dart';
import 'package:connectit_app/di/injector.dart';
import 'package:connectit_app/utils/log_utils.dart';
import 'package:connectit_app/utils/toast_utils.dart';
import 'package:connectit_app/utils/top_level_utils.dart';
import 'package:connectit_app/widgets/app_loader.dart';
import 'package:connectit_app/widgets/cancel_button.dart';
import 'package:connectit_app/widgets/header.dart';
import 'package:connectit_app/widgets/my_divider.dart';
import 'package:connectit_app/widgets/update_button.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class WorkSection extends StatelessWidget {
  final User user;
  final bool edit;

  WorkSection(
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
          Header("WORK"),
          if (checkIfListIsNotEmpty(user.works))
            for (final work in user.works)
              Container(
                margin: EdgeInsets.only(
                  bottom: 12,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            work.company ?? "--",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                .copyWith(fontSize: 16),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          if (work.startYear != null || work.endYear != null)
                            Text(
                              "(${work.startYear ?? ''} - ${(work.currentlyWorkHere ?? false) ? 'current' : work.endYear ?? ''})",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(
                                    fontSize: 14,
                                  ),
                            ),
                          if (checkIfNotEmpty(work.description))
                            Container(
                              margin: EdgeInsets.only(top: 4),
                              child: Text(
                                work.description,
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (edit)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            height: 32,
                            child: IconButton(
                              icon: Icon(
                                LineAwesomeIcons.edit,
                                size: 20,
                              ),
                              onPressed: () {
                                _onEdit(context, work);
                              },
                            ),
                          ),
                          SizedBox(
                            height: 32,
                            child: IconButton(
                              icon: Icon(
                                LineAwesomeIcons.minus_circle,
                                size: 20,
                              ),
                              onPressed: () {
                                _onRemove(context, work);
                              },
                            ),
                          ),
                        ],
                      )
                  ],
                ),
              )

          // Text(tagline),
          else if (edit)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 0.0),
                    child: Text(
                      "----Add Work----",
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          if (edit)
            Container(
              height: 40.0,
              child: RaisedButton(
                onPressed: () {
                  _onEdit(context, Work());
                },
                color: Colors.white,
                elevation: 0,
                highlightElevation: 0,
                child: Text(
                  '+ ADD',
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

  void _onEdit(BuildContext context, Work work) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SimpleDialog(
        contentPadding: EdgeInsets.all(0),
        children: <Widget>[
          _MyEditingDialog(user, work),
        ],
      ),
    );
  }

  void _onRemove(BuildContext context, Work work) {
    try {
      injector<Firestore>().collection('users').document(user.id).updateData({
        "works": FieldValue.arrayRemove([work.toJson()])
      });

      ToastUtils.show("Work updated!");
    } catch (e, s) {
      logger.e(e, s);
      ToastUtils.showSomethingWrong();
    }
  }
}

class _MyEditingDialog extends StatefulWidget {
  final User user;
  final Work education;
  _MyEditingDialog(this.user, this.education);

  @override
  _MyEditingDialogState createState() => _MyEditingDialogState();
}

class _MyEditingDialogState extends State<_MyEditingDialog> {
  TextEditingController _companyController;
  TextEditingController _descController;
  TextEditingController _roleController;

  bool _isLoading = false;

  int _startYear;
  int _endYear;

  int currentYear = DateTime.now().year;

  bool _currentyWork;
  @override
  void initState() {
    super.initState();
    _currentyWork = widget.education.currentlyWorkHere ?? false;
    _startYear = widget.education.startYear;
    _endYear = widget.education.endYear;

    _companyController = TextEditingController.fromValue(
      TextEditingValue(text: widget.education.company ?? ""),
    );

    _descController = TextEditingController.fromValue(
      TextEditingValue(text: widget.education.description ?? ""),
    );
    _roleController = TextEditingController.fromValue(
      TextEditingValue(text: widget.education.role ?? ""),
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
            "COMPANY",
            marginBottom: 0,
          ),
          TextField(
            controller: _companyController,
            maxLines: null,
            decoration: InputDecoration(hintText: "..."),
            style: TextStyle(fontSize: 14),
            maxLength: 50,
          ),
          Header(
            "ROLE",
            marginBottom: 0,
          ),
          TextField(
            controller: _roleController,
            decoration: InputDecoration(hintText: "..."),
            maxLines: null,
            style: TextStyle(fontSize: 14),
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
          if (!_currentyWork)
            SizedBox(
              height: 12,
            ),
          if (!_currentyWork)
            Header(
              "END YEAR",
              marginBottom: 0,
            ),
          if (!_currentyWork)
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
          CheckboxListTile(
              value: _currentyWork,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text("Currently work here"),
              onChanged: (value) {
                setState(() {
                  _currentyWork = value;
                });
              }),
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
            decoration: InputDecoration(hintText: "..."),
            style: TextStyle(fontSize: 14),
            maxLength: 300,
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
                    company: _companyController.text?.trim(),
                    description: _descController.text?.trim(),
                    startYear: _startYear,
                    endYear: _currentyWork ? null : _endYear,
                    role: _roleController.text?.trim(),
                    currentlyWorkHere: _currentyWork,
                  );
                  _onUpdate(widget.education, newEducation, context);
                }),
              ],
            ),
        ],
      ),
    );
  }

  void _onUpdate(Work oldModel, Work model, BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });
      injector<Firestore>()
          .collection('users')
          .document(widget.user.id)
          .updateData({
        "works": FieldValue.arrayRemove([oldModel.toJson()])
      });
      injector<Firestore>()
          .collection('users')
          .document(widget.user.id)
          .updateData({
        "works": FieldValue.arrayUnion([model.toJson()])
      });

      ToastUtils.show("Work removed!");
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
