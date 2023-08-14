import 'package:flutter/material.dart';
import 'package:weathertestapp/models/app_state.dart';
import 'package:weathertestapp/models/dtos/weather_dto.dart';
import 'package:weathertestapp/models/entities/weather_entity.dart';
import 'package:weathertestapp/models/network_state.dart';
import 'package:weathertestapp/repositories/weather_repository.dart';

class WeatherListViewModel extends ValueNotifier<AppState> {
  final WeatherRepository _weatherRepository;
  final WeatherRepository _weatherRepositoryOffline;

  WeatherListViewModel({
    required WeatherRepository weatherRepository,
    required WeatherRepository weatherRepositoryOffline,
  })  : _weatherRepository = weatherRepository,
        _weatherRepositoryOffline = weatherRepositoryOffline,
        super(InitAppState());

  searchByCityName(String cityName, {bool isOffline = false}) async {
    if (isOffline) {
      final entityOffline = (await _weatherRepositoryOffline
          .findByCityName(cityName)) as SuccessNetworkState<WeatherEntity?>;

      if (entityOffline.data?.name != null) {
        await loadData();
        return;
      }
    }

    final response = await _weatherRepository.findByCityName(cityName);

    if (response is SuccessNetworkState) {
      final cityNetwork = (response as SuccessNetworkState<WeatherEntity>).data;
      final offlineHasCity = await _weatherRepositoryOffline
          .findByPredicate((entity) => entity.id == cityNetwork.id);

      if (offlineHasCity) {
        return;
      }
      await _weatherRepositoryOffline.saveData(cityNetwork);

      await loadData();
    } else if (response is FailureNetworkState) {
      value = FailureAppState(response.message);
    }
  }

  Future loadData() async {
    final results = (await _weatherRepositoryOffline.loadData())
        as SuccessNetworkState<List<WeatherEntity>>;

    final resultsToView =
        results.data.map((e) => WeatherItemDto.fromEntity(e)).toList();

    value = SuccessAppState(resultsToView);
  }
}
