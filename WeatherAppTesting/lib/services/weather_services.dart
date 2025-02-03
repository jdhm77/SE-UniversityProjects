import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = 'API KEY GOES HERE';
  final String baseUrl = 'url';

  Future<Map<String, dynamic>> fetchWeather(String cityName) async {
    final url = '$baseUrl/weather?q=$cityName&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));
    print('Fetch Weather URL: $url'); // Debugging line
    print('Fetch Weather Response: ${response.body}'); // Debugging line

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Map<String, dynamic>> fetchWeatherByCoords(double lat, double lon) async {
    final url = '$baseUrl/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));
    print('Fetch Weather By Coords URL: $url'); // Debugging line
    print('Fetch Weather By Coords Response: ${response.body}'); // Debugging line

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Map<String, dynamic>> fetchForecast(String cityName) async {
    final url = '$baseUrl/forecast?q=$cityName&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));
    print('Fetch Forecast URL: $url'); // Debugging line
    print('Fetch Forecast Response: ${response.body}'); // Debugging line

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load forecast data');
    }
  }
}
