part of 'regulation_bloc.dart';

abstract class RegulationState extends Equatable {
  const RegulationState();

  @override
  List<Object> get props => [];
}

class RegulationInitial extends RegulationState {}

class RegulationLoadInProgress extends RegulationState {}

class RegulationLoadSuccess extends RegulationState {
  final List<Regulation> regulations;

  RegulationLoadSuccess({@required this.regulations});

  @override
  List<Object> get props => [regulations];

  @override
  String toString() => 'BranchLoadSuccess';
}

class RegulationLoadFailure extends RegulationState {}
