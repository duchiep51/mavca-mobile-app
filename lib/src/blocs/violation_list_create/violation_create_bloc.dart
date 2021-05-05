import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:capstone_mobile/src/blocs/violation/violation_bloc.dart';
import 'package:capstone_mobile/src/data/models/regulation/regulation.dart';
import 'package:capstone_mobile/src/data/models/violation/violation.dart';
import 'package:capstone_mobile/src/data/models/violation/violation_description.dart';
import 'package:capstone_mobile/src/data/models/violation/violation_regulation.dart';
import 'package:capstone_mobile/src/data/repositories/authentication/authentication_repository.dart';
import 'package:capstone_mobile/src/data/repositories/violation/violation_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';

part 'violation_create_event.dart';
part 'violation_create_state.dart';

class ViolationCreateBloc
    extends Bloc<ViolationCreateEvent, ViolationCreateState> {
  final ViolationRepository violationRepository;
  final AuthenticationRepository authenticationRepository;
  final ViolationBloc violationBloc;

  ViolationCreateBloc({
    @required this.violationRepository,
    @required this.authenticationRepository,
    @required this.violationBloc,
  }) : super(ViolationCreateState());

  @override
  Stream<ViolationCreateState> mapEventToState(
    ViolationCreateEvent event,
  ) async* {
    if (event is ViolationDescriptionChanged) {
      yield _mapViolationDescriptionToState(event, state);
    } else if (event is ViolationRegulationChanged) {
      yield _mapViolationRegulationChangetoState(event, state);
    } else if (event is ViolationExcuseChanged) {
      yield* _mapViolationExcuseToState(event);
    } else if (event is ViolationDeleted) {
      yield* _mapViolationDeleteToState(event);
    } else if (event is ViolationUpdated) {
      yield* _mapViolationCreateAddedToState(event, state);
    }
  }

  ViolationCreateState _mapViolationRegulationChangetoState(
      ViolationRegulationChanged event, ViolationCreateState state) {
    final regulation = ViolationRegulation.dirty(event.regulation);
    return state.copyWith(
      violationRegulation: regulation,
      status: Formz.validate([
        state.violationDescription,
        regulation,
        // state.violationBranch,
      ]),
    );
  }

  ViolationCreateState _mapViolationDescriptionToState(
      ViolationDescriptionChanged event, ViolationCreateState state) {
    final violationDescription =
        ViolationDescription.dirty(event.violationDescription);
    return state.copyWith(
      violationDescription: violationDescription,
      status: Formz.validate(
        [
          violationDescription,
          state.violationRegulation,
          // state.violationBranch,
        ],
      ),
    );
  }

  Stream<ViolationCreateState> _mapViolationCreateAddedToState(
    ViolationUpdated event,
    ViolationCreateState state,
  ) async* {
    if (state.status.isValidated) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        await violationRepository.editViolation(
          token: authenticationRepository.token,
          violation: event.violation,
        );

        violationBloc.add(ViolationRequested(isRefresh: true));
        yield state.copyWith(
          status: FormzStatus.submissionSuccess,
        );
      } catch (e) {
        print(e);
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }

  Stream<ViolationCreateState> _mapViolationExcuseToState(
    ViolationExcuseChanged event,
  ) async* {
    yield state.copyWith(status: FormzStatus.submissionInProgress);
    try {
      await violationRepository.editViolation(
        token: authenticationRepository.token,
        violation: event.violation,
      );

      violationBloc.add(ViolationRequested(isRefresh: true));
      yield state.copyWith(
        status: FormzStatus.submissionSuccess,
      );
    } catch (e) {
      print(e);
      yield state.copyWith(status: FormzStatus.submissionFailure);
    }
  }

  Stream<ViolationCreateState> _mapViolationDeleteToState(
    ViolationDeleted event,
  ) async* {
    yield state.copyWith(status: FormzStatus.submissionInProgress);
    try {
      await violationRepository.deleteViolation(
        token: authenticationRepository.token,
        id: event.id,
      );
      violationBloc.add(ViolationRequested(isRefresh: true));
      yield state.copyWith(
        status: FormzStatus.submissionSuccess,
      );
    } catch (e) {
      print(e);
      yield state.copyWith(status: FormzStatus.submissionFailure);
    }
  }
}
