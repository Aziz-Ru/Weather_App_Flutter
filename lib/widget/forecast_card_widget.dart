import 'package:flutter/material.dart';
import 'package:weather_app/widget/custom_text_widget.dart';

class ForcastCard extends StatelessWidget {
  final String temperature, time, curDate;
  final IconData weatherIcon;
  const ForcastCard(
      {super.key,
      required this.temperature,
      required this.time,
      required this.curDate,
      required this.weatherIcon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 15,
      child: Container(
        width: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            CustomText(
              text: temperature,
              ftSize: 22,
              ftWeight: FontWeight.w500,
            ),
            // const SizedBox(height: 5),
            Icon(weatherIcon, size: 30),
            // const SizedBox(height: 5),
            CustomText(text: time, ftSize: 18, ftWeight: FontWeight.w400),
            const SizedBox(height: 5),
            CustomText(text: curDate, ftSize: 14, ftWeight: FontWeight.w400),
          ],
        ),
      ),
    );
  }
}
