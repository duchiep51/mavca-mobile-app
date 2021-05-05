part of 'branch_bloc.dart';

abstract class BranchState extends Equatable {
  const BranchState();

  @override
  List<Object> get props => [];
}

class BranchInitial extends BranchState {}

class BranchLoadInProgress extends BranchState {}

class BranchLoadSuccess extends BranchState {
  final List<Branch> branches;

  BranchLoadSuccess({@required this.branches});

  @override
  String toString() => 'BranchLoadSuccess';
}

class BranchLoadFailure extends BranchState {}
