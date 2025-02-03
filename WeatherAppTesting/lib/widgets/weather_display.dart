import 'package:flutter/material.dart';

class WeatherDisplay extends StatelessWidget {
  final int currTemp;
  final String weatherDescription;
  final int minTemp;
  final int maxTemp;
  final Size size;
  final bool isDarkMode;

  const WeatherDisplay({
    Key? key,
    required this.currTemp,
    required this.weatherDescription,
    required this.minTemp,
    required this.maxTemp,
    required this.size,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: size.height * 0.03,
          ),
          child: Align(
            child: Text(
              '$currTemp˚C',
              style: TextStyle(
                fontFamily: 'Kanit',
                color: Colors.white,
                fontSize: size.height * 0.13,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.25),
          child: Divider(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: size.height * 0.005,
          ),
          child: Align(
            child: Text(
              weatherDescription,
              style: TextStyle(
                fontFamily: 'Kanit',
                color: isDarkMode ? Colors.white54 : Colors.black54,
                fontSize: size.height * 0.03,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: size.height * 0.03,
            bottom: size.height * 0.01,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$minTemp˚C',
                style: TextStyle(
                  fontFamily: 'Kanit',
                  color: Colors.white,
                  fontSize: size.height * 0.03,
                ),
              ),
              Text(
                '/',
                style: TextStyle(
                  fontFamily: 'Kanit',
                  color: isDarkMode ? Colors.white54 : Colors.black54,
                  fontSize: size.height * 0.03,
                ),
              ),
              Text(
                '$maxTemp˚C',
                style: TextStyle(
                  fontFamily: 'Kanit',
                  color: Colors.white,
                  fontSize: size.height * 0.03,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
