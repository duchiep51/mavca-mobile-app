import 'package:bloc/bloc.dart';
import 'package:capstone_mobile/src/data/models/branch/branch.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';

import 'package:capstone_mobile/src/data/models/violation/violation.dart';
import 'package:capstone_mobile/src/data/repositories/violation/violation_repository.dart';
import 'package:capstone_mobile/src/data/models/violation/violation_branch.dart';
import 'package:capstone_mobile/src/data/models/violation/violation_report.dart';

part 'violation_list_state.dart';
part 'violation_list_event.dart';

class ViolationListBloc extends Bloc<ViolationListEvent, ViolationListState> {
  final ViolationRepository violationRepository;

  ViolationListBloc({@required this.violationRepository})
      : super(ViolationListState(violations: List<Violation>()));

  @override
  Stream<ViolationListState> mapEventToState(
    ViolationListEvent event,
  ) async* {
    if (event is ViolationListChanged) {
      yield _mapViolationListChangeToState(event, state);
    } else if (event is ViolationBranchChanged) {
      yield _mapViolationBranchChangetoState(event, state);
    } else if (event is ViolationListRemove) {
      yield _mapViolationListRemoveToState(event, state);
    } else if (event is ViolationItemUpdate) {
      yield _mapViolationUpdateToState(event, state);
    } else if (event is ViolationListSubmitted) {
      yield* _mapViolationListSubmittedToState(event, state);
    } else if (event is ViolationReportChanged) {
      yield _mapViolationReportChangetoState(event, state);
    }
  }

  ViolationListState _mapViolationBranchChangetoState(
    ViolationBranchChanged event,
    ViolationListState state,
  ) {
    // print(event.branch.name);
    final branch = ViolationBranch.dirty(event.branch);
    return state.copyWith(
      violationBranch: branch,
    );
  }

  ViolationListState _mapViolationReportChangetoState(
    ViolationReportChanged event,
    ViolationListState state,
  ) {
    print(event.reportId ?? 'bac');
    final report = ViolationReport.dirty(event.reportId);
    return state.copyWith(
      violationReport: report,
    );
  }

  ViolationListState _mapViolationListChangeToState(
    ViolationListChanged event,
    ViolationListState state,
  ) {
    final violation = event.violation;
    List<Violation> violations =
        state.violations.map((violation) => violation).toList();

    violations.add(violation);
    return state.copyWith(
      violations: violations,
      status: FormzStatus.valid,
    );
  }

  ViolationListState _mapViolationUpdateToState(
    ViolationItemUpdate event,
    ViolationListState state,
  ) {
    List<Violation> violations =
        state.violations.map((violation) => violation).toList();

    violations[event.position] = event.violation;

    return state.copyWith(
      violations: violations,
      status: FormzStatus.valid,
    );
  }

  ViolationListState _mapViolationListRemoveToState(
    ViolationListRemove event,
    ViolationListState state,
  ) {
    if (state.violations.length < 1) {
      return state.copyWith(
        status: FormzStatus.invalid,
      );
    }

    List<Violation> violations =
        state.violations.map((violation) => violation).toList();

    violations.removeAt(event.position);

    return state.copyWith(
      violations: violations,
      status: violations.length > 0 ? FormzStatus.valid : FormzStatus.invalid,
    );
  }

  Stream<ViolationListState> _mapViolationListSubmittedToState(
    ViolationListSubmitted event,
    ViolationListState state,
  ) async* {
    yield state.copyWith(status: FormzStatus.submissionInProgress);
    try {
      var violations = state.violations.map((violation) {
        return violation.copyWith(
          branchId: state.violationBranch.value.id,
          reportId: state.violationReport.value,
        );
      }).toList();
      print(violations.length.toString());
      var result = await violationRepository.createViolations(
        token: event.token,
        violations: violations,
      );
      yield state.copyWith(
        status: FormzStatus.submissionSuccess,
      );
      yield state.copyWith(
        violations: List<Violation>(),
        status: FormzStatus.invalid,
      );
    } catch (e) {
      print('error at violation_list_bloc: ');
      print(e.toString());
      yield state.copyWith(status: FormzStatus.submissionFailure);
    }
  }
}
