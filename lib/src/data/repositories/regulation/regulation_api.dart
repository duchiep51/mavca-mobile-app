import 'package:capstone_mobile/Api/BaseApi.dart';
import 'package:capstone_mobile/src/data/models/regulation/regulation.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

class RegulationApi {
  final http.Client httpClient;
  BaseApi _baseApi = BaseApi();

  RegulationApi({@required this.httpClient});

  Future<List<Regulation>> getRegulations({
    @required String token,
    Map<String, String> opts,
  }) async {
    final regulationUrl = 'regulations?Filter.IsDeleted=false';
    final userJson = await _baseApi.get(
      regulationUrl,
      token,
      opts: opts,
    );
    final regulations = userJson['data']['result'] as List;
    return regulations
        .map((regulation) => Regulation.fromJson(regulation))
        .toList();
  }
}
