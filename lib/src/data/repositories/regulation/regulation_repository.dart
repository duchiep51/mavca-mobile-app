import 'dart:async';

import 'package:capstone_mobile/src/data/models/regulation/regulation.dart';
import 'package:capstone_mobile/src/data/repositories/regulation/regulation_api.dart';
import 'package:http/http.dart' as http;

class RegulationRepository {
  List<Regulation> _regulations;
  RegulationApi _regulationApi = RegulationApi(httpClient: http.Client());

  RegulationRepository();

  Future<List<Regulation>> fetchRegulationes(String token) async {
    return _regulations = _regulations != null
        ? _regulations
        : await _regulationApi.getRegulations(
            token: token,
          );
  }
}
