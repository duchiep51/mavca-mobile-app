part of 'report_filter_bloc.dart';

class ReportFilterState extends Equatable {
  final Filter filter;

  const ReportFilterState({@required this.filter});

  ReportFilterState copyWith({
    Filter filter,
  }) {
    return ReportFilterState(
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object> get props => [filter];

  @override
  String toString() => 'ReportFilterState: { $filter }';
}
