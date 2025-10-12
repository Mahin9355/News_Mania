import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/news_model.dart';

class ApiService {
  final String gnewsBase = "https://gnews.io/api/v4";
  final String theNewsApiBase = "https://api.thenewsapi.com/v1/news/all";
  final String mediastackBase = "http://api.mediastack.com/v1/news";
  final String newsDataBase = "https://newsdata.io/api/1/news";
  final String theGuardianBase = "https://content.guardianapis.com";

  final String gnewsApiKey = dotenv.env['GNEWS_API_KEY'] ?? '';
  final String theNewsApiKey = dotenv.env['THE_NEWS_API_KEY'] ?? '';
  final String mediastackApiKey = dotenv.env['MEDIA_STACK_API_KEY'] ?? '';
  final String newsDataApiKey = dotenv.env['NEWS_DATA_API_KEY'] ?? '';
  final String theGuardianApiKey = 'fa6c348f-6db0-49de-a7b6-41c92019c966';

  /// GNews
  Future<List<News>> fetchTopNews(String? category) async {
    String url = "$gnewsBase/top-headlines?lang=en&apikey=$gnewsApiKey";
    if (category != null && category.isNotEmpty) url += "&category=$category";

    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return (data['articles'] as List)
          .map((json) => News.fromGNews(json, category ?? 'All'))
          .toList();
    }
    return [];
  }

  /// TheNewsAPI
  ///
  Future<List<News>> fetchTheNewsAPI(String? category) async {
    String url = "$theNewsApiBase?api_token=$theNewsApiKey";
    if (category != null && category.isNotEmpty) url += "&category=$category";

    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return (data['data'] as List)
          .map((json) => News.fromTheNewsAPI(json, category ?? 'All'))
          .toList();
    }
    return [];
  }

  /// Mediastack
  Future<List<News>> fetchMediastack(String? category) async {
    String url = "$mediastackBase?access_key=$mediastackApiKey&languages=en";
    if (category != null && category.isNotEmpty) url += "&categories=$category";

    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return (data['data'] as List)
          .map((json) => News.fromMediastack(json, category ?? 'All'))
          .toList();
    }
    return [];
  }

  /// NewsData.io
  Future<List<News>> fetchNewsData(String? category) async {
    String url = "$newsDataBase?apikey=$newsDataApiKey&language=en";
    if (category != null && category.isNotEmpty) url += "&category=$category";

    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return (data['results'] as List)
          .map((json) => News.fromNewsData(json, category ?? 'All'))
          .toList();
    }
    return [];
  }

  /// The Guardian
  Future<List<News>> fetchTheGuardian(String? category) async {
    String url = theGuardianBase;
    print('api: $theGuardianApiKey');
    if (category != null && category.isNotEmpty) {
      url += '/$category?api-key=$theGuardianApiKey';
    } else {
      url += '/search?api-key=$theGuardianApiKey';
    }
    print(url);

    final res = await http.get(Uri.parse(url));
    print(res.body);
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final results = data['response']['results'] as List;
      return results
          .map((json) => News.fromTheGuardian(json, category ?? 'All'))
          .toList();

    }
    return [];
  }
}
