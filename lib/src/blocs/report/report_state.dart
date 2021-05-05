part of 'report_bloc.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLoadInProgress extends ReportState {}

class ReportLoadSuccess extends ReportState {
  final List<Report> reports;
  final bool hasReachedMax;
  final String screen;
  final Filter activeFilter;

  const ReportLoadSuccess({
    @required this.reports,
    this.hasReachedMax,
    this.screen,
    this.activeFilter,
  });

  ReportLoadSuccess copyWith({
    List<Report> reports,
    bool hasReachedMax,
    String screen,
    Filter activeFilter,
  }) {
    return ReportLoadSuccess(
      reports: reports ?? this.reports,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      screen: screen,
      activeFilter: activeFilter ?? this.activeFilter,
    );
  }

  @override
  List<Object> get props => [
        reports,
        hasReachedMax,
        screen,
        activeFilter,
      ];

  @override
  String toString() =>
      'ViolationLoadSuccess { violation total: ${reports.length}, Has reach max $hasReachedMax }, activeFilter { branchId ${activeFilter.branchId} }';
}

class ReportLoadFailure extends ReportState {}
