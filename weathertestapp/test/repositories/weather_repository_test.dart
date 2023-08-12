import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weathertestapp/models/networh_state.dart';
import 'package:weathertestapp/repositories/weather_repository.dart';

@GenerateMocks([http.Client])
void main() {
  late WeatherService service;
  final clientMock = MockClient();

  setUp(() async {
    service = WeatherServiceImpl(
        client: clientMock,
        baseUri: Uri.parse('http://localhost/weather'),
        tokenApi: 'abc');
  });

  tearDown(() async {});

  test('Should return sucess when findByCityName called', () async {
    final cityName = 'São Paulo';

    when(clientMock.get(
            Uri.parse('http://localhost/weather?q=S%C3%A3o+Paulo&appid=abc')))
        .thenAnswer((_) async => http.Response('{"name": "zocca"}', 200));

    final SuccessNetworkState result = await service.findByCityName(cityName);

    expect(result.data['name'], 'zocca');
  });

  test('Should return fail when findByCityName called', () async {
    final cityName = 'São Paulo';

    when(clientMock.get(
            Uri.parse('http://localhost/weather?q=S%C3%A3o+Paulo&appid=abc')))
        .thenAnswer((_) async => http.Response('not found', 404));

    final FailureNetworkState result = await service.findByCityName(cityName);

    expect(result.message, 'not found');
    expect(result.statusCode, 404);
  });
}
