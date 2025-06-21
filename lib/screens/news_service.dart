import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  static const String _apiKey = '70b170a79e044f62a1a35d4177616192';
  static const String _baseUrl = 'https://newsapi.org/v2/everything';

  static Future<List<Map<String, dynamic>>> getAgriLivestockNews() async {
    final url = Uri.parse(
      '$_baseUrl?q=peternakan+OR+pertanian&language=id&sortBy=publishedAt&apiKey=$_apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['articles'].take(5));
    }
    throw Exception('Failed to load news');
  }
}
