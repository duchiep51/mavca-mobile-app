part of 'branch_bloc.dart';

abstract class BranchEvent extends Equatable {
  const BranchEvent();

  @override
  List<Object> get props => [];
}

class BranchRequested extends BranchEvent {
  BranchRequested();

  @override
  List<Object> get props => [];

  @override
  String toString() => ' BranchRequested ';
}

class BranchAuthenticationStatusChanged extends BranchEvent {
  const BranchAuthenticationStatusChanged({this.status});

  final AuthenticationStatus status;

  @override
  List<Object> get props => [status];
}
