part of 'report_by_demand_bloc.dart';

abstract class ReportByDemandState extends Equatable {
  const ReportByDemandState();

  @override
  List<Object> get props => [];
}

class ReportByDemandInitial extends ReportByDemandState {}

class ReportByDemandLoadInProgress extends ReportByDemandState {}

class ReportByDemandLoadFailure extends ReportByDemandState {}

class ReportByDemandLoadSuccess extends ReportByDemandState {
  final List<Report> reports;
  final bool hasReachedMax;

  const ReportByDemandLoadSuccess({
    @required this.reports,
    this.hasReachedMax,
  });

  ReportByDemandLoadSuccess copyWith({
    List<Report> reports,
    bool hasReachedMax,
  }) {
    return ReportByDemandLoadSuccess(
      reports: reports ?? this.reports,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [reports, hasReachedMax];

  @override
  String toString() =>
      'ReportLoadSuccessByDemand { Report total: ${reports.length}, Has reach max $hasReachedMax }';
}
