import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  static const _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models'
      '/gemini-pro:generateContent';

  // System context about the patient
  static const _systemPrompt = '''
You are AyurAI, a compassionate medical assistant inside the
AyurVanta healthcare app. The patient is Arjun Sharma (Ayur ID:
AYR-4829-3810-7642). His known conditions: borderline blood sugar,
under cardiology follow-up with Dr. Ravi Kumar at Apollo Hospitals.

Rules:
1. Always be empathetic, clear, and concise.
2. Never diagnose — only provide general guidance.
3. For severe symptoms, always recommend Emergency SOS first.
4. Reference the patient's medical history when relevant.
5. Suggest booking an appointment or contacting their doctor
   when appropriate.
6. Keep replies under 120 words.
7. Use emojis sparingly for readability.
8. End with a follow-up question when appropriate.
''';

  static Future<String> sendMessage(
      List<Map<String, dynamic>> history, String userMessage) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

    // Build conversation history for Gemini
    final contents = <Map<String, dynamic>>[];

    // Add history
    for (final msg in history) {
      contents.add({
        'role': msg['role'] == 'ai' ? 'model' : 'user',
        'parts': [{'text': msg['text']}],
      });
    }

    // Add current user message
    contents.add({
      'role': 'user',
      'parts': [{'text': userMessage}],
    });

    final response = await http.post(
      Uri.parse('\$_baseUrl?key=\$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'system_instruction': {
          'parts': [{'text': _systemPrompt}],
        },
        'contents': contents,
        'generationConfig': {
          'temperature': 0.7,
          'maxOutputTokens': 300,
        },
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text']
          as String;
    } else {
      throw Exception('Gemini API error: \${response.statusCode}');
    }
  }
}
