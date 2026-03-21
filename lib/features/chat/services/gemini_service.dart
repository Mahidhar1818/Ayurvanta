import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  // Direct key — no .env dependency
  static const _apiKey =
      'AIzaSyCn6Fe17Pd1ipAeGv8oM0rcOyEdmtFtlWw';

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
      'Instructions: Always reply in under 120 words. '
      'Be warm, empathetic, and clear. '
      'Never diagnose — provide general health guidance only. '
      'For emergency symptoms say to use Emergency SOS immediately. '
      'Suggest seeing a doctor when needed. '
      'End with a helpful follow-up question.';

  static Future<String> chat(
    List<Map<String, String>> history,
    String userMessage,
  ) async {
    debugPrint('🚀 GeminiService.chat called');
    debugPrint('📝 User message: $userMessage');

    try {
      final uri = Uri.parse('$_url?key=$_apiKey');

      // Build the simplest valid request
      final body = jsonEncode({
        'contents': [
          {
            'role': 'user',
            'parts': [
              {
                'text': '$_systemPrompt\n\n'
                    'Patient question: $userMessage',
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

      debugPrint('📤 Sending request to Gemini...');

      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 30));

      debugPrint('📥 Response status: ${response.statusCode}');
      debugPrint('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final text = _parseSuccess(response.body);
        debugPrint('✅ Parsed reply: $text');
        return text;
      } else if (response.statusCode == 429) {
        debugPrint('⚠️ Rate limited, waiting 5s...');
        await Future.delayed(const Duration(seconds: 5));
        return await _retry(userMessage);
      } else if (response.statusCode == 400) {
        debugPrint('❌ 400 error: ${response.body}');
        return _parseError(response.body);
      } else if (response.statusCode == 403) {
        return '❌ API key rejected (403). '
            'Please regenerate your Gemini API key at '
            'aistudio.google.com';
      } else {
        debugPrint('❌ Unknown error: ${response.statusCode}');
        return 'Server error ${response.statusCode}. '
            'Please try again.';
      }
    } on TimeoutException {
      debugPrint('⏰ Request timed out');
      return 'Request timed out. '
          'Please check your internet connection. 🔄';
    } catch (e) {
      debugPrint('💥 Exception: $e');
      return 'Error: ${e.toString()}\n\n'
          'Please check your internet connection.';
    }
  }

  // Retry with even simpler request
  static Future<String> _retry(String userMessage) async {
    try {
      final uri = Uri.parse('$_url?key=$_apiKey');
      final body = jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': 'Answer briefly as a medical assistant: $userMessage'}
            ]
          }
        ],
      });

      final response = await http
          .post(uri,
              headers: {'Content-Type': 'application/json'},
              body: body)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return _parseSuccess(response.body);
      }
      return 'AI is busy right now. Please try again in 30 seconds. ⏳';
    } catch (_) {
      return 'Still unable to connect. Please try again. 🔄';
    }
  }

  // Parse successful 200 response
  static String _parseSuccess(String body) {
    try {
      final data = jsonDecode(body) as Map<String, dynamic>;

      // Check for safety block
      final feedback = data['promptFeedback'] as Map?;
      if (feedback?['blockReason'] != null) {
        return 'I cannot answer that for safety reasons. '
            'Please rephrase your question.';
      }

      final candidates = data['candidates'] as List?;
      if (candidates == null || candidates.isEmpty) {
        return 'No response from AI. Please try again.';
      }

      final candidate = candidates[0] as Map<String, dynamic>;

      // Check finish reason
      final finishReason = candidate['finishReason'] as String?;
      if (finishReason == 'SAFETY') {
        return 'Response blocked for safety. '
            'Please consult a doctor directly. 🏥';
      }
      if (finishReason == 'RECITATION') {
        return 'I cannot reproduce that content. '
            'Please ask in a different way.';
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
      debugPrint('Parse error: $e\nBody: $body');
      return 'Could not read AI response. Please try again.';
    }
  }

  // Parse error response body
  static String _parseError(String body) {
    try {
      final data = jsonDecode(body) as Map<String, dynamic>;
      final error = data['error'] as Map?;
      final message = error?['message'] as String?;
      return 'AI error: ${message ?? "Unknown error"}. '
          'Please try again.';
    } catch (_) {
      return 'Bad request error. Please try again.';
    }
  }
}
