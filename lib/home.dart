     

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/settings.dart';

class WeatherHomePage extends StatefulWidget {
  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  String _temperature = '';
  String _condition = '';
  String _location = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }


  Future<void> _fetchWeatherData({String? city}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      String apiUrl;

      if (city != null && city.isNotEmpty) {

        apiUrl = 'https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=aee4e986f9afc76a1314b1fd1aa1b5ceY';
      } else {

        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&units=metric&appid=6c4c59361484bbd8810f56c3b39dcc6c';
      }

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          _temperature = '${data['main']['temp'].round()}°C';
          _condition = data['weather'][0]['main'];
          _location = data['name'];
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _temperature = 'Error';
        _condition = 'Failed to fetch weather data';
        _location = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () async {
              final selectedLocation = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
              if (selectedLocation != null) {
                _fetchWeatherData(city: selectedLocation);
              }
            },
          ),
        ],
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _location,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              _temperature,
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              _condition,
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _fetchWeatherData(),
              child: Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }
}
