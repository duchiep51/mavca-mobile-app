import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:capstone_mobile/src/blocs/violation_filter/filter.dart';
import '../violation/violation_bloc.dart';

part 'violation_filter_event.dart';
part 'violation_filter_state.dart';

class ViolationFilterBloc
    extends Bloc<ViolationFilterEvent, ViolationFilterState> {
  ViolationFilterBloc({@required this.violationbloc})
      : super(ViolationFilterState(
            filter:
                (violationbloc.state as ViolationLoadSuccess).activeFilter));

  final ViolationBloc violationbloc;

  @override
  Stream<ViolationFilterState> mapEventToState(
    ViolationFilterEvent event,
  ) async* {
    if (event is ViolationFilterBranchIdUpdated) {
      violationbloc.add(FilterChanged(
        filter: Filter(
          branchId: event.branchId,
          status: state.filter.status,
          regulationId: state.filter.regulationId,
          date: state.filter.date,
        ),
      ));
      yield state.copyWith(
        filter: Filter(
          branchId: event.branchId,
          status: state.filter.status,
          regulationId: state.filter.regulationId,
          date: state.filter.date,
        ),
      );
    } else if (event is ViolationFilterRegulationUpdated) {
      violationbloc.add(FilterChanged(
        filter: Filter(
          branchId: state.filter.branchId,
          status: state.filter.status,
          regulationId: event.regulationId,
          date: state.filter.date,
        ),
      ));
      yield state.copyWith(
        filter: Filter(
          branchId: state.filter.branchId,
          status: state.filter.status,
          regulationId: event.regulationId,
          date: state.filter.date,
        ),
      );
    } else if (event is ViolationFilterStatusUpdated) {
      violationbloc.add(FilterChanged(
        filter: Filter(
          branchId: state.filter.branchId,
          status: event.status,
          regulationId: state.filter.regulationId,
          date: state.filter.date,
        ),
      ));
      yield state.copyWith(
        filter: Filter(
          branchId: state.filter.branchId,
          status: event.status,
          regulationId: state.filter.regulationId,
          date: state.filter.date,
        ),
      );
    } else if (event is ViolationFilterMonthUpdated) {
      violationbloc.add(FilterChanged(
        filter: Filter(
          branchId: state.filter.branchId,
          status: state.filter.status,
          regulationId: state.filter.regulationId,
          date: event.date,
        ),
      ));
      yield state.copyWith(
        filter: Filter(
          branchId: state.filter.branchId,
          status: state.filter.status,
          regulationId: state.filter.regulationId,
          date: event.date,
        ),
      );
    }
  }
}
