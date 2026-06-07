import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final email = ''.obs;
  final password = ''.obs;
  final name = ''.obs;
  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();

  void login() {
    if (loginFormKey.currentState?.validate() ?? false) {
      Get.offAllNamed(AppRoutes.dashboard);
    }
  }

  void signup() {
    if (signupFormKey.currentState?.validate() ?? false) {
      Get.offAllNamed(AppRoutes.dashboard);
    }
  }
}
