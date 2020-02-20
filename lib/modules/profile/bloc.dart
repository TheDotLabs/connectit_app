import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectit_app/data/model/user.dart';
import 'package:connectit_app/data/repo/user/base/user_repository.dart';
import 'package:connectit_app/di/injector.dart';
import 'package:connectit_app/modules/base/bloc_base.dart';
import 'package:connectit_app/utils/constants.dart';

class ProfileBloc extends BaseBloc {
  final _userRepository = injector<UserRepository>();

  Stream<User> fetchUserInfo() => _userRepository.getUserStream();

  @override
  void dispose() {
    // TODO: implement dispose
  }

  fetchVisitorInfo(String id) {
    return injector<Firestore>()
        .collection('users')
        .document(id)
        .snapshots();
  }
}
