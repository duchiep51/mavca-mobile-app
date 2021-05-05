import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    this.roleName,
    this.branchId,
    this.branchManagerId,
    this.firstName,
    this.lastName,
    this.imagePath,
    this.positionId,
    this.branchName,
    this.code,
    this.address,
    this.status,
    this.email,
    this.id,
    this.roleId,
    this.accountId,
  });

  final int id;
  final String email;
  final String code;
  final String firstName;
  final String lastName;
  final String address;
  final String status;
  final String imagePath;
  final int positionId;
  final String branchName;
  final String roleName;
  final int branchId;
  final int branchManagerId;
  final int roleId;
  final int accountId;

  @override
  List<Object> get props => [id, email, firstName];

  String get fullName => firstName + ' ' + lastName;

  static const empty = User(firstName: "empty");

  static User fromJson(dynamic json) {
    final userInfo = json['data'];
    return User(
      id: userInfo['id'] as int,
      accountId: userInfo['account']['id'],
      email: userInfo['email'],
      code: userInfo['code'],
      firstName: userInfo['firstName'],
      lastName: userInfo['lastName'],
      address: userInfo['address'],
      imagePath: userInfo['imagePath'],
      roleName: userInfo['account']['role']['name'],
      roleId: userInfo['account']['role']['id'] as int,
      branchName:
          userInfo['branch'] != null ? userInfo['branch']['name'] : null,
      branchId:
          userInfo['branch'] != null ? userInfo['branch']['id'] as int : null,
    );
  }
}
