import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _apiKey = 'aec5f00d43d978bed8911a3c3d308b25';
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  static Future<Map<String, dynamic>> getWeather(String city) async {
    final url = Uri.parse('$_baseUrl?q=$city&appid=$_apiKey&units=metric');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'temp': data['main']['temp'],
          'weather': data['weather'][0]['main'],
          'icon': data['weather'][0]['icon'],
          'city': data['name'],
        };
      } else {
        print('❌ Gagal ambil data cuaca. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Gagal memuat data cuaca');
      }
    } catch (e) {
      print('❌ Terjadi kesalahan saat mengambil data cuaca: $e');
      rethrow;
    }
  }
}
