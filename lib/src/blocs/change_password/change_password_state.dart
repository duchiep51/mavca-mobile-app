part of 'change_password_cubit.dart';

class ChangePasswordRequested extends Equatable {
  ChangePasswordRequested({
    this.status = FormzStatus.pure,
    this.newPassword = const Password.pure(),
    this.oldPassword = const Password.pure(),
    this.confirmPassword = const Password.pure(),
    this.message,
  });

  final FormzStatus status;
  final Password oldPassword;
  final Password newPassword;
  final Password confirmPassword;
  final String message;

  ChangePasswordRequested copyWith({
    FormzStatus status,
    Password oldPassword,
    Password newPassword,
    String message,
  }) {
    return ChangePasswordRequested(
      status: status ?? this.status,
      oldPassword: oldPassword ?? this.oldPassword,
      newPassword: newPassword ?? this.newPassword,
      message: message,
    );
  }

  @override
  List<Object> get props => [status, oldPassword, newPassword, message];
}
