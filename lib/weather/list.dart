import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/custom/weathercard.dart';
import 'package:weather_app/model/weather.dart';
import 'package:weather_app/util/colors.dart';
import 'package:weather_app/util/constant.dart';

class WeatherListScreen extends StatefulWidget {
  const WeatherListScreen({super.key});

  @override
  State<WeatherListScreen> createState() => _WeatherListScreenState();
}

class _WeatherListScreenState extends State<WeatherListScreen> {
  final dio = Dio();
  final List<List<Data>> weatherList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getForecast();
  }

  void getForecast() async {
    setState(() {
      isLoading = true;
      weatherList.clear();
    });
    var url =
        'https://api.openweathermap.org/data/2.5/forecast?lat=6.124785&lon=102.254379&appid=021ea371d852bf973533abfa2cc5cf0b';
    final response = await dio.get(url);
    final weather = WeatherResponse.fromJson(response.data);
    if (weather.cod == '200') {
      var list = weather.list!;

      //group by date
      var groupByDate = groupBy(list, (obj) => obj.getDtFormatted());

      // object to list of object
      var list2 = groupByDate.values.toList();
      setState(() {
        weatherList.addAll(list2);
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text(APP_NAME),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              getForecast();
            },
          ),
        ],
        backgroundColor: kAppBarColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: weatherList.length,
              itemBuilder: (context, index) {
                final weather = weatherList[index];
                return WeatherCard(weather: weather);
              },
            ),
    );
  }
}
