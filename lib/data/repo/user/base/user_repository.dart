import 'package:connectit_app/data/model/result.dart';
import 'package:connectit_app/data/model/user.dart';

abstract class UserRepository {
  Future<Result<User>> register(User user);

  Future<Result<User>> getLoggedInUser();
}
