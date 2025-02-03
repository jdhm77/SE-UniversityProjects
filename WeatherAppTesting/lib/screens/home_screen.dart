import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/weather_services.dart';
import '../widgets/weather_display.dart';
import '../widgets/forecast_display.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  String cityName = "Berlin";
  int currTemp = 0;
  int maxTemp = 0;
  int minTemp = 0;
  String weatherDescription = "";
  List<dynamic> hourlyForecast = [];
  List<dynamic> weeklyForecast = [];
  List<String> addedCities = [];
  bool isLoading = true;
  String errorMessage = "";
  String localTime = ""; // Nueva variable para almacenar la hora local

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        errorMessage = "Location services are disabled.";
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          errorMessage = "Location permissions are denied.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        errorMessage = "Location permissions are permanently denied.";
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    await _fetchWeatherData(position.latitude, position.longitude);
  }

  Future<void> _fetchWeatherData([double? lat, double? lon]) async {
    try {
      final weatherData = lat != null && lon != null
          ? await _weatherService.fetchWeatherByCoords(lat, lon)
          : await _weatherService.fetchWeather(cityName);
      final forecastData = await _weatherService.fetchForecast(cityName);

      print('Weather Data: $weatherData'); // Debugging line
      print('Forecast Data: $forecastData'); // Debugging line

      // Obtener la hora local
      final timezoneOffset = weatherData['timezone'];
      final currentTime = DateTime.now().toUtc().add(Duration(seconds: timezoneOffset));
      final localHour = DateFormat.H().format(currentTime);

      print('Local Hour: $localHour'); // Debugging line

      setState(() {
        currTemp = weatherData['main']['temp'].toInt();
        maxTemp = weatherData['main']['temp_max'].toInt();
        minTemp = weatherData['main']['temp_min'].toInt();
        weatherDescription = weatherData['weather'][0]['description'];
        hourlyForecast = forecastData['list'].take(8).toList();

        // Procesar y almacenar el pronóstico semanal
        Map<String, Map<String, dynamic>> dailyTemps = {};

        for (var entry in forecastData['list']) {
          String date = entry['dt_txt'].substring(0, 10);
          int tempMin = entry['main']['temp_min'].toInt();
          int tempMax = entry['main']['temp_max'].toInt();
          String weather = entry['weather'][0]['main'];

          if (!dailyTemps.containsKey(date)) {
            dailyTemps[date] = {
              'temp_min': tempMin,
              'temp_max': tempMax,
              'weather': weather,
            };
          } else {
            if (tempMin < dailyTemps[date]!['temp_min']) {
              dailyTemps[date]!['temp_min'] = tempMin;
            }
            if (tempMax > dailyTemps[date]!['temp_max']) {
              dailyTemps[date]!['temp_max'] = tempMax;
            }
          }
        }

        weeklyForecast = dailyTemps.entries.map((entry) {
          return {
            'date': entry.key,
            'temp_min': entry.value['temp_min'],
            'temp_max': entry.value['temp_max'],
            'weather': entry.value['weather'],
          };
        }).toList();

        localTime = localHour; // Almacenar la hora local

        isLoading = false;
        errorMessage = ""; // Clear any previous error message
      });
    } catch (e) {
      print("Error fetching weather data: $e");
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  String _getBackgroundImage() {
    try {
      int hour = int.parse(localTime);

      if (hour >= 18 || hour < 6) { // De 6 PM a 6 AM es noche
        return 'assets/animations/night.gif';
      } else if (weatherDescription.contains('rain')) {
        return 'assets/animations/rainy.gif';
      } else if (weatherDescription.contains('clear')) {
        return 'assets/animations/sunny.gif';
      } else if (weatherDescription.contains('snow')) {
        return 'assets/animations/snow.gif';
      } else if (weatherDescription.contains('thunderstorm')) {
        return 'assets/animations/thunderstorm.gif';
      } else if (weatherDescription.contains('clouds')) {
        return 'assets/animations/cloudy.gif';
      } else {
        return 'assets/animations/sunny.gif'; // default to sunny if no match
      }
    } catch (e) {
      print("Error parsing local time: $e");
      return 'assets/animations/sunny.gif'; // default to sunny if parsing fails
    }
  }

  void _navigateToAddCity() async {
    final result = await Navigator.pushNamed(context, '/addCity');

    if (result != null && result is String) {
      setState(() {
        cityName = result;
        addedCities.add(result);
        isLoading = true;
      });
      _fetchWeatherData();
    }
  }

  void _changeCity(String city) {
    setState(() {
      cityName = city;
      isLoading = true;
    });
    _fetchWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.black : Colors.white,
              ),
              child: Text(
                'Added Cities',
                style: TextStyle(
                  fontFamily: 'Kanit',
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: size.height * 0.03,
                ),
              ),
            ),
            ...addedCities.map((city) => ListTile(
              title: Text(city),
              onTap: () {
                Navigator.pop(context);
                _changeCity(city);
              },
            )),
          ],
        ),
      ),
      body: Center(
        child: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black : Colors.white,
            image: DecorationImage(
              image: AssetImage(_getBackgroundImage()),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.01,
                          horizontal: size.width * 0.05,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Builder(
                              builder: (context) {
                                return IconButton(
                                  icon: FaIcon(
                                    FontAwesomeIcons.bars,
                                    color: isDarkMode ? Colors.white : Colors.black,
                                  ),
                                  onPressed: () => Scaffold.of(context).openDrawer(),
                                );
                              },
                            ),
                            Align(
                              child: Text(
                                'Weather App',
                                style: TextStyle(
                                  fontFamily: 'Kanit',
                                  color: isDarkMode ? Colors.white : const Color(0xff1D1617),
                                  fontSize: size.height * 0.02,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: FaIcon(
                                FontAwesomeIcons.circlePlus,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                              onPressed: _navigateToAddCity,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.height * 0.03,
                        ),
                        child: Align(
                          child: Text(
                            cityName,
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: size.height * 0.06,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.height * 0.005,
                        ),
                        child: Align(
                          child: Text(
                            'Today',
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              color: isDarkMode ? Colors.white54 : Colors.black54,
                              fontSize: size.height * 0.035,
                            ),
                          ),
                        ),
                      ),
                      if (errorMessage.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.all(size.width * 0.05),
                          child: Text(
                            errorMessage,
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              color: Colors.red,
                              fontSize: size.height * 0.025,
                            ),
                          ),
                        ),
                      if (errorMessage.isEmpty)
                        Column(
                          children: [
                            WeatherDisplay(
                              currTemp: currTemp,
                              weatherDescription: weatherDescription,
                              minTemp: minTemp,
                              maxTemp: maxTemp,
                              size: size,
                              isDarkMode: isDarkMode,
                            ),
                            ForecastDisplay(
                              hourlyForecast: hourlyForecast,
                              weeklyForecast: weeklyForecast,
                              size: size,
                              isDarkMode: isDarkMode,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
