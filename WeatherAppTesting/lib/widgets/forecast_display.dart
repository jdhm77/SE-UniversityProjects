import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ForecastDisplay extends StatelessWidget {
  final List<dynamic> hourlyForecast;
  final List<dynamic> weeklyForecast;
  final Size size;
  final bool isDarkMode;

  const ForecastDisplay({
    Key? key,
    required this.hourlyForecast,
    required this.weeklyForecast,
    required this.size,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
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
                    padding: EdgeInsets.only(top: size.height * 0.01, left: size.width * 0.03),
                    child: Text(
                      'Forecast for today',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: size.height * 0.025,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(size.width * 0.005),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: hourlyForecast.map((hourData) {
                        String time = hourData['dt_txt'].substring(11, 16);
                        int temp = hourData['main']['temp'].toInt();
                        int wind = hourData['wind']['speed'].toInt();
                        int rainChance = (hourData['pop'] * 100).toInt();
                        IconData weatherIcon = getWeatherIcon(hourData['weather'][0]['main']);

                        return buildForecastToday(time, temp, wind, rainChance, weatherIcon, size, isDarkMode);
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
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
      ],
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

  Widget buildForecastToday(String time, int temp, int wind, int rainChance,
      IconData weatherIcon, Size size, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.all(size.width * 0.025),
      child: Column(
        children: [
          Text(
            time,
            style: TextStyle(
              fontFamily: 'Kanit',
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: size.height * 0.02,
            ),
          ),
          FaIcon(
            weatherIcon,
            color: isDarkMode ? Colors.white : Colors.black,
            size: size.height * 0.03,
          ),
          Text(
            '$temp°C',
            style: TextStyle(
              fontFamily: 'Kanit',
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: size.height * 0.025,
            ),
          ),
          FaIcon(
            FontAwesomeIcons.wind,
            color: Colors.grey,
            size: size.height * 0.03,
          ),
          Text(
            '$wind km/h',
            style: TextStyle(
              fontFamily: 'Kanit',
              color: Colors.grey,
              fontSize: size.height * 0.02,
            ),
          ),
          FaIcon(
            FontAwesomeIcons.umbrella,
            color: Colors.blue,
            size: size.height * 0.03,
          ),
          Text(
            '$rainChance %',
            style: TextStyle(
              fontFamily: 'Kanit',
              color: Colors.blue,
              fontSize: size.height * 0.02,
            ),
          ),
        ],
      ),
    );
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
