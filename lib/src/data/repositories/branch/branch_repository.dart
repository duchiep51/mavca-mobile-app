import 'dart:async';

import 'package:capstone_mobile/src/data/models/branch/branch.dart';
import 'package:capstone_mobile/src/data/repositories/branch/branch_api.dart';
import 'package:http/http.dart' as http;

class BranchRepository {
  BranchApi _branchApi = BranchApi(httpClient: http.Client());

  BranchRepository();

  Future<List<Branch>> fetchBranches(String token) async {
    return await _branchApi.getBranches(
      token: token,
    );
  }

  Future<List<Branch>> fetchBranchesForQC(String token) async {
    return await _branchApi.getBranchesForQC(token: token);
  }
}
