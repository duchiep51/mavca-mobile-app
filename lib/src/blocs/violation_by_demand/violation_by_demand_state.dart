part of 'violation_by_demand_bloc.dart';

abstract class ViolationByDemandState extends Equatable {
  const ViolationByDemandState();

  @override
  List<Object> get props => [];
}

class ViolationByDemandInitial extends ViolationByDemandState {}

class ViolationByDemandLoadInProgress extends ViolationByDemandState {}

class ViolationByDemandLoadFailure extends ViolationByDemandState {}

class ViolationByDemandLoadSuccess extends ViolationByDemandState {
  final List<Violation> violations;
  final bool hasReachedMax;

  const ViolationByDemandLoadSuccess({
    @required this.violations,
    this.hasReachedMax,
  });

  ViolationByDemandLoadSuccess copyWith({
    List<Violation> violations,
    bool hasReachedMax,
  }) {
    return ViolationByDemandLoadSuccess(
      violations: violations ?? this.violations,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [violations, hasReachedMax];

  @override
  String toString() =>
      'ViolationLoadSuccessByDemand { violation total: ${violations.length}, Has reach max $hasReachedMax }';
}
