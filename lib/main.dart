import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _cityController = TextEditingController();
  String _weatherData = '';
  static const String token = "Q4X3V73L985XDYBA33J6SBJSV";

  Future<void> _fetchWeatherData(String cityName) async {
    final response = await http.get(Uri.parse(
        'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/$cityName?key=$token'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _weatherData = data.toString();
      });
    } else {
      setState(() {
        _weatherData = 'Failed to fetch weather data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'City Name'),
            ),
            ElevatedButton(
              onPressed: () {
                final cityName = _cityController.text.trim();
                _fetchWeatherData(cityName);
              },
              child: const Text('Get Weather'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _weatherData,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
