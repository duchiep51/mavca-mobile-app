import 'package:bloc/bloc.dart';
import 'package:capstone_mobile/src/data/repositories/report/report_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'report_delete_state.dart';

class ReportDeleteCubit extends Cubit<ReportDeleteState> {
  final ReportRepository reportRepository;
  ReportDeleteCubit({@required this.reportRepository})
      : super(ReportDeleteInitial());

  Future<void> deleteReport(String token, int id) async {
    try {
      emit(ReportDeleteInProgress());
      final result = await reportRepository.deleteReport(token: token, id: id);
      emit(ReportDeleteSuccess());
    } catch (e) {
      print(e);
      emit(ReportDeleteFail());
    }
  }
}
