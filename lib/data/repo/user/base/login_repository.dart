import 'package:connectit_app/data/model/result.dart';
import 'package:connectit_app/data/model/user.dart';
import 'package:connectit_app/data/model/void_result.dart';
import 'package:connectit_app/di/injector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'user_repository.dart';

abstract class LoginRepository {
  final _firebaseAuth = FirebaseAuth.instance;

  final _userRepository = injector<UserRepository>();

  @protected
  Future<FirebaseUser> getFirebaseUser(AuthCredential credential) async {
    return (await _firebaseAuth.signInWithCredential(credential)).user;
  }

  @protected
  // ignore: lines_longer_than_80_chars
  Future<Result<User>> registerUser(User user) => _userRepository.register(user);

  Future<Result<User>> login();

  Future<VoidResult> logout();

  Future<bool> isLoggedIn();
}

class LoginProvider {
  LoginProvider._();

  static const google = "Google";
}
