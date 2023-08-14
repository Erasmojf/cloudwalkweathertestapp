import 'package:weathertestapp/models/entities/weather_entity.dart';

class WeatherItemDto {
  final String cityName;
  final String countryName;
  final double temperatury;
  final List<WeatherDto> weathers;

  WeatherItemDto({
    required this.cityName,
    required this.countryName,
    required this.temperatury,
    required this.weathers,
  });

  factory WeatherItemDto.fromEntity(WeatherEntity entity) {
    return WeatherItemDto(
      cityName: entity.name ?? '',
      countryName: entity.sys?.country ?? '',
      temperatury: entity.main?.temp ?? 0.0,
      weathers: entity.weather != null
          ? entity.weather!
              .map((e) => WeatherDto(
                    main: e.main ?? '',
                    description: e.description ?? '',
                    icon: e.icon ?? '',
                  ))
              .toList()
          : [],
    );
  }
}

class WeatherDto {
  final String main;
  final String description;
  final String icon;

  WeatherDto({
    required this.main,
    required this.description,
    required this.icon,
  });
}
