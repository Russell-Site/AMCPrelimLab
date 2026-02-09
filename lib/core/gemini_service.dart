import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static final String? _apiKey = dotenv.env['GEMINI_API_KEY'];

  static const String _baseUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent";

  static Map<String, String> get _headers => {
    "Content-Type": "application/json",
  };

  /// 🔹 Simple single-prompt call (no history)
  static Future<String> sendRawPrompt(String prompt) async {
    final response = await http.post(
      Uri.parse("$_baseUrl?key=$_apiKey"),
      headers: _headers,
      body: jsonEncode({
        "contents": [
          {
            "role": "user",
            "parts": [
              {"text": prompt}
            ]
          }
        ]
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Gemini error ${response.statusCode}: ${response.body}",
      );
    }

    return _extractText(response.body);
  }

  /// 🔹 Multi-turn chat with system prompt + history
  static Future<String> sendMessage({
    required String systemPrompt,
    required List<Map<String, String>> history,
    required String userMessage,
  }) async {
    final contents = <Map<String, dynamic>>[];

    /// 1️⃣ System instruction FIRST (Gemini style)
    contents.add({
      "role": "user",
      "parts": [
        {
          "text":
          "INSTRUCTION:\n$systemPrompt\n\nFollow this instruction strictly."
        }
      ]
    });

    /// 2️⃣ Previous conversation (chronological)
    for (final m in history) {
      contents.add({
        "role": m["role"],
        "parts": [
          {"text": m["text"]}
        ]
      });
    }

    /// 3️⃣ Latest user message LAST
    contents.add({
      "role": "user",
      "parts": [
        {"text": userMessage}
      ]
    });

    final response = await http.post(
      Uri.parse("$_baseUrl?key=$_apiKey"),
      headers: _headers,
      body: jsonEncode({
        "contents": contents,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Gemini API error ${response.statusCode}: ${response.body}",
      );
    }

    return _extractText(response.body);
  }

  /// 🔹 Safe response parser
  static String _extractText(String responseBody) {
    final data = jsonDecode(responseBody);

    final text = data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"];

    if (text == null || text.toString().trim().isEmpty) {
      throw Exception("Gemini returned empty response");
    }

    return text;
  }
}