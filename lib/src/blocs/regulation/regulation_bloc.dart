import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:capstone_mobile/src/data/models/regulation/regulation.dart';
import 'package:meta/meta.dart';
import 'package:capstone_mobile/src/data/repositories/regulation/regulation_repository.dart';

part 'regulation_event.dart';
part 'regulation_state.dart';

class RegulationBloc extends Bloc<RegulationEvent, RegulationState> {
  final RegulationRepository regulationRepository;
  RegulationBloc({@required this.regulationRepository})
      : super(RegulationInitial());

  @override
  Stream<RegulationState> mapEventToState(
    RegulationEvent event,
  ) async* {
    if (event is RegulationRequested) {
      try {
        yield RegulationLoadInProgress();
        var regulations =
            await regulationRepository.fetchRegulationes(event.token);
        yield RegulationLoadSuccess(regulations: regulations);
      } catch (e) {
        yield RegulationLoadFailure();
      }
    }
  }
}
