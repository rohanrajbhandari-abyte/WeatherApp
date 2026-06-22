import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import 'dart:convert';

class WeatherServices {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apikey;

  WeatherServices(this.apikey);

  Future<Weather> getWeather(String cityname) async {
    final response = await http.get(
        Uri.parse('$BASE_URL?q=$cityname&appid=$apikey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error getting weather');
    }
  }

  Future<String> getCurrentCity() async {
    // 1. Get permission from user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // 2. Fetch current location
    Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

    // 3. Convert the location into a list of placemark objects
    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);

    // 4. Extract the city name from the first placemark
    String? city = placemarks[0].locality;

    return city ?? "";
  }
}