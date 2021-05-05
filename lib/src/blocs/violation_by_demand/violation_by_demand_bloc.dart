import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:capstone_mobile/src/data/models/violation/violation.dart';
import 'package:capstone_mobile/src/data/repositories/authentication/authentication_repository.dart';
import 'package:capstone_mobile/src/data/repositories/violation/violation_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'violation_by_demand_event.dart';
part 'violation_by_demand_state.dart';

class ViolationByDemandBloc
    extends Bloc<ViolationByDemandEvent, ViolationByDemandState> {
  ViolationByDemandBloc({
    @required ViolationRepository violationRepository,
    @required AuthenticationRepository authenticationRepository,
  })  : _violationRepository = violationRepository,
        _authenticationRepository = authenticationRepository,
        super(ViolationByDemandInitial());

  final ViolationRepository _violationRepository;
  final AuthenticationRepository _authenticationRepository;

  @override
  Stream<ViolationByDemandState> mapEventToState(
    ViolationByDemandEvent event,
  ) async* {
    if (event is ViolationRequestedByDate) {
      yield* _mapVilationRequestedByDateToState(event);
    } else if (event is ViolationByDemandUpdated) {
      yield* _mapVilationByDemandUpdatedToState(event);
    } else if (event is ViolationRequestedByReportId) {
      yield* _mapVilationRequestedByReportIdToState(event);
    } else if (event is ViolationByDemandDeleted) {
      yield* _mapVilationByDemandDeletedToState(event);
    }
  }

  Stream<ViolationByDemandState> _mapVilationRequestedByDateToState(
    ViolationRequestedByDate event,
  ) async* {
    try {
      yield (ViolationByDemandLoadInProgress());
      final violations = await _violationRepository.fetchViolations(
        token: _authenticationRepository.token,
        onDate: event.date,
        sort: 'desc createdAt',
        limit: 50,
      );
      yield (ViolationByDemandLoadSuccess(violations: violations));
    } catch (e) {
      yield (ViolationByDemandLoadFailure());
    }
  }

  Stream<ViolationByDemandState> _mapVilationRequestedByReportIdToState(
    ViolationRequestedByReportId event,
  ) async* {
    try {
      yield (ViolationByDemandLoadInProgress());
      final violations = await _violationRepository.fetchViolations(
        token: _authenticationRepository.token,
        sort: 'desc createdAt',
        reportId: event.reportId,
        limit: 100,
      );
      yield (ViolationByDemandLoadSuccess(violations: violations));
    } catch (e) {
      yield (ViolationByDemandLoadFailure());
    }
  }

  Stream<ViolationByDemandState> _mapVilationByDemandUpdatedToState(
    ViolationByDemandUpdated event,
  ) async* {
    if (state is ViolationByDemandLoadSuccess) {
      yield (ViolationByDemandLoadInProgress());

      var updatedViolation = List<Violation>.from(
          (state as ViolationByDemandLoadSuccess).violations.map((violation) =>
              violation.id == event.violation.id
                  ? event.violation
                  : violation));
      yield (ViolationByDemandLoadSuccess(violations: updatedViolation));
    }
  }

  Stream<ViolationByDemandState> _mapVilationByDemandDeletedToState(
    ViolationByDemandDeleted event,
  ) async* {
    if (state is ViolationByDemandLoadSuccess) {
      yield (ViolationByDemandLoadInProgress());

      var updatedViolations =
          (state as ViolationByDemandLoadSuccess).violations;

      updatedViolations = List<Violation>.from(updatedViolations
        ..removeWhere((violation) => violation.id == event.id)
        ..map((violation) => violation));

      yield (ViolationByDemandLoadSuccess(violations: updatedViolations));
    }
  }
}
