import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:capstone_mobile/src/data/models/report/report.dart';
import 'package:capstone_mobile/src/data/repositories/authentication/authentication_repository.dart';
import 'package:capstone_mobile/src/data/repositories/report/report_repository.dart';
import 'package:capstone_mobile/src/ui/constants/constant.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'report_by_demand_event.dart';
part 'report_by_demand_state.dart';

class ReportByDemandBloc
    extends Bloc<ReportByDemandEvent, ReportByDemandState> {
  final ReportRepository _reportRepository;
  final AuthenticationRepository _authenticationRepository;

  ReportByDemandBloc(
      {@required ReportRepository reportRepository,
      @required AuthenticationRepository authenticationRepository})
      : _reportRepository = reportRepository,
        _authenticationRepository = authenticationRepository,
        super(ReportByDemandInitial());

  @override
  Stream<ReportByDemandState> mapEventToState(
    ReportByDemandEvent event,
  ) async* {
    if (event is ReportByDemandRequested) {
      yield* _mapReportRequested(event);
    } else if (event is ReportByDemandUpdated) {
      yield* _mapReportUpdated(event);
    }
  }

  Stream<ReportByDemandState> _mapReportRequested(
    ReportByDemandRequested event,
  ) async* {
    try {
      yield ReportByDemandLoadInProgress();
      var reports = List<Report>();
      if (event.roleName.toLowerCase() == Constant.ROLE_QC.toLowerCase()) {
        reports = await _reportRepository.fetchReports(
          token: _authenticationRepository.token,
          date: DateTime.now(),
          status: 'Opening',
        );
      } else if (event.roleName.toLowerCase() ==
          Constant.ROLE_BM.toLowerCase()) {
        reports = await _reportRepository.fetchReports(
          token: _authenticationRepository.token,
          sort: 'desc createdAt',
          limit: 2,
          status: 'Done',
        );
      }
      yield ReportByDemandLoadSuccess(reports: reports);
    } catch (e) {
      yield ReportByDemandLoadFailure();
    }
  }

  Stream<ReportByDemandState> _mapReportUpdated(
    ReportByDemandUpdated event,
  ) async* {
    if (state is ReportByDemandLoadSuccess) {
      final updatedReports = List<Report>.from(
          (state as ReportByDemandLoadSuccess).reports.map((report) =>
              report.id == event.report.id ? event.report : report));
      yield ReportByDemandLoadSuccess(reports: updatedReports);
    }
  }
}
