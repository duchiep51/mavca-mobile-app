part of 'violation_filter_bloc.dart';

abstract class ViolationFilterEvent extends Equatable {
  const ViolationFilterEvent();

  @override
  List<Object> get props => [];
}

// class FilterUpdated extends ViolationFilterEvent {
//   final String filter;

//   FilterUpdated(this.filter);

//   @override
//   List<Object> get props => [filter];

//   @override
//   String toString() => 'FilterUpdated { filter: $filter }';
// }
class FilterUpdated extends ViolationFilterEvent {
  final Filter filter;

  FilterUpdated(this.filter);

  @override
  List<Object> get props => [filter];

  @override
  String toString() => 'FilterUpdated { filter: $filter }';
}

class ViolationFilterBranchIdUpdated extends ViolationFilterEvent {
  final int branchId;

  ViolationFilterBranchIdUpdated({this.branchId});
  @override
  String toString() =>
      'ViolationFilterBranchIdUpdated { BranchId: $branchId  }';
}

class ViolationFilterRegulationUpdated extends ViolationFilterEvent {
  final int regulationId;

  ViolationFilterRegulationUpdated({this.regulationId});
  @override
  String toString() =>
      'ViolationFilterRegulationUpdated { RegulationId: $regulationId  }';
}

class ViolationFilterStatusUpdated extends ViolationFilterEvent {
  final String status;

  ViolationFilterStatusUpdated({this.status});
  @override
  String toString() => 'ViolationFilterStatusUpdated { Status: $status  }';
}

class ViolationFilterMonthUpdated extends ViolationFilterEvent {
  final DateTime date;

  ViolationFilterMonthUpdated({this.date});
  @override
  String toString() => 'ViolationFilterMonthUpdated { Month: $date  }';
}
