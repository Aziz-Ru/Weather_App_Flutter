import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/widget/custom_text_widget.dart';

class CurrentTemperature extends StatelessWidget {
  final String temperature, curWeather, curCity;
  final IconData iconData;
  const CurrentTemperature(
      {super.key,
      required this.temperature,
      required this.curWeather,
      required this.curCity,
      required this.iconData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 15,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        // color: Colors.blueGrey[900],
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Column(
                children: [
                  CustomText(
                    text: '$temperature °C',
                    ftSize: 32,
                    ftWeight: FontWeight.bold,
                  ),
                  Icon(iconData,
                      // color: Colors.white,
                      size: 50),
                  CustomText(
                    text: curWeather,
                    ftSize: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on),
                      const SizedBox(
                        width: 10,
                      ),
                      CustomText(text: curCity, ftSize: 18),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
