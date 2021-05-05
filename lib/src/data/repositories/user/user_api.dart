import 'package:capstone_mobile/Api/BaseApi.dart';
import 'package:capstone_mobile/Api/Exceptions.dart';
import 'package:capstone_mobile/src/data/models/models.dart';
import 'package:capstone_mobile/src/ui/constants/constant.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

class UserApi {
  final http.Client httpClient;
  BaseApi baseApi = BaseApi();

  UserApi({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<String> signIn(String username, String password) async {
    final authenUrl = 'auth/login';
    final body = <String, dynamic>{'username': username, 'password': password};

    final userJson =
        await baseApi.post(authenUrl, body, null) as Map<String, dynamic>;

    String roleName = userJson['data']['roleName'];
    if (roleName != Constant.ROLE_BM && roleName != Constant.ROLE_QC) {
      throw AuthorizationException('You are not allow to access this function');
    }

    return userJson['data']['accessToken'];
  }

  Future<User> getProfile(
    String token, {
    Map<String, String> opts,
  }) async {
    final url = 'employees/profile';

    final userJson =
        await baseApi.get(url, token, opts: opts) as Map<String, dynamic>;

    String roleName = userJson['data']['account']['role']['name'];
    if (roleName != Constant.ROLE_BM && roleName != Constant.ROLE_QC) {
      throw AuthorizationException('You are not allow to access this function');
    }

    return User.fromJson(userJson);
  }

  Future<String> changePassword({
    @required String token,
    @required String username,
    @required String oldPassword,
    @required String newPassword,
    Map<String, String> opts,
  }) async {
    final url = 'auth/password';

    final body = <String, dynamic>{
      "username": username,
      "password": oldPassword,
      "newPassword": newPassword,
    };

    final responseJson = await baseApi.put(url, body, token);

    return responseJson['message'];
  }
}
