import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

class GeminiService {
  final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? "";

  Future<String> getRecipe(String ingredients) async {
    final String url =
        "https://74.125.132.95/v1beta/models/gemini-2.5-flash:generateContent?key=$_apiKey";

    final Map<String, dynamic> body = {
      "contents": [
        {
          "role": "user",
          "parts": [
            {"text": "I have the following information: $ingredients. Suggest a classic recipe."}
          ]
        }
      ]
    };

    // 💡 custom HttpClient to ignore bad certificate error
    final client = HttpClient()
      ..badCertificateCallback =
      ((X509Certificate cert, String host, int port) => host == '74.125.132.95');

    try {
      final request = await client.postUrl(Uri.parse(url));

      // Set headers, including the crucial Host header
      request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
      request.headers.set(HttpHeaders.hostHeader, "generativelanguage.googleapis.com");

      request.add(utf8.encode(jsonEncode(body)));

      final response = await request.close();

      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        return data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? "No results found.";
      } else {
        print("API Error Body: $responseBody");
        return "Error: ${response.statusCode}";
      }
    } catch (e) {
      print("Network Error: $e");
      return "Critical Network Error: $e";
    } finally {
      client.close();
    }
  }
}