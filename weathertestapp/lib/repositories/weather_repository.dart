import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weathertestapp/models/network_state.dart';

abstract class WeatherService {
  Future findByCityName(String cityName);
}

class WeatherServiceImpl implements WeatherService {
  final http.Client _client;
  late Uri _uri;
  final String tokenApi;

  WeatherServiceImpl({
    required client,
    required this.tokenApi,
    required Uri baseUri,
  }) : _client = client {
    _uri = baseUri;
  }

  @override
  Future findByCityName(String cityName) async {
    final queryParameters = {
      'q': cityName,
    };

    final response = await _client.get(buildUri(queryParameters));

    if (response.statusCode == 200) {
      return SuccessNetworkState(jsonDecode(response.body));
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
}
