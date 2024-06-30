import 'package:flutter/material.dart';
import 'package:weather_app/widget/custom_text_widget.dart';

class AdditionalInfoCard extends StatelessWidget {
  final IconData icon;
  final String title, value;
  const AdditionalInfoCard(
      {super.key,
      required this.icon,
      required this.title,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 15,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
            ),
            const SizedBox(
              height: 5,
            ),
            CustomText(text: title, ftSize: 18),
            const SizedBox(
              height: 5,
            ),
            CustomText(text: value, ftSize: 18),
          ],
        ),
      ),
    );
  }
}
