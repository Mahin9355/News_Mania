import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_key.dart';

Future<String> summarizeNews(String content) async {
  const endPoint = "https://openrouter.ai/api/v1/chat/completions";

  final headers = {
    "Authorization": "Bearer $apiKey",
    "Content-Type": "application/json",
  };

  final body = jsonEncode({
    "model": "shisa-ai/shisa-v2-llama3.3-70b:free",
    "messages": [
      {
        "role": "system",
        "content":
        "You are a news assistant. Summarize articles into 3-5 bullet points. No templates, no explanations — just the summary."
      },
      {"role": "user", "content": "Summarize this news article:\n\n$content"}
    ],
    "max_tokens": 100,
    "temperature": 0.5,
  });

  final response =
  await http.post(Uri.parse(endPoint), headers: headers, body: body);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['choices'][0]['message']['content'];
  } else {
    throw Exception("Failed to summarize: ${response.body}");
  }
}

/// NEW: Expand a user’s search query with AI
Future<List<String>> expandSearchQuery(String query) async {
  const endPoint = "https://openrouter.ai/api/v1/chat/completions";

  final headers = {
    "Authorization": "Bearer $apiKey",
    "Content-Type": "application/json",
  };

  final body = jsonEncode({
    "model": "shisa-ai/shisa-v2-llama3.3-70b:free",
    "messages": [
      {
        "role": "system",
        "content":
        "You are a search assistant. Expand user queries into multiple impactful, keyword-rich search variations for news retrieval. Return only the expanded queries separated by commas."
      },
      {"role": "user", "content": "Expand this query for better news search: $query"}
    ],
    "max_tokens": 100,
    "temperature": 0.7,
  });

  final response =
  await http.post(Uri.parse(endPoint), headers: headers, body: body);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final content = data['choices'][0]['message']['content'] as String;

    // Split into multiple queries by commas
    return content.split(',').map((e) => e.trim()).toList();
  } else {
    throw Exception("Failed to expand query: ${response.body}");
  }
}