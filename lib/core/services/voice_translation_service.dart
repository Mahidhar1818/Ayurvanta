import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class VoiceTranslationService {
  // Uses Gemini to translate any Indian language to English
  static const _apiKey = 'AIzaSyCn6Fe17Pd1ipAeGv8oM0rcOyEdmtFtlWw';
  static const _url =
      'https://generativelanguage.googleapis.com/v1beta'
      '/models/gemini-2.0-flash:generateContent';

  // Translate any language text to English
  static Future<String> translateToEnglish(String text) async {
    if (text.trim().isEmpty) return '';

    try {
      final uri = Uri.parse('$_url?key=$_apiKey');
      final body = jsonEncode({
        'contents': [
          {
            'parts': [
              {
                'text': 'Translate the following text to English. '
                    'If it is already in English, return as is. '
                    'Return ONLY the translated text, '
                    'nothing else, no explanations:\n\n$text',
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.1,
          'maxOutputTokens': 200,
        },
      });

      final response = await http
          .post(uri,
              headers: {'Content-Type': 'application/json'},
              body: body)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final candidates = data['candidates'] as List?;
        if (candidates != null && candidates.isNotEmpty) {
          final parts =
              candidates[0]['content']['parts'] as List?;
          if (parts != null && parts.isNotEmpty) {
            return (parts[0]['text'] as String).trim();
          }
        }
      }
      debugPrint('Translation error: ${response.body}');
      return text; // return original if translation fails
    } catch (e) {
      debugPrint('Translation exception: $e');
      return text;
    }
  }

  // Extract structured OPD info from voice text using Gemini
  static Future<Map<String, String>> extractOpdInfo(
      String translatedText) async {
    try {
      final uri = Uri.parse('$_url?key=$_apiKey');
      final body = jsonEncode({
        'contents': [
          {
            'parts': [
              {
                'text': 'Extract patient information from this text '
                    'and return ONLY a JSON object with these keys: '
                    'name, age, symptoms, duration, department. '
                    'If any field is not mentioned use empty string. '
                    'Text: "$translatedText"\n\n'
                    'Return only valid JSON, no markdown, '
                    'no explanations.',
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.1,
          'maxOutputTokens': 200,
        },
      });

      final response = await http
          .post(uri,
              headers: {'Content-Type': 'application/json'},
              body: body)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final candidates = data['candidates'] as List?;
        if (candidates != null && candidates.isNotEmpty) {
          final parts =
              candidates[0]['content']['parts'] as List?;
          if (parts != null && parts.isNotEmpty) {
            final jsonStr = (parts[0]['text'] as String)
                .trim()
                .replaceAll('```json', '')
                .replaceAll('```', '')
                .trim();
            final map =
                jsonDecode(jsonStr) as Map<String, dynamic>;
            return map.map((k, v) => MapEntry(k, v.toString()));
          }
        }
      }
    } catch (e) {
      debugPrint('Extract info error: $e');
    }
    return {};
  }

  // Generate emergency summary from voice text
  static Future<String> generateEmergencySummary(
      String translatedText) async {
    try {
      final uri = Uri.parse('$_url?key=$_apiKey');
      final body = jsonEncode({
        'contents': [
          {
            'parts': [
              {
                'text': 'You are an emergency medical dispatcher. '
                    'Convert this patient statement into a clear, '
                    'concise medical emergency summary in English '
                    'for doctors. Include urgency level. '
                    'Keep it under 50 words. '
                    'Patient said: "$translatedText"',
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.3,
          'maxOutputTokens': 150,
        },
      });

      final response = await http
          .post(uri,
              headers: {'Content-Type': 'application/json'},
              body: body)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final candidates = data['candidates'] as List?;
        if (candidates != null && candidates.isNotEmpty) {
          final parts =
              candidates[0]['content']['parts'] as List?;
          if (parts != null && parts.isNotEmpty) {
            return (parts[0]['text'] as String).trim();
          }
        }
      }
    } catch (e) {
      debugPrint('Emergency summary error: $e');
    }
    return translatedText;
  }
}
