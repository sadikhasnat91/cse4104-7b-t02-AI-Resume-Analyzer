import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../services/supabase_service.dart';

class AuthController extends GetxController {
  final email = ''.obs;
  final password = ''.obs;
  final name = ''.obs;
  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  Future<void> login() async {
    if (loginFormKey.currentState?.validate() ?? false) {
      try {
        isLoading.value = true;
        if (!SupabaseService.isConfigured) {
          Get.snackbar(
            'Supabase not configured',
            'Add credentials: flutter run --dart-define=SUPABASE_URL=your_url --dart-define=SUPABASE_ANON_KEY=your_key',
            duration: const Duration(seconds: 5),
          );
          return;
        }

        await SupabaseService.client.auth.signInWithPassword(
          email: email.value.trim(),
          password: password.value,
        );
        Get.offAllNamed(AppRoutes.dashboard);
      } on Exception catch (e) {
        Get.snackbar(
          'Login failed',
          'Error: ${e.toString()}',
          duration: const Duration(seconds: 5),
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> signup() async {
    if (signupFormKey.currentState?.validate() ?? false) {
      try {
        isLoading.value = true;
        if (!SupabaseService.isConfigured) {
          Get.snackbar(
            'Supabase not configured',
            'Add credentials: flutter run --dart-define=SUPABASE_URL=your_url --dart-define=SUPABASE_ANON_KEY=your_key',
            duration: const Duration(seconds: 5),
          );
          return;
        }

        final response = await SupabaseService.client.auth.signUp(
          email: email.value.trim(),
          password: password.value,
          data: {'full_name': name.value.trim()},
        );

        if (response.user != null) {
          Get.offAllNamed(AppRoutes.dashboard);
        } else {
          Get.snackbar(
            'Signup failed',
            'User created but not logged in. Check your email for confirmation.',
            duration: const Duration(seconds: 5),
          );
        }
      } on Exception catch (e) {
        Get.snackbar(
          'Signup failed',
          'Error: ${e.toString()}\n\nMake sure your Supabase URL and key are correct.',
          duration: const Duration(seconds: 5),
        );
      } finally {
        isLoading.value = false;
      }
    }
  }
}
