part of 'violation_filter_bloc.dart';

class ViolationFilterState extends Equatable {
  final Filter filter;

  ViolationFilterState({this.filter});

  ViolationFilterState copyWith({
    Filter filter,
  }) {
    return ViolationFilterState(
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object> get props => [filter];

  @override
  String toString() => 'ViolationFilterState: { $filter }';
}
