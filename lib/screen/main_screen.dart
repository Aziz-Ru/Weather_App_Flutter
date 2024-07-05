import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
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
  final WeatherFactory _wf = WeatherFactory('');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {});
                },
                icon: const Icon(Icons.refresh))
          ],
          title: const CustomText(text: 'Weather App', ftSize: 24),
          centerTitle: true,
        ),
        body: FutureBuilder(
            future: _getWeather(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else if (snapshot.connectionState == ConnectionState.done) {
                List<Weather>? w = snapshot.data;
                return _buildUi(w!);
              } else {
                return const Center(child: Text('Error'));
              }
            }));
  }

  Widget _buildUi(List<Weather> weather) {
    final curTemp = weather[0].temperature?.celsius?.toStringAsFixed(2) ?? '';
    final curWeather = weather[0].weatherMain ?? '';
    final curCity = weather[0].areaName ?? '';
    IconData iconData = _getIcon(curWeather);

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
            iconData: iconData,
          ),
          const SizedBox(height: 10),
          _titleWidget('Additional Info'),
          const SizedBox(height: 8),
          _additionalinfowidgets(weather),
          const SizedBox(height: 4),
          _titleWidget('Forcast'),
          const SizedBox(height: 6),
          _forcastWidget(weather)
        ],
      ),
    );
  }

  Widget _additionalinfowidgets(List<Weather> weather) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AdditionalInfoCard(
              icon: Icons.water_drop,
              title: 'Humidity',
              value: weather[0].humidity.toString()),
          AdditionalInfoCard(
              icon: Icons.air,
              title: 'Wind',
              value: weather[0].windSpeed.toString()),
          AdditionalInfoCard(
              icon: Icons.thermostat,
              title: 'Pressure',
              value: weather[0].pressure.toString())
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

  Widget _forcastWidget(List<Weather> weather) {
    return Container(
      height: 160,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: weather.length,
          itemBuilder: (context, index) {
            final forcast = weather[index];
            final temp = forcast.temperature?.celsius?.toStringAsFixed(2) ?? '';
            final time = DateFormat('h a').format(forcast.date!);
            final weatherMain = forcast.weatherMain ?? '';
            final forcastDate = DateFormat('EEE, d MMM').format(forcast.date!);
            IconData iconData = _getIcon(weatherMain);
            return ForcastCard(
                temperature: temp,
                time: time,
                curDate: forcastDate,
                weatherIcon: iconData);
          }),
    );
  }

  Future<LocationData> _getLocation() async {
    Location location = Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return Future.error('Location service is disabled');
      }
    }
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return Future.error('Location permission is denied');
      }
    }
    // print(permissionStatus);
    return await location.getLocation();
  }

  Future<List<Weather>> _getWeather() async {
    try {
      LocationData locationData = await _getLocation();
      // print(locationData);
      List<Weather> current = await _wf.fiveDayForecastByLocation(
          locationData.latitude as double, locationData.longitude as double);
      // print(current);
      return current;
    } catch (e) {
      rethrow;
    }
  }

  IconData _getIcon(String weather) {
    if (weather.toLowerCase().contains('rain')) {
      return Icons.cloud;
    } else if (weather.toLowerCase().contains('cloud')) {
      return Icons.cloud_outlined;
    }
    return Icons.sunny;
  }
}
