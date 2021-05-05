part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.user = User.empty,
    this.token = '',
    this.status: AuthenticationStatus.unknown,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(
      {@required User user, @required String token})
      : this._(
            // status: AuthenticationStatus.authenticated,
            user: user,
            token: token,
            status: AuthenticationStatus.authenticated);

  const AuthenticationState.unauthenticated()
      : this._(
          token: '',
          status: AuthenticationStatus.unauthenticated,
        );

  final User user;
  final String token;
  final AuthenticationStatus status;

  @override
  List<Object> get props => [user, token, status];
}
