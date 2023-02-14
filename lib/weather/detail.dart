import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/model/weather.dart';
import 'package:weather_app/util/colors.dart';
import 'package:weather_app/util/constant.dart';

class WeatherDetailScreen extends StatelessWidget {
  final Data weather;
  const WeatherDetailScreen({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text(APP_NAME),
        backgroundColor: kAppBarColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              color: kHeaderColor2,
              child: Text(
                "${weather.getTime()} ${weather.getDtFormatted()}",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            CachedNetworkImage(
              imageUrl: weather.getIconUrl(),
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Text(weather.getWeatherMain(),
                style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 80),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Wind: ${weather.getWindSpeed()}",
                      style:
                          const TextStyle(fontSize: 20, color: Colors.white70)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Current: ${weather.getTemp()}",
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white70)),
                      Text("Max: ${weather.getTempMax()}",
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white70)),
                      Text("Min: ${weather.getTempMin()}",
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white70)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
