import 'package:equatable/equatable.dart';

class ChangePassword extends Equatable {
  final String newPassword;
  final String oldPassword;

  ChangePassword({this.newPassword, this.oldPassword});

  @override
  // TODO: implement props
  List<Object> get props => [oldPassword, newPassword];
}
