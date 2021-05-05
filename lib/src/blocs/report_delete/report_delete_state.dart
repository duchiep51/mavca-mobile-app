part of 'report_delete_cubit.dart';

abstract class ReportDeleteState extends Equatable {
  const ReportDeleteState();

  @override
  List<Object> get props => [];
}

class ReportDeleteInitial extends ReportDeleteState {}

class ReportDeleteInProgress extends ReportDeleteState {}

class ReportDeleteSuccess extends ReportDeleteState {}

class ReportDeleteFail extends ReportDeleteState {}
