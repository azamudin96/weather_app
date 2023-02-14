import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
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

  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  late StreamSubscription<Position> positionStream;

  @override
  void initState() {
    super.initState();
    checkGps();
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text('Location permissions are denied'),
                    content:
                        const Text('Location access needed. Please try again.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => {
                          checkGps(),
                          Navigator.of(context).pop(),
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ));
        } else if (permission == LocationPermission.deniedForever) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text(
                        'Location permissions are permanently denied'),
                    content: const Text(
                        'Location access needed. Go to settings to enable.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => {
                          openAppSettings(),
                          Navigator.of(context).pop(),
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ));
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        setState(() {
          //refresh the UI
        });

        getLocation();
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }

    setState(() {
      //refresh the UI
    });
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    long = position.longitude.toString();
    lat = position.latitude.toString();

    setState(() {
      //refresh UI
      getForecast();
    });

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      print(position.longitude); //Output: 80.24599079
      print(position.latitude); //Output: 29.6593457

      long = position.longitude.toString();
      lat = position.latitude.toString();

      setState(() {
        //refresh UI on update
        getForecast();
      });
    });
  }

  void getForecast() async {
    setState(() {
      isLoading = true;
      weatherList.clear();
    });
    var url =
        'https://api.openweathermap.org/data/2.5/forecast?lat=${position.latitude}&lon=${position.longitude}&appid=021ea371d852bf973533abfa2cc5cf0b';
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
              checkGps();
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
