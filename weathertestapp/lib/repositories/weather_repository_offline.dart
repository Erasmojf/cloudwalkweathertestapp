import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weathertestapp/models/entities/weather_entity.dart';
import 'package:weathertestapp/models/network_state.dart';
import 'package:weathertestapp/repositories/weather_repository.dart';

class WeatherRepositoryOffline implements WeatherRepository {
  final SharedPreferences sharedPreferences;

  WeatherRepositoryOffline(this.sharedPreferences);

  @override
  Future<NetworkState> findByCityName(String cityName) async {
    final results =
        (await loadData()) as SuccessNetworkState<List<WeatherEntity>?>;

    if (results == null) {
      return SuccessNetworkState(WeatherEntity());
    }

    final cityFounded = results.data?.firstWhere(
        (element) =>
            element.name?.toLowerCase().contains(cityName.toLowerCase()) ??
            false,
        orElse: () => WeatherEntity());

    return SuccessNetworkState(cityFounded);
  }

  @override
  Future<NetworkState> loadData() async {
    final results = sharedPreferences.getStringList('weathers');
    if (results != null) {
      final weathers =
          results.map((e) => WeatherEntity.fromJson(jsonDecode(e))).toList();

      return SuccessNetworkState(weathers);
    }

    return SuccessNetworkState(<WeatherEntity>[]);
  }

  @override
  Future saveData(WeatherEntity entity) async {
    final results = sharedPreferences.getStringList('weathers');
    if (results != null) {
      results.add(jsonEncode(entity.toJson()));
      return await sharedPreferences.setStringList('weathers', results);
    } else {
      return await sharedPreferences
          .setStringList('weathers', [jsonEncode(entity.toJson())]);
    }
  }

  @override
  Future<bool> findByPredicate(
      bool Function(WeatherEntity entity) predicate) async {
    final results =
        (await loadData()) as SuccessNetworkState<List<WeatherEntity>?>;

    if (results.data?.isEmpty ?? false) {
      return false;
    }

    final cityFounded = results.data?.contains((element) => predicate(element));

    return cityFounded ?? false;
  }
}
