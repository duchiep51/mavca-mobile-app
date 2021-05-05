part of 'report_bloc.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object> get props => [];
}

class ReportRequested extends ReportEvent {
  const ReportRequested({
    this.filter,
    this.isRefresh,
  });

  final Filter filter;
  final bool isRefresh;

  @override
  List<Object> get props => [filter];

  @override
  String toString() =>
      ' ReportRequested: { Filter: ${filter.toString()}, Refresh: $isRefresh }';
}

class FilterChanged extends ReportEvent {
  const FilterChanged({
    this.filter,
  });

  final Filter filter;

  @override
  List<Object> get props => [filter];

  @override
  String toString() => ' FilterChanged: { ${filter.toString()} } ';
}

class ReportAuthenticationStatusChanged extends ReportEvent {
  ReportAuthenticationStatusChanged({this.status});

  final AuthenticationStatus status;
  @override
  List<Object> get props => [status];
}
