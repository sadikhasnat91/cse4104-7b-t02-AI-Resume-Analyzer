import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/config_service.dart';

class GeminiService {
  static const _endpoint = 'https://api.openai.com/v1/chat/completions';

  static Future<Map<String, dynamic>> analyzeResume({
    required String fileName,
    required String category,
    required String seniority,
    required String resumeText,
  }) async {
    final apiKey = ConfigService.to.geminiApiKey.value;
    if (apiKey.isEmpty) {
      throw StateError('Gemini API key is not configured.');
    }

    final prompt = _buildPrompt(
      fileName: fileName,
      category: category,
      seniority: seniority,
      resumeText: resumeText,
    );

    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-4o-mini',
        'messages': [
          {
            'role': 'system',
            'content':
                'You are a resume analysis assistant. Provide strengths, weaknesses, and actionable improvement suggestions for a candidate resume.',
          },
          {'role': 'user', 'content': prompt},
        ],
        'temperature': 0.3,
      }),
    );

    if (response.statusCode != 200) {
      throw StateError(
        'Gemini request failed with status ${response.statusCode}.',
      );
    }

    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    final message =
        (payload['choices'] as List).first['message']['content'] as String;

    return _parseResponse(
      message,
      fileName: fileName,
      category: category,
      seniority: seniority,
    );
  }

  static String _buildPrompt({
    required String fileName,
    required String category,
    required String seniority,
    required String resumeText,
  }) {
    return '''
Analyze the following resume text for a job in $category at the $seniority level.

Resume filename: $fileName

Resume content:
$resumeText

Return a JSON object with keys: score, strengths, weaknesses, suggestions.
- score: integer 0-100
- strengths: array of 3-5 short bullets
- weaknesses: array of 3-5 short bullets
- suggestions: array of 3-5 specific recommendations

Return only valid JSON.
''';
  }

  static Map<String, dynamic> _parseResponse(
    String message, {
    required String fileName,
    required String category,
    required String seniority,
  }) {
    final jsonStart = message.indexOf('{');
    if (jsonStart < 0) {
      throw FormatException('Gemini response is not valid JSON.');
    }

    final jsonString = message.substring(jsonStart);
    final responseJson = jsonDecode(jsonString) as Map<String, dynamic>;

    return {
      'fileName': fileName,
      'category': category,
      'seniority': seniority,
      'score': responseJson['score'] as int? ?? 0,
      'strengths': List<String>.from(
        responseJson['strengths'] as List<dynamic>? ?? [],
      ),
      'weaknesses': List<String>.from(
        responseJson['weaknesses'] as List<dynamic>? ?? [],
      ),
      'suggestions': List<String>.from(
        responseJson['suggestions'] as List<dynamic>? ?? [],
      ),
    };
  }
}
