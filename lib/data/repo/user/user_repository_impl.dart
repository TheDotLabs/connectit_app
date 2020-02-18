import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectit_app/data/local/prefs/prefs_helper.dart';
import 'package:connectit_app/data/model/result.dart';
import 'package:connectit_app/data/model/user.dart';
import 'package:connectit_app/utils/log_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'base/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final Firestore firestore;

  UserRepositoryImpl({@required this.firestore});

  @override
  Future<Result<User>> register(User user) async {
    try {
      final result = await firestore.collection('users').document(user.id).setData(user.toJson());
      prefsHelper.isLogin = true;
      prefsHelper.userData = json.encode(user);
      return Result(user);
    } catch (e, s) {
      logger.e(e, s);
      return Result.error('${e.message}');
    }
  }

  @override
  Future<Result<User>> getLoggedInUser() async {
    try {
      final FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
      final result = await firestore.collection('users').document(firebaseUser.uid).get();
      final user = User.fromJson(result.data);
      return Result(user);
    } catch (e, s) {
      logger.e(e, s);
      return Result.error('${e.message}');
    }
  }
}
