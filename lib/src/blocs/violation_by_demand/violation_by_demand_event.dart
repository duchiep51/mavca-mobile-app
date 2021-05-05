part of 'violation_by_demand_bloc.dart';

abstract class ViolationByDemandEvent extends Equatable {
  const ViolationByDemandEvent();

  @override
  List<Object> get props => [];
}

class ViolationRequestedByReportId extends ViolationByDemandEvent {
  final int reportId;

  ViolationRequestedByReportId({@required this.reportId});

  @override
  List<Object> get props => [reportId];

  @override
  String toString() => ' ViolationRequestedByReportId: {  $reportId }';
}

class ViolationRequestedByDate extends ViolationByDemandEvent {
  final DateTime date;

  ViolationRequestedByDate({@required this.date});

  @override
  List<Object> get props => [date];

  @override
  String toString() => ' ViolationRequestedByDate: {  $date }';
}

class ViolationByDemandUpdated extends ViolationByDemandEvent {
  const ViolationByDemandUpdated({this.violation});

  final Violation violation;

  @override
  List<Object> get props => [violation];
}

class ViolationByDemandDeleted extends ViolationByDemandEvent {
  const ViolationByDemandDeleted({this.id});

  final int id;

  @override
  List<Object> get props => [id];
}
