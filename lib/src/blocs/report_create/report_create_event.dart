part of 'report_create_bloc.dart';

abstract class ReportCreateEvent extends Equatable {
  const ReportCreateEvent();

  @override
  List<Object> get props => [];
}

class ReportNameChanged extends ReportCreateEvent {
  const ReportNameChanged({@required this.reportName});

  final String reportName;

  @override
  List<Object> get props => [reportName];
}

class ReportBranchChanged extends ReportCreateEvent {
  const ReportBranchChanged({@required this.reportBranchId});

  final int reportBranchId;

  @override
  List<Object> get props => [reportBranchId];
}

class ReportDescriptionChanged extends ReportCreateEvent {
  const ReportDescriptionChanged({
    @required this.reportDescription,
    this.isEditing = false,
  });

  final String reportDescription;
  final bool isEditing;

  @override
  List<Object> get props => [reportDescription, isEditing];
}

class ReportViolationsChanged extends ReportCreateEvent {
  const ReportViolationsChanged({
    @required this.reportViolation,
    this.isEditing = false,
  });

  final Violation reportViolation;
  final bool isEditing;

  @override
  List<Object> get props => [reportViolation, isEditing];
}

class ReportViolationRemove extends ReportCreateEvent {
  const ReportViolationRemove({@required this.position});

  final int position;

  @override
  List<Object> get props => [position];
}

class ReportCreateSubmitted extends ReportCreateEvent {
  const ReportCreateSubmitted({this.isDraft = true});

  final bool isDraft;

  @override
  List<Object> get props => [isDraft];
}

class ReportEditing extends ReportCreateEvent {
  const ReportEditing({@required this.report});

  final Report report;

  @override
  List<Object> get props => [report];
}

class ReportEdited extends ReportCreateEvent {
  final Report report;

  const ReportEdited({@required this.report});

  @override
  List<Object> get props => [report];
}
