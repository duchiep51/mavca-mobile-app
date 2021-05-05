import 'dart:async';

import 'package:capstone_mobile/src/data/repositories/user/user_api.dart';
import '../../models/models.dart';

class UserRepository {
  final UserApi userApi;

  UserRepository({this.userApi});

  Future<User> getUser(String token) async {
    return await userApi.getProfile(
      token,
    );
  }

  // Future<User> getUser() async {
  //   if (_user != null) return _user;
  //   return Future.delayed(
  //     const Duration(milliseconds: 300),
  //     () => _user = User(id: Uuid().v4()),
  //   );
  // }

  Future<String> changePassword(
    String token,
    String username,
    String oldPassword,
    String newPassword,
  ) async {
    return await userApi.changePassword(
      token: token,
      username: username,
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }
}
