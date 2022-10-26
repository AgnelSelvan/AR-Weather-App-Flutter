import 'dart:convert';

import 'package:ar_weather_app/models/weather.dart';
import 'package:http/http.dart';

class WeatherService {
  final baseUrl = "http://api.weatherapi.com/v1";

  final _token = "f538ff80adf64322bde141852222708";

  Future<CurrentWeather> getCurrentWeather(String search) async {
    final url = "$baseUrl/current.json?key=$_token&q=$search";
    final response = await get(Uri.parse(url));
    final resposeJson = jsonDecode(response.body);
    return CurrentWeather.fromJson(resposeJson);
  }
}
