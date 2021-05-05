import 'package:date_util/date_util.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import 'package:capstone_mobile/Api/BaseApi.dart';
import 'package:capstone_mobile/src/data/models/report/report.dart';

class ReportApi {
  final http.Client httpClient;
  BaseApi _baseApi = BaseApi();
  final reportUrl = 'reports';

  ReportApi({@required this.httpClient});

  Future<List<Report>> getReports({
    @required String token,
    String status,
    String sort,
    double page,
    int limit,
    int branchId,
    DateTime date,
    Map<String, String> opts,
  }) async {
    String url = reportUrl + '?Filter.IsDeleted=false';
    if (status != null) {
      url += '&Filter.Status=$status';
    }
    if (sort != null) {
      url += '&Sort.Orders=$sort';
    }
    if (page != null) {
      url += '&PageIndex=${page.ceil()}';
    }
    if (limit != null) {
      url += '&Limit=$limit';
    }
    if (branchId != null) {
      url += '&Filter.BranchIds=$branchId';
    }
    if (date != null) {
      var dateUtility = DateUtil();
      var month = date.month;
      var year = date.year;
      var daysInMonth = dateUtility.daysInMonth(month, year);
      var from = '$year-$month-01';
      var to = '$year-$month-$daysInMonth';

      url += '&Filter.FromDate=$from';
      url += '&Filter.ToDate=$to';
    }

    final reportJson = await _baseApi.get(url, token, opts: opts);

    final reports = reportJson['data']['result'] as List;
    return reports.map((report) => Report.fromJson(report)).toList();
  }

  Future<int> editReport({
    @required String token,
    @required Report report,
    Map<String, String> opts,
  }) async {
    final url = reportUrl + '/' + report.id.toString();
    final body = <String, dynamic>{
      'qcNote': report.qcNote.trim(),
      'description': 'description',
      'status': report.status,
    };

    final result = await _baseApi.put(
      url,
      body,
      token,
      opts: opts,
    );

    return result['code'];
  }

  Future<int> createReport({
    @required String token,
    @required Map<String, String> opts,
    @required Report report,
  }) async {
    final url = reportUrl;
    final body = <String, dynamic>{
      ...report.toJson(),
    };

    final result = await _baseApi.post(
      url,
      body,
      token,
      opts: opts,
    );

    return result['code'];
  }

  Future<int> deleteReport({
    @required String token,
    @required int id,
  }) async {
    final url = reportUrl + '/' + id.toString();

    final result = await _baseApi.delete(url, token);

    return result['code'];
  }
}
