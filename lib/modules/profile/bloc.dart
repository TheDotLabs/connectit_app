import 'package:connectit_app/data/model/result.dart';
import 'package:connectit_app/data/model/user.dart';
import 'package:connectit_app/data/repo/user/base/user_repository.dart';
import 'package:connectit_app/di/injector.dart';
import 'package:connectit_app/modules/base/bloc_base.dart';

class ProfileBloc extends BaseBloc {
  final _userRepository = injector<UserRepository>();

  Future<Result<User>> fetchUserInfo() =>
      _userRepository.getLoggedInUser();

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
