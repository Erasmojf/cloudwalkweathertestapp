import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weathertestapp/models/entities/weather_entity.dart';
import 'package:weathertestapp/models/network_state.dart';
import 'package:weathertestapp/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final http.Client _client;
  late Uri _uri;
  final String tokenApi;

  WeatherRepositoryImpl({
    required client,
    required this.tokenApi,
    required Uri baseUri,
  }) : _client = client {
    _uri = baseUri;
  }

  @override
  Future<NetworkState> findByCityName(String cityName) async {
    final queryParameters = {
      'q': cityName,
    };

    final response = await _client.get(buildUri(queryParameters));

    if (response.statusCode == 200) {
      final entity = WeatherEntity.fromJson(jsonDecode(response.body));
      return SuccessNetworkState(entity);
    }

    return FailureNetworkState(response.body, response.statusCode);
  }

  Uri buildUri(Map<String, dynamic> queryParameters) {
    queryParameters.putIfAbsent('appid', () => tokenApi);

    return Uri(
        host: _uri.host,
        path: _uri.path,
        scheme: _uri.scheme,
        queryParameters: queryParameters);
  }

  @override
  Future<NetworkState> loadData() async {
    throw UnimplementedError();
  }

  @override
  Future saveData(WeatherEntity entity) async {
    throw UnimplementedError();
  }

  @override
  Future<bool> findByPredicate(Function(WeatherEntity entity) predicate) {
    throw UnimplementedError();
  }
}
