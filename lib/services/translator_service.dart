import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslatorService {
  /// Translates text from [fromLang] to Bangla using MyMemory API
  static Future<String> translateToBangla(String text, {String fromLang = 'en'}) async {
    try {
      final encodedText = Uri.encodeComponent(text);
      final url =
          'https://api.mymemory.translated.net/get?q=$encodedText&langpair=$fromLang|bn';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final translated = data['responseData']['translatedText'];
        return translated ?? text;
      } else {
        print('Translation API error: ${response.statusCode}');
        return text;
      }
    } catch (e) {
      print('Translation failed: $e');
      return text;
    }
  }
}
