import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectit_app/constants/images.dart';
import 'package:connectit_app/data/model/startup.dart';
import 'package:connectit_app/data/repo/user/base/user_repository.dart';
import 'package:connectit_app/di/injector.dart';
import 'package:connectit_app/utils/log_utils.dart';
import 'package:connectit_app/utils/toast_utils.dart';
import 'package:connectit_app/utils/top_level_utils.dart';
import 'package:connectit_app/widgets/add_image.dart';
import 'package:connectit_app/widgets/app_loader.dart';
import 'package:connectit_app/widgets/cancel_button.dart';
import 'package:connectit_app/widgets/header.dart';
import 'package:connectit_app/widgets/my_divider.dart';
import 'package:connectit_app/widgets/update_button.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:validators/validators.dart';

class StartupEditPage extends StatefulWidget {
  final bool edit;
  final Startup startup;

  StartupEditPage({
    this.edit = false,
    this.startup,
  });

  @override
  _MyEditingDialogState createState() => _MyEditingDialogState();
}

class _MyEditingDialogState extends State<StartupEditPage> {
  TextEditingController _nameController;
  TextEditingController _taglineController;
  TextEditingController _descController;
  TextEditingController _websiteController;

  bool _isLoading = false;

  int currentYear = DateTime.now().year;

  File _file;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController.fromValue(
      TextEditingValue(text: widget.startup?.name ?? ""),
    );
    _taglineController = TextEditingController.fromValue(
      TextEditingValue(text: widget.startup?.tagline ?? ""),
    );
    _descController = TextEditingController.fromValue(
      TextEditingValue(text: widget.startup?.description ?? ""),
    );
    _websiteController = TextEditingController.fromValue(
      TextEditingValue(text: widget.startup?.website ?? ""),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.edit ? "Edit Details" : "Add Your Startup",
        ),
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
        brightness: Brightness.light,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (!widget.edit)
              Opacity(
                opacity: 0.9,
                child: SvgPicture.asset(
                  Images.ADD_STARTUP,
                  width: MediaQuery.of(context).size.width / 3,
                ),
              ),
            if (!widget.edit)
              Header(
                "COVER",
                marginBottom: 8,
              ),
            if (!widget.edit)
              AddImage(
                _file,
                _onImageTap,
              ),
            if (!widget.edit)
              SizedBox(
                height: 16,
              ),
            Header(
              "NAME",
              marginBottom: 0,
            ),
            TextField(
              controller: _nameController,
              maxLines: null,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(hintText: "Startup name..."),
              style: TextStyle(
                  fontSize: 14, color: widget.edit ? Colors.grey : null),
              enabled: !widget.edit,
              maxLength: 70,
            ),
            SizedBox(
              height: 8,
            ),
            Header(
              "TAGLINE",
              marginBottom: 0,
            ),
            TextField(
              controller: _taglineController,
              maxLines: null,
              minLines: 2,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(hintText: "One line summary..."),
              style: TextStyle(fontSize: 14),
              maxLength: 100,
            ),
            SizedBox(
              height: 8,
            ),
            Header(
              "DESCRIPTION",
              marginBottom: 0,
            ),
            TextField(
              controller: _descController,
              maxLines: null,
              minLines: 5,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              decoration:
                  InputDecoration(hintText: "Brief idea about your startup..."),
              style: TextStyle(fontSize: 14),
              maxLength: 1000,
            ),
            Header(
              "WEBSITE",
              marginBottom: 0,
            ),
            TextField(
              controller: _websiteController,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(hintText: "Website (if any)..."),
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            MyDivider(),
            if (_isLoading)
              AppLoader()
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  UpdateButton(
                    () {
                      _onUpdate(
                        context,
                        _nameController.text,
                        _taglineController.text,
                        _descController.text,
                        _websiteController.text,
                      );
                    },
                    text: widget.edit ? "UPDATE" : "CREATE",
                  ),
                  MyDivider(),
                  CancelButton(
                    () {
                      Navigator.pop(context);
                    },
                  ),
                  MyDivider(),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _onUpdate(
    BuildContext context,
    String name,
    String tagline,
    String description,
    String website,
  ) async {
    try {
      if (!checkIfNotEmpty(name)) {
        ToastUtils.show("Name can't be empty!");
        return;
      } else if (!checkIfNotEmpty(tagline)) {
        ToastUtils.show("Tagline can't be empty!");
        return;
      } else if (!checkIfNotEmpty(description)) {
        ToastUtils.show("Description can't be empty!");
        return;
      } else if (checkIfNotEmpty(website) && !isURL(website)) {
        ToastUtils.show("Website url must be valid!");
        return;
      }
      setState(() {
        _isLoading = true;
      });
      final _currentUser = injector<UserRepository>().getLoggedInUser();
      final _userRef =
          injector<Firestore>().collection('users').document(_currentUser.id);
      final startupRef =
          injector<Firestore>().collection('startups').document();
      String avatar;
      if (!widget.edit && _file != null) {
        final storageReference = FirebaseStorage()
            .ref()
            .child('startups/${Path.basename(_file.path)}');
        final uploadTask = storageReference.putFile(_file);
        await uploadTask.onComplete;
        logger.d('File Uploaded');
        avatar = await storageReference.getDownloadURL();
      }
      if (!widget.edit) {
        await startupRef.setData({
          'author': _userRef,
          'name': name,
          'tagline': tagline,
          'time': DateTime.now().millisecondsSinceEpoch,
          'description': description,
          'isNew': true,
          'avatar': avatar,
          'admins': [_userRef],
          'website': website,
        });
        await _userRef.updateData({
          'startups': FieldValue.arrayUnion([startupRef])
        });
      } else {
        final startupRef2 = injector<Firestore>()
            .collection('startups')
            .document(widget.startup.id);
        await startupRef2.updateData({
          'tagline': tagline,
          'description': description,
          'website': website,
        });
      }
      ToastUtils.show(
        widget.edit ? "Details updated!" : "Startup created successfully!",
      );
      Navigator.pop(context);
    } catch (e, s) {
      logger.e(e, s);
      setState(() {
        _isLoading = false;
      });
      ToastUtils.showSomethingWrong();
    }
  }

  void _onImageTap() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 800);

    setState(() {
      _file = image;
    });
  }
}
