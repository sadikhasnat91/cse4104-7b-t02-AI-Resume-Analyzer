import 'package:ai_resume_analyzer/app/services/gemini_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GeminiService request config', () {
    test('builds the Gemini generateContent endpoint', () {
      final uri = GeminiService.buildRequestUri('gemini-2.0-flash');

      expect(
        uri.toString(),
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent',
      );
    });

    test('adds the API key and content type headers', () {
      final headers = GeminiService.buildHeaders('test-api-key');

      expect(headers['Content-Type'], 'application/json');
      expect(headers['x-goog-api-key'], 'test-api-key');
    });
  });
}
