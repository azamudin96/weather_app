import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/model/weather.dart';
import 'package:weather_app/util/colors.dart';
import 'package:weather_app/weather/detail.dart';

class WeatherCard extends StatelessWidget {
  final List<Data> weather;
  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WeatherDetailScreen(weather: weather[0]),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        child: Card(
          color: kCardBackgroundColor,
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                width: double.infinity,
                color: kHeaderColor,
                child: Text(
                  weather[0].getDtFormattedWithSuffix(),
                  style: const TextStyle(color: Colors.white70, fontSize: 18),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    CachedNetworkImage(
                      imageUrl: weather[0].getIconUrl(),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(weather[0].getWeatherMain(),
                            style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        Text(weather[0].getTime(),
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white70)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                width: double.infinity,
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          CachedNetworkImage(
                            width: 60,
                            height: 60,
                            imageUrl: weather[0].getIconUrl(),
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          Text(
                            weather[0].getTime(),
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      if (weather.length > 1)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: VerticalDivider(
                            thickness: 1,
                            width: 20,
                            color: Colors.black,
                          ),
                        ),
                      if (weather.length > 1)
                        Column(
                          children: [
                            CachedNetworkImage(
                              width: 60,
                              height: 60,
                              imageUrl: weather[1].getIconUrl(),
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            Text(
                              weather[1].getTime(),
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      if (weather.length > 2)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: VerticalDivider(
                            thickness: 1,
                            width: 20,
                            color: Colors.black,
                          ),
                        ),
                      if (weather.length > 2)
                        Column(
                          children: [
                            CachedNetworkImage(
                              width: 60,
                              height: 60,
                              imageUrl: weather[2].getIconUrl(),
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            Text(
                              weather[2].getTime(),
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
