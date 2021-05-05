import 'dart:async';

import 'package:capstone_mobile/Api/Exceptions.dart';
import 'package:meta/meta.dart';

import 'package:capstone_mobile/src/data/repositories/user/user_api.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class SignUpFailure implements Exception {}

class SignInFailure extends AppException {
  SignInFailure([message]) : super(message, "Authorization error: ");
}

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>.broadcast();
  String token = '';
  String username = '';
  final UserApi userApi;

  AuthenticationRepository({@required this.userApi}) : assert(userApi != null);

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    // yield AuthenticationStatus.unknown;
    yield* _controller.stream;
  }

  Future<String> signIn({
    @required String username,
    @required String password,
  }) async {
    assert(username != null);
    assert(password != null);

    try {
      this.token = await userApi.signIn(username, password);
      token != ''
          ? _controller.add(AuthenticationStatus.authenticated)
          : _controller.add(AuthenticationStatus.unauthenticated);
      this.username = username;
    } on AuthorizationException catch (e) {
      throw AuthorizationException();
    } catch (e) {
      throw SignInFailure(e.toString());
    }

    return token;
  }

  void logOut() {
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
