import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:weathertestapp/models/network_state.dart';
import 'package:weathertestapp/repositories/weather_repository.dart';
import 'package:weathertestapp/repositories/weather_repository_impl.dart';

import 'weather_repository_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late WeatherRepository service;
  final clientMock = MockClient();

  setUp(() async {
    service = WeatherRepositoryImpl(
        client: clientMock,
        baseUri: Uri.parse('http://localhost/weather'),
        tokenApi: 'abc');
  });

  tearDown(() async {});

  test('Should return sucess when findByCityName called', () async {
    const cityName = 'São Paulo';

    when(clientMock.get(
            Uri.parse('http://localhost/weather?q=S%C3%A3o+Paulo&appid=abc')))
        .thenAnswer((_) async => http.Response('{"name": "zocca"}', 200));

    final result =
        (await service.findByCityName(cityName)) as SuccessNetworkState;

    expect(result.data['name'], 'zocca');
  });

  test('Should return fail when findByCityName called', () async {
    const cityName = 'São Paulo';

    when(clientMock.get(
            Uri.parse('http://localhost/weather?q=S%C3%A3o+Paulo&appid=abc')))
        .thenAnswer((_) async => http.Response('not found', 404));

    final result =
        (await service.findByCityName(cityName)) as FailureNetworkState;

    expect(result.message, 'not found');
    expect(result.statusCode, 404);
  });
}
