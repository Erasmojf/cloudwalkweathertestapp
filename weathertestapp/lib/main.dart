import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weathertestapp/repositories/weather_repository_impl.dart';
import 'package:weathertestapp/repositories/weather_repository_offline.dart';
import 'package:weathertestapp/views/weather_list/weather_list_page.dart';
import 'package:weathertestapp/views/weather_list/weather_list_view_model.dart';

void main() async {
  final weatherRepository = WeatherRepositoryImpl(
      client: http.Client(),
      baseUri: Uri.parse('https://api.openweathermap.org/data/2.5/weather'),
      tokenApi: '0753f3d5a6ff7f00c26f690212e595c5');
  final weatherRepositoryOffline =
      WeatherRepositoryOffline(await SharedPreferences.getInstance());
  // final response = await weatherRepository.findByCityName('São Paulo');
  // if (response is SuccessNetworkState) {
  //   print(response.message);
  // } else if(response is FailureNetworkState) {
  //   print(response.message);
  // }

  final weatherListViewModel = WeatherListViewModel(
    weatherRepository: weatherRepository,
    weatherRepositoryOffline: weatherRepositoryOffline,
  );

  // weatherListViewModel.addListener(() {
  //   if (kDebugMode) {
  //     print('weatherListViewModel emit');
  //     print(weatherListViewModel.value);
  //   }
  // });

  // weatherListViewModel.searchByCityName('jose');

  runApp(WeatherApp(
    viewModel: weatherListViewModel,
  ));
}

class WeatherApp extends StatelessWidget {
  final WeatherListViewModel viewModel;

  const WeatherApp({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherListPage(
        viewModel: viewModel,
      ),
    );
  }
}
