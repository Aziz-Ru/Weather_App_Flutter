import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double ftSize;
  final FontWeight ftWeight;
  const CustomText(
      {super.key,
      required this.text,
      required this.ftSize,
       this.ftWeight=FontWeight.normal});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: ftSize,
        fontWeight: ftWeight,
      ),
    );
  }
}
