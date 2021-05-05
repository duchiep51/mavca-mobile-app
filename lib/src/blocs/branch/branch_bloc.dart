import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:capstone_mobile/src/data/repositories/authentication/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:capstone_mobile/src/data/models/branch/branch.dart';
import 'package:capstone_mobile/src/data/repositories/branch/branch_repository.dart';
part 'branch_event.dart';
part 'branch_state.dart';

class BranchBloc extends Bloc<BranchEvent, BranchState> {
  final BranchRepository branchRepository;
  final AuthenticationRepository _authenticationRepository;
  StreamSubscription<AuthenticationStatus> _authenticationStatusSubscription;

  BranchBloc({
    @required this.branchRepository,
    @required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(BranchInitial()) {
    _authenticationStatusSubscription = _authenticationRepository.status.listen(
      (status) => add(BranchAuthenticationStatusChanged(status: status)),
    );
  }

  @override
  Future<void> close() {
    _authenticationStatusSubscription?.cancel();
    _authenticationRepository.dispose();
    return super.close();
  }

  @override
  Stream<BranchState> mapEventToState(
    BranchEvent event,
  ) async* {
    if (event is BranchRequested) {
      try {
        yield BranchLoadInProgress();
        var branches = await branchRepository
            .fetchBranches(_authenticationRepository.token);
        yield BranchLoadSuccess(branches: branches);
      } catch (e) {
        yield BranchLoadFailure();
      }
    } else if (event is BranchAuthenticationStatusChanged) {
      if (event.status == AuthenticationStatus.unauthenticated) {
        yield (BranchInitial());
      } else if (event.status == AuthenticationStatus.authenticated) {
        add(BranchRequested());
      }
    }
  }
}
