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
  final WeatherFactory _wf = WeatherFactory('77d63feee22bfb5e515e5c486adb1f3e');
  List<Weather>? _weather;

  Future<Position> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }
    // LocationPermission permission = await Geolocator.requestPermission();
    // print(permission);
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Location permission is denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Geolocator.openAppSettings();
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
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
    }).catchError((e) {
      setState(() {
        _wf.fiveDayForecastByCityName('Mountain View').then((w) {
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
                icon: const Icon(Icons.refresh))
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
    late IconData iconData;

    final curTemp = _weather![0].temperature?.celsius?.toStringAsFixed(2) ?? '';
    final curWeather = _weather![0].weatherMain ?? '';
    final weatherDesc = _weather![0].weatherDescription ?? '';
    final curCity = _weather![0].areaName ?? '';
    if (weatherDesc == 'overcast clouds') {
      iconData = Icons.thunderstorm_outlined;
    } else if (weatherDesc == 'clear sky') {
      iconData = Icons.sunny;
    } else if (weatherDesc == 'few clouds') {
      iconData = Icons.cloud_outlined;
    } else if (weatherDesc == 'scattered clouds') {
      iconData = Icons.cloud_outlined;
    } else if (weatherDesc == 'broken clouds') {
      iconData = Icons.cloud_outlined;
    } else if (weatherDesc == 'shower rain') {
      iconData = Icons.cloud;
    } else if (weatherDesc == 'rain') {
      iconData = Icons.thunderstorm;
    } else if (weatherDesc == 'thunderstorm') {
      iconData = Icons.thunderstorm;
    } else if (weatherDesc == 'snow') {
      iconData = Icons.sunny_snowing;
    } else if (weatherDesc == 'mist') {
      iconData = Icons.sunny_snowing;
    }

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
            final weatherDesc = forcast.weatherDescription ?? '';
            late IconData iconData;
            final forcastDate = DateFormat('EEE, d MMM').format(forcast.date!);
            if (weatherDesc == 'overcast clouds') {
              iconData = Icons.thunderstorm_outlined;
            } else if (weatherDesc == 'clear sky') {
              iconData = Icons.sunny;
            } else if (weatherDesc == 'few clouds') {
              iconData = Icons.cloud_outlined;
            } else if (weatherDesc == 'scattered clouds') {
              iconData = Icons.cloud_outlined;
            } else if (weatherDesc == 'broken clouds') {
              iconData = Icons.cloud_outlined;
            } else if (weatherDesc == 'shower rain') {
              iconData = Icons.cloud;
            } else if (weatherDesc == 'rain') {
              iconData = Icons.thunderstorm;
            } else if (weatherDesc == 'thunderstorm') {
              iconData = Icons.thunderstorm;
            } else if (weatherDesc == 'snow') {
              iconData = Icons.sunny_snowing;
            } else if (weatherDesc == 'mist') {
              iconData = Icons.sunny_snowing;
            }
            return ForcastCard(
                temperature: temp,
                time: time,
                curDate: forcastDate,
                weatherIcon: iconData);
          }),
    );
  }
}
