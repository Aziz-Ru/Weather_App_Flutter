import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/widget/additional_info_card.dart';
import 'package:weather_app/widget/curren_temp_widget.dart';
import 'package:weather_app/widget/custom_text_widget.dart';
import 'package:weather_app/widget/forecast_card_widget.dart';

class MyWeatherApp extends StatefulWidget {
  const MyWeatherApp({super.key});

  @override
  State<MyWeatherApp> createState() => _MyWeatherAppState();
}

class _MyWeatherAppState extends State<MyWeatherApp> {
  // late Future<Map<String, dynamic>> weatherData;

  Future getCurrentWeather() async {
    try {
      final String url =
          'https://api.openweathermap.org/data/2.5/forecast?q=Rajshahi&units=metric&APPID=${dotenv.env['OPEN_WEATHER_API_KEY']}';
      final res = await http.get(Uri.parse(url));

      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An Unpected Error Occured';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   weatherData = getCurrentWeather();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [Icon(Icons.refresh)],
        title: const CustomText(text: 'Weather App', ftSize: 24),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: getCurrentWeather(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: CustomText(
                    text: snapshot.error.toString(),
                    ftSize: 20,
                    ftWeight: FontWeight.w500),
              );
            }
            final weather = snapshot.data;
            final curTemp = weather['list'][0]['main']['temp'].toString();
            final curWeather =
                weather['list'][0]['weather'][0]['main'].toString();
            final curCity = weather['city']['name'].toString();
            final curHumidity =
                weather['list'][0]['main']['humidity'].toString();
            final curWind = weather['list'][0]['wind']['speed'].toString();
            final curPressure =
                weather['list'][0]['main']['pressure'].toString();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Column(
                children: [
                  CurrentTemperature(
                      temperature: curTemp,
                      curWeather: curWeather,
                      curCity: curCity),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      text: 'Additional Info',
                      ftSize: 22,
                      ftWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AdditionalInfoCard(
                            icon: Icons.water_drop,
                            title: 'Humidity',
                            value: curHumidity),
                        AdditionalInfoCard(
                            icon: Icons.air, title: 'Wind', value: curWind),
                        AdditionalInfoCard(
                            icon: Icons.thermostat,
                            title: 'Pressure',
                            value: curPressure)
                      ],
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      text: 'Hourly Forcast',
                      ftSize: 22,
                      ftWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: weather['list'].length,
                        itemBuilder: (context, index) {
                          final forcast = weather['list'][index];
                          final weatherStatus =
                              forcast['weather'][0]['main'].toString();
                          final temp = forcast['main']['temp'].toString();
                          final time = DateTime.parse(forcast['dt_txt']);

                          return ForcastCard(
                              temperature: temp,
                              time: DateFormat.jm().format(time),
                              curDate: DateFormat.yMMMd().format(time),
                              weatherIcon: weatherStatus == 'Clouds' ||
                                      weatherStatus == 'Rain'
                                  ? Icons.cloud
                                  : Icons.wb_sunny);
                        }),
                  )
                ],
              ),
            );
          }),
    );
  }
}
