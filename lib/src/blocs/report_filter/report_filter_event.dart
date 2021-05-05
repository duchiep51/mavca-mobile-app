part of 'report_filter_bloc.dart';

abstract class ReportFilterEvent extends Equatable {
  const ReportFilterEvent();

  @override
  List<Object> get props => [];
}

class ReportFilterBranchIdUpdated extends ReportFilterEvent {
  final int branchId;

  ReportFilterBranchIdUpdated({this.branchId});
  @override
  List<Object> get props => [branchId];

  @override
  String toString() => 'ReportFilterBranchIdUpdated { BranchId: $branchId  }';
}

class ReportFilterRegulationUpdated extends ReportFilterEvent {
  final int regulationId;

  ReportFilterRegulationUpdated({this.regulationId});
  @override
  List<Object> get props => [regulationId];
  @override
  String toString() =>
      'ReportFilterRegulationUpdated { RegulationId: $regulationId  }';
}

class ReportFilterStatusUpdated extends ReportFilterEvent {
  final String status;

  ReportFilterStatusUpdated({this.status});
  @override
  List<Object> get props => [status];
  @override
  String toString() => 'ReportFilterStatusUpdated { Status: $status  }';
}

class ReportFilterMonthUpdated extends ReportFilterEvent {
  final DateTime date;

  ReportFilterMonthUpdated({this.date});
  @override
  List<Object> get props => [date];
  @override
  String toString() => 'ReportFilterStatusUpdated { Date: $date  }';
}
