import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ConfigService extends GetxService {
  static const String defaultSupabaseUrl = '';
  static const String defaultSupabaseKey = '';
  static const String defaultGeminiKey = '';

  final supabaseUrl = defaultSupabaseUrl.obs;
  final supabaseKey = defaultSupabaseKey.obs;
  final geminiApiKey = defaultGeminiKey.obs;

  static ConfigService get to => Get.find();

  bool get isConfigured =>
      supabaseUrl.value.isNotEmpty && supabaseKey.value.isNotEmpty;

  void setSupabaseCredentials({required String url, required String anonKey}) {
    supabaseUrl.value = url;
    supabaseKey.value = anonKey;
  }

  void setGeminiApiKey(String apiKey) {
    geminiApiKey.value = apiKey;
  }

  void printCurrentConfig() {
    debugPrint('=== Supabase Configuration ===');
    debugPrint(
      'URL: ${supabaseUrl.value.isEmpty ? "NOT SET" : supabaseUrl.value}',
    );
    debugPrint('Key: ${supabaseKey.value.isEmpty ? "NOT SET" : "SET"}');
    debugPrint('Configured: $isConfigured');
    debugPrint('==============================');
  }
}
