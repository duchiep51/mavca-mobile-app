import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'package:capstone_mobile/src/data/models/report/report.dart';
import 'package:capstone_mobile/src/data/repositories/report/report_api.dart';

class ReportRepository {
  ReportRepository();
  ReportApi _reportApi = ReportApi(httpClient: http.Client());

  Future<List<Report>> fetchReports({
    @required String token,
    String status,
    String sort,
    double page,
    int limit,
    int branchId,
    DateTime date,
  }) async {
    return await _reportApi.getReports(
      token: token,
      status: status,
      page: page,
      limit: limit,
      branchId: branchId,
      date: date,
      sort: sort,
    );
  }

  Future<String> editReport({
    @required String token,
    @required Report report,
  }) async {
    var result = await _reportApi.editReport(
      token: token,
      report: report,
    );

    return result == 200 ? 'success' : 'fail';
  }

  Future<String> deleteReport({
    @required String token,
    @required int id,
  }) async {
    var result = await _reportApi.deleteReport(token: token, id: id);

    return result == 200 ? 'success' : 'fail';
  }
}
