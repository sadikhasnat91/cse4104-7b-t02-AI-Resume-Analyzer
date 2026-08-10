import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/config_service.dart';

class GeminiService {
	static const _baseUrl = '';
	static const _defaultModel = '';

	static bool isQuotaExceededError(Object error) {
		final message = error.toString().toLowerCase();
		return message.contains('429') ||
				message.contains('resource_exhausted') ||
				message.contains('quota exceeded') ||
				message.contains('quota has been exceeded') ||
				message.contains('free-tier quota');
	}

	static String friendlyErrorMessage(Object error) {
		if (isQuotaExceededError(error)) {
			return 'The Gemini free-tier quota has been used up for now. Please wait a little while before trying again.';
		}

		if (error is StateError) {
			return error.message;
		}

		return 'We could not analyze your resume right now. Please try again later.';
	}

	static Uri buildRequestUri(String model) {
		return Uri.parse('$_baseUrl/models/$model:generateContent');
	}

	static Map<String, String> buildHeaders(String apiKey) {
		return {'Content-Type': 'application/json', 'x-goog-api-key': apiKey};
	}

	static Future<Map<String, dynamic>> analyzeResume({
		required String fileName,
		required String category,
		required String seniority,
		required String resumeText,
	}) async {
		final apiKey = ConfigService.to.geminiApiKey.value.trim();
		if (apiKey.isEmpty) {
			throw StateError(
				'Gemini API key is not configured. Run with --dart-define=GEMINI_API_KEY=your_key',
			);
		}

		final prompt = _buildPrompt(
			fileName: fileName,
			category: category,
			seniority: seniority,
			resumeText: resumeText,
		);

		final response = await http.post(
			buildRequestUri(_defaultModel),
			headers: buildHeaders(apiKey),
			body: jsonEncode({
				'contents': [
					{
						'role': 'user',
						'parts': [
							{'text': prompt},
						],
					},
				],
				'generationConfig': {'temperature': 0.3, 'maxOutputTokens': 2000},
			}),
		);

		if (response.statusCode != 200) {
			throw StateError(
				'Gemini request failed with status ${response.statusCode}: ${response.body}',
			);
		}

		final payload = jsonDecode(response.body) as Map<String, dynamic>;
		final message = _extractResponseText(payload);

		return _parseResponse(
			message,
			fileName: fileName,
			category: category,
			seniority: seniority,
		);
	}

	static String _extractResponseText(Map<String, dynamic> payload) {
		final candidates = payload['candidates'] as List<dynamic>? ?? const [];
		if (candidates.isEmpty) {
			throw FormatException('Gemini response does not contain a candidate.');
		}

		final parts =
				candidates.first['content']?['parts'] as List<dynamic>? ?? const [];
		if (parts.isEmpty) {
			throw FormatException('Gemini response does not contain text content.');
		}

		final text = parts.first['text'];
		if (text is! String || text.trim().isEmpty) {
			throw FormatException('Gemini response text is empty.');
		}

		return text;
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
		final trimmed = message.trim();
		final jsonStart = trimmed.indexOf('{');
		final jsonEnd = trimmed.lastIndexOf('}');

		if (jsonStart < 0 || jsonEnd < jsonStart) {
			throw FormatException('Gemini response is not valid JSON.');
		}

		final jsonString = trimmed.substring(jsonStart, jsonEnd + 1);
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
