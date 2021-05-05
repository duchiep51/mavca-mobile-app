part of 'violation_bloc.dart';

abstract class ViolationState extends Equatable {
  const ViolationState();

  @override
  List<Object> get props => [];
}

class ViolationInitial extends ViolationState {}

class ViolationLoadInProgress extends ViolationState {}

class ViolationLoadSuccess extends ViolationState {
  final List<Violation> violations;
  final bool hasReachedMax;
  final String screen;
  final Filter activeFilter;

  const ViolationLoadSuccess({
    @required this.violations,
    this.hasReachedMax,
    this.screen,
    this.activeFilter,
  });

  ViolationLoadSuccess copyWith({
    List<Violation> violations,
    bool hasReachedMax,
    String screen,
    Filter activeFilter,
  }) {
    return ViolationLoadSuccess(
      violations: violations ?? this.violations,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      screen: screen,
      activeFilter: activeFilter ?? this.activeFilter,
    );
  }

  @override
  List<Object> get props => [violations, hasReachedMax, screen, activeFilter];

  @override
  String toString() =>
      'ViolationLoadSuccess { violation total: ${violations.length}, Has reach max $hasReachedMax }, activeFilter { $activeFilter }';
}

class ViolationLoadFailure extends ViolationState {}
