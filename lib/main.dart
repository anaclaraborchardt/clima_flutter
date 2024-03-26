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

  Future<void> _fetchWeatherData(String cityName) async {
    const String token = "4c1bc488751e8305c560d1f5b322357a";
    final response = await http.get(Uri.parse(
        'http://apiadvisor.climatempo.com.br/api/v1/locale/city?name=$cityName&token=$token'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final cityId = data[0]['id'];

      final response2 = await http.put(
        Uri.parse(
            'http://apiadvisor.climatempo.com.br/api-manager/user-token/$token/locales'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: <String, String>{
          'localeId[]': '$cityId',
        },
      );

      if (response2.statusCode == 200) {
        final response3 = await http.get(Uri.parse(
            'http://apiadvisor.climatempo.com.br/api/v1/weather/locale/$cityId/current?token=$token'));

        if (response3.statusCode == 200) {
          final weatherData = jsonDecode(response3.body);
          setState(() {
            _weatherData = weatherData.toString();
          });
        } else {
          throw Exception('Failed to load weather data');
        }
      } else {
        throw Exception('Failed to set user token');
      }
    } else {
      throw Exception('Failed to fetch city data');
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
            ),
          ],
        ),
      ),
    );
  }
}