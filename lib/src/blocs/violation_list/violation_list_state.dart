part of 'violation_list_bloc.dart';

class ViolationListState extends Equatable {
  const ViolationListState({
    this.violations,
    this.status = FormzStatus.pure,
    this.violationBranch = const ViolationBranch.pure(),
    this.violationReport = const ViolationReport.pure(),
  });

  final List<Violation> violations;
  final FormzStatus status;
  final ViolationBranch violationBranch;
  final ViolationReport violationReport;

  ViolationListState copyWith({
    FormzStatus status,
    List<Violation> violations,
    ViolationBranch violationBranch,
    ViolationReport violationReport,
  }) {
    return ViolationListState(
      violations: violations ?? this.violations,
      status: status ?? this.status,
      violationBranch: violationBranch ?? this.violationBranch,
      violationReport: violationReport ?? this.violationReport,
    );
  }

  @override
  List<Object> get props => [
        violations,
        status,
        violationBranch,
        violationReport,
      ];
}
