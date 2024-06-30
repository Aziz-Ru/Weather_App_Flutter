import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
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
  final WeatherFactory _wf = WeatherFactory('');
  List<Weather>? _weather;

  Future<Position> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission;
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission is denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permission is denied forever');
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    _getLocation().then((position) {
      setState(() {
        _wf
            .fiveDayForecastByLocation(position.latitude, position.longitude)
            .then((w) {
          setState(() {
            _weather = w;
          });
        });
      });
    });

    // List<Weather> forecast = await wf.fiveDayForecastByCityName(cityName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  _getLocation().then((position) {
                    setState(() {
                      _wf
                          .fiveDayForecastByLocation(
                              position.latitude, position.longitude)
                          .then((w) {
                        setState(() {
                          _weather = w;
                        });
                      });
                    });
                  });
                },
                icon: Icon(Icons.refresh))
          ],
          title: const CustomText(text: 'Weather App', ftSize: 24),
          centerTitle: true,
        ),
        body: _buildUi());
  }

  Widget _buildUi() {
    if (_weather == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    final curTemp = _weather![0].temperature?.celsius?.toStringAsFixed(2) ?? '';
    final curWeather = _weather![0].weatherMain ?? '';
    final curCity = _weather![0].areaName ?? '';

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Column(
        children: [
          CurrentTemperature(
            temperature: curTemp,
            curWeather: curWeather,
            curCity: curCity,
          ),
          const SizedBox(height: 10),
          _titleWidget('Additional Info'),
          const SizedBox(height: 8),
          _additionalinfowidgets(),
          const SizedBox(height: 4),
          _titleWidget('Forcast'),
          const SizedBox(height: 6),
          _forcastWidget()
        ],
      ),
    );
  }

  Widget _additionalinfowidgets() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AdditionalInfoCard(
              icon: Icons.water_drop,
              title: 'Humidity',
              value: _weather![0].humidity.toString()),
          AdditionalInfoCard(
              icon: Icons.air,
              title: 'Wind',
              value: _weather![0].windSpeed.toString()),
          AdditionalInfoCard(
              icon: Icons.thermostat,
              title: 'Pressure',
              value: _weather![0].pressure.toString())
        ],
      ),
    );
  }

  Widget _titleWidget(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: CustomText(
        text: title,
        ftSize: 22,
        ftWeight: FontWeight.w500,
      ),
    );
  }

  Widget _forcastWidget() {
    return SizedBox(
      height: 150,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _weather?.length,
          itemBuilder: (context, index) {
            final forcast = _weather![index];
            final weather = forcast.weatherMain;
            final temp = forcast.temperature?.celsius?.toStringAsFixed(2) ?? '';
            final time = DateFormat('h a').format(forcast.date!);
            final forcastDate = DateFormat('EEE, d MMM').format(forcast.date!);

            return ForcastCard(
                temperature: temp,
                time: time,
                curDate: forcastDate,
                weatherIcon: weather == 'Clouds' || weather == 'Rain'
                    ? Icons.cloud
                    : Icons.wb_sunny);
          }),
    );
  }
}
