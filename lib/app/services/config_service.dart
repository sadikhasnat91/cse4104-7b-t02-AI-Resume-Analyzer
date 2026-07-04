import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ConfigService extends GetxService {
  static const String defaultSupabaseUrl = '';
  static const String defaultSupabaseKey = '';

  final supabaseUrl = defaultSupabaseUrl.obs;
  final supabaseKey = defaultSupabaseKey.obs;

  static ConfigService get to => Get.find();

  bool get isConfigured =>
      supabaseUrl.value.isNotEmpty && supabaseKey.value.isNotEmpty;

  void setSupabaseCredentials({required String url, required String anonKey}) {
    supabaseUrl.value = url;
    supabaseKey.value = anonKey;
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
