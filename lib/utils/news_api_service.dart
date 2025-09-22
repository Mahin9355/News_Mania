import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/news_model.dart';

class ApiService {
  final String baseUrl = "https://gnews.io/api/v4";

  /// Fetch top news. If [category] is null, fetch all news.
  Future<List<News>> fetchTopNews(String? category) async {
    final apiKey = dotenv.env['GNEWS_API_KEY'] ?? '';

    // Build URL
    String urlString = "$baseUrl/top-headlines?lang=en&apikey=$apiKey";

    if (category != null && category.isNotEmpty) {
      urlString += "&category=$category";
    }

    final url = Uri.parse(urlString);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List articles = data['articles'];
      return articles.map((json) => News.fromJson(json, category ?? 'All')).toList();
    } else {
      throw Exception("Failed to fetch news: ${response.statusCode}");
    }
  }
}