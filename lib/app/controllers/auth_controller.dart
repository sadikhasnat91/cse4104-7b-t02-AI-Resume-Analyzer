import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../routes/app_routes.dart';
import '../services/supabase_service.dart';
import '../services/message_service.dart';

class AuthController extends GetxController {
  final email = ''.obs;
  final password = ''.obs;
  final name = ''.obs;
  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  Future<void> login() async {
    if (loginFormKey.currentState?.validate() ?? false) {
      if (!SupabaseService.isConfigured) {
        await MessageService.showError(
          title: 'Configuration Error',
          message: 'Supabase is not configured. Please check your credentials.',
          showRetry: true,
          onRetry: login,
        );
        return;
      }

      try {
        isLoading.value = true;

        final response = await SupabaseService.auth.signInWithPassword(
          email: email.value.trim(),
          password: password.value.trim(),
        );

        if (response.session == null) {
          throw AuthException(
            'Unable to sign in. Please verify your credentials.',
          );
        }

        await MessageService.showSuccess(
          title: 'Login Successful',
          message: 'Welcome back! Redirecting to dashboard...',
          onConfirm: () => Get.offAllNamed(AppRoutes.dashboard),
        );
      } on AuthException catch (e) {
        await MessageService.showError(
          title: 'Login Failed',
          message: _authErrorMessage(e),
          showRetry: true,
          onRetry: login,
        );
      } on Exception catch (e) {
        await MessageService.showError(
          title: 'Login Failed',
          message: _authErrorMessage(e),
          showRetry: true,
          onRetry: login,
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
          await MessageService.showError(
            title: 'Configuration Error',
            message:
                'Supabase is not configured. Please check your credentials.',
            showRetry: true,
            onRetry: signup,
          );
          return;
        }

        final response = await SupabaseService.auth.signUp(
          email: email.value.trim(),
          password: password.value.trim(),
          data: {'full_name': name.value.trim()},
        );

        if (response.user != null) {
          if (response.session == null) {
            await MessageService.showInfo(
              title: 'Verification Required',
              message:
                  'Account created successfully. Check your email to confirm your account before logging in.',
              icon: Icons.mail_outline,
              iconColor: const Color(0xFF2196F3),
            );
          } else {
            await MessageService.showSuccess(
              title: 'Account Created',
              message:
                  'Your account has been created successfully! Please log in.',
              onConfirm: () => Get.offAllNamed(AppRoutes.login),
            );
          }
        } else {
          throw AuthException('Unable to create account. Please try again.');
        }
      } on AuthException catch (e) {
        await MessageService.showError(
          title: 'Signup Failed',
          message: _authErrorMessage(e),
          showRetry: true,
          onRetry: signup,
        );
      } on Exception catch (e) {
        await MessageService.showError(
          title: 'Signup Failed',
          message: _authErrorMessage(e),
          showRetry: true,
          onRetry: signup,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  String _authErrorMessage(Object error) {
    final message = error.toString();
    if (message.contains('Could not resolve host') ||
        message.contains('XMLErrorRequest') ||
        message.contains('NetworkError') ||
        message.contains('Failed host lookup')) {
      return 'Unable to connect to Supabase. Please verify your Supabase URL, network connectivity, and that the project URL is correct.';
    }

    return 'Error: $message\n\nMake sure your Supabase URL and key are correct.';
  }
}
