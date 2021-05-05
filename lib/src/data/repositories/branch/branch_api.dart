import 'package:capstone_mobile/Api/BaseApi.dart';
import 'package:capstone_mobile/src/data/models/branch/branch.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

class BranchApi {
  final http.Client httpClient;
  BaseApi _baseApi = BaseApi();
  final branchUrl = 'branches';

  BranchApi({@required this.httpClient});

  Future<List<Branch>> getBranches({
    @required String token,
    Map<String, String> opts,
  }) async {
    final url = '$branchUrl?Filter.IsDeleted=false';
    final userJson = await _baseApi.get(url, token, opts: opts);
    final branches = userJson['data']['result'] as List;
    return branches.map((branch) => Branch.fromJson(branch)).toList();
  }

  Future<List<Branch>> getBranchesForQC({
    @required String token,
    Map<String, String> opts,
  }) async {
    final url = '$branchUrl/monthly-branches';
    final userJson = await _baseApi.get(url, token, opts: opts);
    final branches = userJson['data']['result'] as List;
    return branches.map((branch) => Branch.fromJson(branch)).toList();
  }
}
