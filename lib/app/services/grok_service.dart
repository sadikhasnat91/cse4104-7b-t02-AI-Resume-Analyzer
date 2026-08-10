// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../services/config_service.dart';
//
// class GrokService {
//   static const _baseUrl = 'https://api.x.ai/v1';
//   static const _defaultModel = 'grok-4.5';
//
//   static const _sectionKeywords = <String, List<String>>{
//     'summary': ['summary', 'profile', 'objective', 'about'],
//     'experience': ['experience', 'employment', 'work history'],
//     'education': ['education', 'university', 'college', 'degree'],
//     'skills': ['skills', 'tech stack', 'technologies', 'tools'],
//     'projects': ['projects', 'portfolio', 'case study'],
//   };
//
//   static bool isQuotaExceededError(Object error) {
//     final message = error.toString().toLowerCase();
//     return message.contains('429') ||
//         message.contains('resource_exhausted') ||
//         message.contains('quota exceeded') ||
//         message.contains('quota has been exceeded') ||
//         message.contains('rate limit') ||
//         message.contains('too many requests');
//   }
//
//   static bool isBillingError(Object error) {
//     final message = error.toString().toLowerCase();
//     return message.contains('permission-denied') ||
//         message.contains("doesn't have any credits") ||
//         message.contains('does not have any credits') ||
//         message.contains('licenses yet');
//   }
//
//   static String friendlyErrorMessage(Object error) {
//     if (isQuotaExceededError(error)) {
//       return 'The Grok quota has been used up for now. Please wait a little while before trying again.';
//     }
//
//     if (isBillingError(error)) {
//       return 'Your xAI team does not have credits or an active license yet. Add credits in the xAI console, then try again.';
//     }
//
//     if (error is StateError) {
//       return error.message;
//     }
//
//     return 'We could not analyze your resume right now. Please try again later.';
//   }
//
//   static bool shouldUseFallbackAnalysis(Object error) {
//     final message = error.toString().toLowerCase();
//     return isQuotaExceededError(error) ||
//         isBillingError(error) ||
//         message.contains('socketexception') ||
//         message.contains('failed host lookup') ||
//         message.contains('connection closed');
//   }
//
//   static Uri buildRequestUri(String model) {
//     return Uri.parse('$_baseUrl/chat/completions');
//   }
//
//   static Map<String, String> buildHeaders(String apiKey) {
//     return {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $apiKey',
//     };
//   }
//
//   static Future<Map<String, dynamic>> analyzeResume({
//     required String fileName,
//     required String category,
//     required String seniority,
//     required String resumeText,
//   }) async {
//     final apiKey = ConfigService.to.grokApiKey.value.trim();
//     if (apiKey.isEmpty) {
//       throw StateError(
//         'Grok API key is not configured. Run with --dart-define=GROK_API_KEY=your_key',
//       );
//     }
//
//     final prompt = _buildPrompt(
//       fileName: fileName,
//       category: category,
//       seniority: seniority,
//       resumeText: resumeText,
//     );
//
//     final response = await http.post(
//       buildRequestUri(_defaultModel),
//       headers: buildHeaders(apiKey),
//       body: jsonEncode({
//         'model': _defaultModel,
//         'messages': [
//           {'role': 'user', 'content': prompt},
//         ],
//         'temperature': 0.3,
//         'max_tokens': 2000,
//       }),
//     );
//
//     if (response.statusCode != 200) {
//       throw StateError(
//         'Grok request failed with status ${response.statusCode}: ${response.body}',
//       );
//     }
//
//     final payload = jsonDecode(response.body) as Map<String, dynamic>;
//     final message = _extractResponseText(payload);
//
//     return _parseResponse(
//       message,
//       fileName: fileName,
//       category: category,
//       seniority: seniority,
//     );
//   }
//
//   static Map<String, dynamic> buildFallbackAnalysis({
//     required String fileName,
//     required String category,
//     required String seniority,
//     required String resumeText,
//   }) {
//     final normalized = resumeText.toLowerCase();
//     final wordCount = resumeText
//         .split(RegExp(r'\s+'))
//         .where((word) => word.trim().isNotEmpty)
//         .length;
//
//     final hasEmail = RegExp(r'[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}')
//         .hasMatch(resumeText);
//     final hasPhone = RegExp(r'(\+?\d[\d\s().-]{7,}\d)').hasMatch(resumeText);
//     final hasNumbers = RegExp(r'\b\d+(?:[%+]|\s*(years?|months?|k|m))?\b')
//         .hasMatch(normalized);
//
//     final sectionHits = <String>[];
//     for (final entry in _sectionKeywords.entries) {
//       if (entry.value.any(normalized.contains)) {
//         sectionHits.add(entry.key);
//       }
//     }
//
//     final categoryTerms = category
//         .toLowerCase()
//         .split(RegExp(r'[^a-z0-9]+'))
//         .where((term) => term.length > 2)
//         .toSet();
//     final categoryMatches = categoryTerms.where(normalized.contains).length;
//
//     var score = 35;
//     if (hasEmail) score += 8;
//     if (hasPhone) score += 7;
//     if (hasNumbers) score += 10;
//     score += sectionHits.length * 6;
//     score += (categoryMatches * 5).clamp(0, 15);
//
//     if (wordCount >= 250 && wordCount <= 900) {
//       score += 12;
//     } else if (wordCount >= 150) {
//       score += 6;
//     }
//
//     final boundedScore = score.clamp(42, 89);
//
//     final strengths = <String>[];
//     final weaknesses = <String>[];
//     final suggestions = <String>[];
//
//     if (hasEmail && hasPhone) {
//       strengths.add('Includes direct contact details for recruiter follow-up.');
//     } else {
//       weaknesses.add('Contact information appears incomplete or hard to detect.');
//       suggestions.add('Place phone number and professional email clearly at the top.');
//     }
//
//     if (sectionHits.contains('experience')) {
//       strengths.add('Work experience section is present and likely easy to scan.');
//     } else {
//       weaknesses.add('Experience history is not clearly labeled.');
//       suggestions.add('Add a dedicated Experience section with role, company, and dates.');
//     }
//
//     if (sectionHits.contains('skills')) {
//       strengths.add('Core skills or tools are explicitly listed.');
//     } else {
//       weaknesses.add('Skills are not grouped into a dedicated section.');
//       suggestions.add('Create a Skills section tailored to $category requirements.');
//     }
//
//     if (hasNumbers) {
//       strengths.add('Contains measurable details that can support impact statements.');
//     } else {
//       weaknesses.add('Impact is difficult to judge because quantified results are limited.');
//       suggestions.add('Add metrics such as percentages, revenue, speed, or volume improvements.');
//     }
//
//     if (sectionHits.contains('projects')) {
//       strengths.add('Projects or portfolio work helps demonstrate applied ability.');
//     } else {
//       suggestions.add('Include 1-2 relevant projects that match a $seniority $category role.');
//     }
//
//     if (wordCount < 180) {
//       weaknesses.add('The resume looks too short to cover experience depth convincingly.');
//       suggestions.add('Expand bullet points with scope, tools used, and business outcomes.');
//     } else if (wordCount > 1000) {
//       weaknesses.add('The resume may be overly long for quick recruiter review.');
//       suggestions.add('Tighten older or lower-impact content to improve scannability.');
//     } else {
//       strengths.add('Overall resume length is within a workable review range.');
//     }
//
//     while (strengths.length < 3) {
//       strengths.add('The resume has enough structure to support a first-pass screening review.');
//     }
//     while (weaknesses.length < 3) {
//       weaknesses.add('Role-specific alignment could be made more explicit for target openings.');
//     }
//     while (suggestions.length < 3) {
//       suggestions.add('Mirror keywords from the job description more directly in headings and bullets.');
//     }
//
//     return {
//       'fileName': fileName,
//       'category': category,
//       'seniority': seniority,
//       'score': boundedScore,
//       'strengths': strengths.take(5).toList(),
//       'weaknesses': weaknesses.take(5).toList(),
//       'suggestions': suggestions.take(5).toList(),
//       'analysisSource': 'fallback',
//       'analysisNotice':
//           'Grok is currently unavailable, so this result was generated using a local resume review heuristic.',
//     };
//   }
//
//   static String _extractResponseText(Map<String, dynamic> payload) {
//     final choices = payload['choices'] as List<dynamic>? ?? const [];
//     if (choices.isEmpty) {
//       throw FormatException('Grok response does not contain a choice.');
//     }
//
//     final message = choices.first['message'];
//     if (message is! Map<String, dynamic>) {
//       throw FormatException('Grok response does not contain a valid message.');
//     }
//
//     final content = message['content'];
//     if (content is String) {
//       if (content.trim().isEmpty) {
//         throw FormatException('Grok response text is empty.');
//       }
//       return content;
//     }
//
//     if (content is List) {
//       final text = content
//           .map((item) => item is Map ? item['text']?.toString() ?? '' : '')
//           .join();
//       if (text.trim().isNotEmpty) {
//         return text;
//       }
//     }
//
//     throw FormatException('Grok response does not contain text content.');
//   }
//
//   static String _buildPrompt({
//     required String fileName,
//     required String category,
//     required String seniority,
//     required String resumeText,
//   }) {
//     return '''
// Analyze the following resume text for a job in $category at the $seniority level.
//
// Resume filename: $fileName
//
// Resume content:
// $resumeText
//
// Return a JSON object with keys: score, strengths, weaknesses, suggestions.
// - score: integer 0-100
// - strengths: array of 3-5 short bullets
// - weaknesses: array of 3-5 short bullets
// - suggestions: array of 3-5 specific recommendations
//
// Return only valid JSON.
// ''';
//   }
//
//   static Map<String, dynamic> _parseResponse(
//     String message, {
//     required String fileName,
//     required String category,
//     required String seniority,
//     }) {
//     final trimmed = message.trim();
//     final jsonStart = trimmed.indexOf('{');
//     final jsonEnd = trimmed.lastIndexOf('}');
//
//     if (jsonStart < 0 || jsonEnd < jsonStart) {
//       throw FormatException('Grok response is not valid JSON.');
//     }
//
//     final jsonString = trimmed.substring(jsonStart, jsonEnd + 1);
//     final responseJson = jsonDecode(jsonString) as Map<String, dynamic>;
//
//     return {
//       'fileName': fileName,
//       'category': category,
//       'seniority': seniority,
//       'score': responseJson['score'] as int? ?? 0,
//       'strengths': List<String>.from(
//         responseJson['strengths'] as List<dynamic>? ?? [],
//       ),
//       'weaknesses': List<String>.from(
//         responseJson['weaknesses'] as List<dynamic>? ?? [],
//       ),
//       'suggestions': List<String>.from(
//         responseJson['suggestions'] as List<dynamic>? ?? [],
//       ),
//     };
//   }
// }
