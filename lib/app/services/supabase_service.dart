import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config_service.dart';

class SupabaseService {
  static const String _supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );
  static const String _supabasePublishableKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  static bool get isConfigured {
    final configService = ConfigService.to;
    final envUrl = _supabaseUrl.isNotEmpty ? _supabaseUrl : '';
    final envKey = _supabasePublishableKey.isNotEmpty
        ? _supabasePublishableKey
        : '';

    return (envUrl.isNotEmpty && envKey.isNotEmpty) ||
        (configService.supabaseUrl.value.isNotEmpty &&
            configService.supabaseKey.value.isNotEmpty);
  }

  static Future<void> initialize() async {
    final configService = ConfigService.to;

    // Priority: environment variables > config service
    String url = _supabaseUrl.isNotEmpty
        ? _supabaseUrl
        : configService.supabaseUrl.value;
    String key = _supabasePublishableKey.isNotEmpty
        ? _supabasePublishableKey
        : configService.supabaseKey.value;

    debugPrint('=== Supabase Initialization ===');
    debugPrint('URL: ${url.isEmpty ? "NOT SET" : url}');
    debugPrint('Key: ${key.isEmpty ? "NOT SET" : "SET"}');
    debugPrint('Using env vars: ${_supabaseUrl.isNotEmpty}');

    if (url.isEmpty || key.isEmpty) {
      debugPrint('ERROR: Supabase not configured!');
      debugPrint(
        'Add credentials via: flutter run --dart-define=SUPABASE_URL=https://your-project.supabase.co --dart-define=SUPABASE_ANON_KEY=your-anon-key',
      );
      debugPrint('OR set in ConfigService.setSupabaseCredentials()');
      return;
    }

    try {
      await Supabase.initialize(url: url, publishableKey: key);
      debugPrint('✓ Supabase initialized successfully');
    } catch (e) {
      debugPrint('✗ Supabase initialization failed: $e');
    }
  }

  static SupabaseClient get client => Supabase.instance.client;
}
