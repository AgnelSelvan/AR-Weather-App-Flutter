import 'package:ar_weather_app/views/ar_weather.dart';
import 'package:ar_weather_app/views/ar_weather_data.dart';
import 'package:ar_weather_app/views/planes.dart';
import 'package:ar_weather_app/views/tap.dart';
import 'package:flutter/material.dart';

class ListsScreen extends StatefulWidget {
  const ListsScreen({Key? key}) : super(key: key);

  @override
  State<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: const Text("Planes"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const PlanesScreen())));
              },
            ),
            ListTile(
              title: const Text("Tap"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const ARTapScreen())));
              },
            ),
            ListTile(
              title: const Text("AR Weather Data"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const ARWeatherDataScreen())));
              },
            ),
            ListTile(
              title: const Text("Weather"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const ARWeatherScreen())));
              },
            ),
          ],
        ),
      ),
    );
  }
}
