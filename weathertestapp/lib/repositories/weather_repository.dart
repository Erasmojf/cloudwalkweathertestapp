import 'package:weathertestapp/models/entities/weather_entity.dart';
import 'package:weathertestapp/models/network_state.dart';

abstract class WeatherRepository {
  Future<NetworkState> findByCityName(String cityName);
  Future<bool> findByPredicate(bool Function(WeatherEntity entity) predicate);
  Future<NetworkState> loadData();
  Future saveData(WeatherEntity entity);
}
