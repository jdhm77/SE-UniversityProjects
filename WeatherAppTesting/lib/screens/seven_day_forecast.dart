import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SevenDayForecastScreen extends StatelessWidget {
  final List<dynamic> weeklyForecast;
  final bool isDarkMode;

  const SevenDayForecastScreen({
    Key? key,
    required this.weeklyForecast,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('7-day Forecast'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: size.height * 0.02),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: size.height * 0.02, left: size.width * 0.03),
                  child: Text(
                    '7-day forecast',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: size.height * 0.025,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Divider(color: isDarkMode ? Colors.white : Colors.black),
              Padding(
                padding: EdgeInsets.all(size.width * 0.005),
                child: Column(
                  children: weeklyForecast.map((dayData) {
                    String date = dayData['date'];
                    int minTemp = dayData['temp_min'];
                    int maxTemp = dayData['temp_max'];
                    IconData weatherIcon = getWeatherIcon(dayData['weather']);

                    return buildSevenDayForecast(date, minTemp, maxTemp, weatherIcon, size, isDarkMode);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData getWeatherIcon(String description) {
    switch (description) {
      case 'Clear':
        return FontAwesomeIcons.sun;
      case 'Clouds':
        return FontAwesomeIcons.cloud;
      case 'Rain':
        return FontAwesomeIcons.cloudRain;
      case 'Snow':
        return FontAwesomeIcons.snowflake;
      default:
        return FontAwesomeIcons.sun;
    }
  }

  Widget buildSevenDayForecast(String date, int minTemp, int maxTemp,
      IconData weatherIcon, Size size, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.all(size.height * 0.005),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: TextStyle(
                  fontFamily: 'Kanit',
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: size.height * 0.025,
                ),
              ),
              FaIcon(
                weatherIcon,
                color: isDarkMode ? Colors.white : Colors.black,
                size: size.height * 0.03,
              ),
              Text(
                '$minTemp°C / $maxTemp°C',
                style: TextStyle(
                  fontFamily: 'Kanit',
                  color: isDarkMode ? Colors.white38 : Colors.black38,
                  fontSize: size.height * 0.025,
                ),
              ),
            ],
          ),
          Divider(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ],
      ),
    );
  }
}
