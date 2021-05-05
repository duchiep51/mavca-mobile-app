import 'dart:async';

import 'package:capstone_mobile/src/blocs/violation_filter/filter.dart';
import 'package:capstone_mobile/src/data/repositories/authentication/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'package:capstone_mobile/src/data/models/violation/violation.dart';
import 'package:capstone_mobile/src/data/repositories/violation/violation_repository.dart';
import 'package:equatable/equatable.dart';

part 'violation_event.dart';
part 'violation_state.dart';

class ViolationBloc extends Bloc<ViolationEvent, ViolationState> {
  ViolationBloc({
    @required this.violationRepository,
    @required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(ViolationInitial()) {
    _authenticationStatusSubscription = _authenticationRepository.status.listen(
      (status) => add(ViolationAuthenticationStatusChanged(status: status)),
    );
  }

  final ViolationRepository violationRepository;
  final AuthenticationRepository _authenticationRepository;
  StreamSubscription<AuthenticationStatus> _authenticationStatusSubscription;

  @override
  Future<void> close() {
    _authenticationStatusSubscription?.cancel();
    _authenticationRepository.dispose();
    return super.close();
  }

  @override
  Stream<Transition<ViolationEvent, ViolationState>> transformEvents(
    Stream<ViolationEvent> events,
    TransitionFunction<ViolationEvent, ViolationState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<ViolationState> mapEventToState(
    ViolationEvent event,
  ) async* {
    final currentState = state;
    if ((event is ViolationRequested)) {
      try {
        if (currentState is ViolationInitial) {
          final List<Violation> violations =
              await violationRepository.fetchViolations(
            token: _authenticationRepository.token,
            sort: 'desc createdAt',
            page: 0,
          );

          yield ViolationLoadSuccess(
            violations: violations,
            hasReachedMax: violations.length < 20 ? true : false,
            activeFilter: Filter(),
          );
          return;
        }

        if (currentState is ViolationLoadFailure) {
          final List<Violation> violations =
              await violationRepository.fetchViolations(
            token: _authenticationRepository.token,
            sort: 'desc createdAt',
            page: 0,
          );

          yield ViolationLoadSuccess(
            violations: violations,
            hasReachedMax: violations.length < 20 ? true : false,
            activeFilter: Filter(),
          );
          return;
        }

        if (currentState is ViolationLoadSuccess && event.isRefresh == true) {
          final List<Violation> violations =
              await violationRepository.fetchViolations(
            token: _authenticationRepository.token,
            sort: 'desc createdAt',
            limit: currentState.violations.length <= 0
                ? 20
                : currentState.violations.length,
            branchId: currentState.activeFilter?.branchId,
            regulationId: currentState.activeFilter?.regulationId,
            status: currentState.activeFilter?.status,
            date: currentState.activeFilter.date,
          );

          yield currentState.copyWith(
            violations: violations,
          );
          return;
        }

        if (currentState is ViolationLoadSuccess &&
            !_hasReachedMax(currentState)) {
          final List<Violation> violations =
              await violationRepository.fetchViolations(
            token: _authenticationRepository.token,
            sort: 'desc createdAt',
            page: currentState.violations.length / 20,
            branchId: currentState.activeFilter?.branchId,
            regulationId: currentState.activeFilter?.regulationId,
            status: currentState.activeFilter?.status,
            date: currentState.activeFilter.date,
          );

          yield violations.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : currentState.copyWith(
                  violations: currentState.violations + violations,
                  hasReachedMax: false,
                );
          return;
        }
      } catch (e) {
        print(e);
        yield ViolationLoadFailure();
      }
    } else if (event is FilterChanged) {
      yield* _mapFilterChangeToState(event);
    } else if (event is ViolationUpdate) {
      yield* _mapViolationUpdateToState(event);
    } else if (event is ViolationDelete) {
      yield* _mapViolationDeleteToState(event);
    } else if (event is ViolationAuthenticationStatusChanged) {
      if (event.status == AuthenticationStatus.unauthenticated) {
        yield (ViolationInitial());
      } else if (event.status == AuthenticationStatus.authenticated) {
        add(ViolationRequested());
      }
    }
  }

  Stream<ViolationState> _mapFilterChangeToState(FilterChanged event) async* {
    final currentState = state;

    try {
      if (currentState is ViolationLoadSuccess) {
        final List<Violation> violations =
            await violationRepository.fetchViolations(
          token: _authenticationRepository.token,
          sort: 'desc createdAt',
          page: 0,
          branchId: event.filter?.branchId,
          regulationId: event.filter?.regulationId,
          status: event.filter?.status,
          date: event.filter?.date,
        );

        yield currentState.copyWith(
          hasReachedMax: violations.length < 20 ? true : false,
          violations: violations,
          activeFilter: event.filter,
        );
      }
    } catch (e) {
      print(' _mapFilterChangeToState: ');
      print(e.toString());
    }
  }

  Stream<ViolationState> _mapViolationUpdateToState(
      ViolationUpdate event) async* {
    final currentState = state;
    try {
      if (currentState is ViolationLoadSuccess) {
        await violationRepository.editViolation(
          token: _authenticationRepository.token,
          violation: event.violation,
        );

        final List<Violation> updatedViolations =
            await violationRepository.fetchViolations(
          token: _authenticationRepository.token,
          sort: 'desc createdAt',
          limit: currentState.violations.length,
        );

        yield currentState.copyWith(
          violations: updatedViolations,
        );
      }
    } catch (e) {
      print(' _mapViolationUpdateToState');
      print(e.toString());
    }
  }

  Stream<ViolationState> _mapViolationDeleteToState(
      ViolationDelete event) async* {
    final currentState = state;
    // yield
    try {
      if (currentState is ViolationLoadSuccess) {
        await violationRepository.deleteViolation(
          token: _authenticationRepository.token,
          id: event.id,
        );
        final List<Violation> updatedViolations =
            await violationRepository.fetchViolations(
          token: _authenticationRepository.token,
          sort: 'desc createdAt',
          limit: currentState.violations.length,
        );
        yield currentState.copyWith(
          violations: updatedViolations,
          screen: '/Home',
        );
      }
    } catch (e) {
      print(' _mapViolationDeleteToState');
      print(e);
    }
  }

  bool _hasReachedMax(ViolationState state) =>
      state is ViolationLoadSuccess && state.hasReachedMax;
}
