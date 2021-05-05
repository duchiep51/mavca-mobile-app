import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:capstone_mobile/src/blocs/report/report_bloc.dart';
import 'package:capstone_mobile/src/data/repositories/authentication/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';

import 'package:capstone_mobile/src/data/models/report/report.dart';
import 'package:capstone_mobile/src/data/models/report/report_branch.dart';
import 'package:capstone_mobile/src/data/models/report/report_description.dart';
import 'package:capstone_mobile/src/data/models/report/report_list_violation.dart';
import 'package:capstone_mobile/src/data/models/report/report_name.dart';
import 'package:capstone_mobile/src/data/models/violation/violation.dart';
import 'package:capstone_mobile/src/data/repositories/branch/branch_repository.dart';
import 'package:capstone_mobile/src/data/repositories/report/report_repository.dart';

part 'report_create_event.dart';
part 'report_create_state.dart';

class ReportCreateBloc extends Bloc<ReportCreateEvent, ReportCreateState> {
  ReportCreateBloc({
    @required this.branchRepository,
    @required this.reportRepository,
    @required this.authenticationRepository,
    @required this.reportBloc,
  }) : super(ReportCreateState());

  final ReportRepository reportRepository;
  final BranchRepository branchRepository;
  final AuthenticationRepository authenticationRepository;
  final ReportBloc reportBloc;

  @override
  Stream<ReportCreateState> mapEventToState(
    ReportCreateEvent event,
  ) async* {
    if (event is ReportNameChanged) {
      yield _mapReportNameChangeToState(event, state);
    } else if (event is ReportDescriptionChanged) {
      yield _mapReportDesriptionChangeToState(event, state);
    } else if (event is ReportBranchChanged) {
      yield _mapReportBranchChangetoState(event, state);
    } else if (event is ReportViolationsChanged) {
      yield _mapReportViolationListChangeToState(event, state);
    } else if (event is ReportEditing) {
      yield _mapReportEditToState(event, state);
    } else if (event is ReportEdited) {
      yield* _mapReportEditSubmittedToState(event, state);
    }
  }

  ReportCreateState _mapReportNameChangeToState(
      ReportNameChanged event, ReportCreateState state) {
    final reportName = ReportName.dirty(event.reportName);
    return state.copyWith(
        reportName: reportName,
        status: Formz.validate(
            [reportName, state.reportDescription, state.reportBranch]));
  }

  ReportCreateState _mapReportBranchChangetoState(
      ReportBranchChanged event, ReportCreateState state) {
    final reportBranch = ReportBranch.dirty(event.reportBranchId);
    return state.copyWith(
      reportBranch: reportBranch,
      status: Formz.validate([
        state.reportDescription,
        state.reportListViolation,
        reportBranch,
      ]),
    );
  }

  ReportCreateState _mapReportDesriptionChangeToState(
    ReportDescriptionChanged event,
    ReportCreateState state,
  ) {
    final reportDescription = ReportDescription.dirty(event.reportDescription);
    return state.copyWith(
      reportDescription: reportDescription,
      isEditing: event.isEditing,
      status: Formz.validate(
        [],
      ),
    );
  }

  ReportCreateState _mapReportViolationListChangeToState(
      ReportViolationsChanged event, ReportCreateState state) {
    List<Violation> list = state.reportListViolation.value;
    // ?.map((violation) => violation)
    // ?.toList();

    if (list == null) {
      list = List();
    }

    list.add(event.reportViolation);

    final reportListViolation = ReportListViolation.dirty(list);

    return state.copyWith(
      reportListViolation: reportListViolation,
      isEditing: event.isEditing,
      status: Formz.validate([
        reportListViolation,
        state.reportDescription,
        state.reportBranch,
      ]),
    );
  }

  Stream<ReportCreateState> _mapReportEditSubmittedToState(
    ReportEdited event,
    ReportCreateState state,
  ) async* {
    yield state.copyWith(status: FormzStatus.submissionInProgress);
    try {
      var result = await reportRepository.editReport(
          token: authenticationRepository.token,
          report: event.report.copyWith(
            qcNote: state.reportDescription.value,
          ));

      reportBloc.add(ReportRequested(isRefresh: true));

      yield state.copyWith(status: FormzStatus.submissionSuccess);
    } catch (e) {
      print(e);
      yield state.copyWith(status: FormzStatus.submissionFailure);
    }
  }

  ReportCreateState _mapReportEditToState(
    ReportEditing event,
    ReportCreateState state,
  ) {
    // final ReportListViolation reportlistViolation =
    //     ReportListViolation.dirty(event.report.violations);
    final ReportDescription reportDescription =
        ReportDescription.dirty(event.report.qcNote);
    return state.copyWith(
      // reportListViolation: reportlistViolation,
      reportDescription: reportDescription,
      isEditing: false,
      status: Formz.validate(
        [],
      ),
    );
  }
}
