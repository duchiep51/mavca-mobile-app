import 'dart:async';

import 'package:meta/meta.dart';

import 'package:capstone_mobile/src/data/repositories/repositories.dart';
import 'package:capstone_mobile/src/data/models/models.dart';

class WeatherRepository {
  final WeatherApiClient weatherApiClient;

  WeatherRepository({@required this.weatherApiClient})
      : assert(weatherApiClient != null);

  Future<Weather> getWeather(String city) async {
    final int locationId = await weatherApiClient.getLocationId(city);
    return weatherApiClient.fetchWeather(locationId);
  }
}
