import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:capstone_mobile/src/blocs/violation_filter/filter.dart';
import 'package:capstone_mobile/src/data/models/report/report.dart';
import 'package:capstone_mobile/src/data/repositories/authentication/authentication_repository.dart';
import 'package:capstone_mobile/src/data/repositories/report/report_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository reportRepository;
  final AuthenticationRepository _authenticationRepository;
  StreamSubscription<AuthenticationStatus> _authenticationStatusSubscription;

  ReportBloc({
    @required this.reportRepository,
    @required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(ReportInitial()) {
    _authenticationStatusSubscription = _authenticationRepository.status.listen(
      (status) => add(ReportAuthenticationStatusChanged(status: status)),
    );
  }

  @override
  Future<void> close() {
    _authenticationStatusSubscription?.cancel();
    _authenticationRepository.dispose();
    return super.close();
  }

  @override
  Stream<ReportState> mapEventToState(
    ReportEvent event,
  ) async* {
    if (event is ReportRequested) {
      yield* _mapReportRequestedToState(event);
    } else if (event is FilterChanged) {
      yield* _mapFilterChangedToState(event);
    } else if (event is ReportAuthenticationStatusChanged) {
      if (event.status == AuthenticationStatus.unauthenticated) {
        yield (ReportInitial());
      } else if (event.status == AuthenticationStatus.authenticated) {
        add(ReportRequested());
      }
    }
  }

  Stream<ReportState> _mapReportRequestedToState(
    ReportRequested event,
  ) async* {
    final currentState = state;
    try {
      if (currentState is ReportInitial || currentState is ReportLoadFailure) {
        final List<Report> reports = await reportRepository.fetchReports(
          token: _authenticationRepository.token,
          sort: 'desc createdAt',
          page: 0,
        );

        yield ReportLoadSuccess(
          reports: reports,
          hasReachedMax: reports.length < 20 ? true : false,
          activeFilter: Filter(),
        );
        return;
      }

      if (currentState is ReportLoadSuccess && event.isRefresh == true) {
        final List<Report> reports = await reportRepository.fetchReports(
          token: _authenticationRepository.token,
          sort: 'desc createdAt',
          limit: currentState.reports.length == 0
              ? 20
              : currentState.reports.length,
          branchId: currentState.activeFilter.branchId,
          status: currentState.activeFilter.status,
          date: currentState.activeFilter.date,
        );

        yield currentState.copyWith(
          reports: reports,
        );
        return;
      }

      if (currentState is ReportLoadSuccess && !_hasReachedMax(currentState)) {
        final List<Report> reports = await reportRepository.fetchReports(
          token: _authenticationRepository.token,
          sort: 'desc createdAt',
          page: currentState.reports.length / 20,
          branchId: currentState.activeFilter?.branchId,
          status: currentState.activeFilter?.status,
          date: currentState.activeFilter.date,
        );
        yield reports.isEmpty
            ? currentState.copyWith(hasReachedMax: true)
            : currentState.copyWith(
                reports: currentState.reports + reports,
                hasReachedMax: false,
              );
        return;
      }
    } catch (e) {
      print(' _mapReportRequestedToState: ');
      print(e);
      yield ReportLoadFailure();
    }
  }

  Stream<ReportState> _mapFilterChangedToState(FilterChanged event) async* {
    final currentState = state;
    try {
      if (currentState is ReportLoadSuccess) {
        final List<Report> reports = await reportRepository.fetchReports(
          token: _authenticationRepository.token,
          sort: 'desc createdAt',
          page: 0,
          branchId: event.filter?.branchId,
          status: event.filter?.status,
          date: event.filter?.date,
        );

        yield currentState.copyWith(
          hasReachedMax: reports.length < 20 ? true : false,
          reports: reports,
          activeFilter: event.filter,
        );
      }
    } catch (e) {
      print(' _mapFilterChangeToState: ');
      print(e);
    }
  }

  bool _hasReachedMax(ReportState state) =>
      state is ReportLoadSuccess && state.hasReachedMax;
}
