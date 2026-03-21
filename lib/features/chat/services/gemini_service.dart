import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  static const _apiKey =
      'AIzaSyCn6Fe17Pd1ipAeGv8oM0rcOyEdmtFtlWw';

  // gemini-2.0-flash is the correct working model as of 2026
  static const _url =
      'https://generativelanguage.googleapis.com'
      '/v1beta/models/gemini-2.0-flash:generateContent';

  static const _systemPrompt =
      'You are AyurAI, a helpful and caring medical assistant '
      'inside the AyurVanta healthcare app. '
      'The patient is Arjun Sharma, Age 36, Blood group B+. '
      'Known conditions: borderline HbA1c blood sugar, '
      'under cardiology care with Dr Ravi Kumar, Apollo Hospitals. '
      'Medications: Amlodipine 5mg, Atorvastatin 10mg, Aspirin 75mg. '
      'Allergy: Penicillin. '
      'Always reply in under 120 words. '
      'Be warm, empathetic, and clear. '
      'Never diagnose — provide general health guidance only. '
      'For emergency symptoms say to use Emergency SOS immediately. '
      'Suggest seeing a doctor when needed. '
      'End with a helpful follow-up question.';

  static Future<String> chat(
      List<Map<String, String>> history,
      String userMessage,
      ) async {
    debugPrint('🚀 Calling Gemini: $userMessage');

    try {
      final uri = Uri.parse('$_url?key=$_apiKey');

      // Simplest valid request — inject system context in user message
      final body = jsonEncode({
        'contents': [
          {
            'role': 'user',
            'parts': [
              {
                'text': '$_systemPrompt\n\nPatient question: $userMessage',
              }
            ],
          }
        ],
        'generationConfig': {
          'temperature': 0.7,
          'maxOutputTokens': 300,
          'topP': 0.9,
        },
      });

      final response = await http
          .post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: body,
      )
          .timeout(const Duration(seconds: 30));

      debugPrint('📥 Status: ${response.statusCode}');
      debugPrint('📥 Body: ${response.body}');

      if (response.statusCode == 200) {
        return _parseSuccess(response.body);
      } else if (response.statusCode == 429) {
        await Future.delayed(const Duration(seconds: 6));
        return await _retrySimple(userMessage);
      } else if (response.statusCode == 403) {
        return '❌ API key invalid. Please regenerate at aistudio.google.com';
      } else if (response.statusCode == 404) {
        return '❌ Model not found (404). Contact support.';
      } else {
        final err = jsonDecode(response.body);
        final msg = err['error']?['message'] ?? 'Unknown error';
        return 'Error ${response.statusCode}: $msg';
      }
    } on TimeoutException {
      return 'Request timed out. Check your internet. 🔄';
    } catch (e) {
      debugPrint('💥 Exception: $e');
      return 'Connection error. Please check your internet.';
    }
  }

  static Future<String> _retrySimple(String userMessage) async {
    try {
      final uri = Uri.parse('$_url?key=$_apiKey');
      final body = jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': 'Answer as a medical assistant briefly: $userMessage'}
            ]
          }
        ],
      });
      final response = await http
          .post(uri,
          headers: {'Content-Type': 'application/json'}, body: body)
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) return _parseSuccess(response.body);
      return 'AI is busy. Please wait 30 seconds and try again. ⏳';
    } catch (_) {
      return 'Still unable to connect. Please try again. 🔄';
    }
  }

  static String _parseSuccess(String body) {
    try {
      final data = jsonDecode(body) as Map<String, dynamic>;
      final candidates = data['candidates'] as List?;
      if (candidates == null || candidates.isEmpty) {
        return 'No response received. Please try again.';
      }
      final candidate = candidates[0] as Map<String, dynamic>;
      final finishReason = candidate['finishReason'] as String?;
      if (finishReason == 'SAFETY') {
        return 'Response blocked for safety. Please consult a doctor. 🏥';
      }
      final content = candidate['content'] as Map?;
      final parts = content?['parts'] as List?;
      final text = parts?.isNotEmpty == true
          ? parts![0]['text'] as String?
          : null;
      if (text == null || text.trim().isEmpty) {
        return 'Received empty response. Please try again.';
      }
      return text.trim();
    } catch (e) {
      debugPrint('Parse error: $e');
      return 'Could not read AI response. Please try again.';
    }
  }
}