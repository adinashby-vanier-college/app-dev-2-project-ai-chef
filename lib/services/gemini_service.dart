import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? "";

  /// Fetches a recipe based on ingredients string.
  /// Returns a recipe text or an error message.
  Future<String> getRecipe(String ingredients) async {
    final String url =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$_apiKey";

    final Map<String, dynamic> body = {
      "contents": [
        {
          "role": "user",
          "parts": [
            {
              "text":
                  "I have the following information: $ingredients. Suggest a classic recipe."
            }
          ]
        }
      ]
    };

    try {
      final response = await http
          .post(Uri.parse(url),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(body))
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Safely parse the recipe text
        final recipe = data['candidates']?[0]?['content']?[0]?['text'] ??
            "No recipe found.";
        return recipe;
      } else {
        print("API Error: ${response.statusCode} ${response.body}");
        return "Error fetching recipe: ${response.statusCode}";
      }
    } catch (e) {
      print("Network Error: $e");
      return "Network error: $e";
    }
  }
}
