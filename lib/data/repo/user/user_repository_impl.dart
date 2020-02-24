import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectit_app/data/local/prefs/prefs_helper.dart';
import 'package:connectit_app/data/model/result.dart';
import 'package:connectit_app/data/model/user.dart';
import 'package:connectit_app/data/repo/user/google_login_repository.dart';
import 'package:connectit_app/di/injector.dart';
import 'package:connectit_app/utils/log_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import 'base/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final Firestore firestore;
  final _userSubject = BehaviorSubject<User>.seeded(null);

  String _fcmToken;

  UserRepositoryImpl({@required this.firestore}) {
    init();
  }

  StreamTransformer<DocumentSnapshot, User> get _streamTransformer =>
      StreamTransformer.fromHandlers(handleData: (data, sink) {
        sink.add(User.fromJson(data.data));
      });

  @override
  Future<Result<User>> register(User user) async {
    try {
      final userDocument =
          await firestore.collection('users').document(user.id).get();
      if (userDocument != null && userDocument.exists) {
        //Do nothing
      } else {
        await userDocument.reference.setData(user.toJson());
      }
      prefsHelper.isLogin = true;
      prefsHelper.userData = json.encode(user);
      init();

      return Result(user);
    } catch (e, s) {
      logger.e(e, s);
      return Result.error('${e.message}');
    }
  }

  Future<void> init() async {
    final FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    try {
      firestore
          .collection('users')
          .document(firebaseUser.uid)
          .snapshots()
          .listen((event) async {
        if (event != null) {
          _userSubject.add(User.fromJson(event.data));
          final _firebaseMessaging = FirebaseMessaging();
          _firebaseMessaging.setAutoInitEnabled(true);
          _fcmToken = await _firebaseMessaging.getToken();
          await firestore
              .collection('users')
              .document(firebaseUser.uid)
              .updateData({'fcmToken': _fcmToken});
        } else
          _userSubject.add(null);
      });
    } catch (e, s) {
      logger.e(e, s);
      _userSubject.addError(e);
    }
  }

  @override
  User getLoggedInUser() {
    return _userSubject.value;
  }

  @override
  Stream<User> getUserStream() {
    return _userSubject.stream;
  }

  @override
  void logoutUser() async {
    await FirebaseAuth.instance.signOut();
    await injector<GoogleLoginRepository>().logout();
    prefsHelper.isLogin = false;
    prefsHelper.userData = null;
  }

  @override
  String getFcmToken() {
    // TODO: implement getFcmToken
    return _fcmToken;
  }
}
