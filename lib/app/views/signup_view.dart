import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../utils/responsive.dart';
import '../widgets/responsive_builder.dart';
import '../widgets/loading_spinner.dart';

class SignupView extends GetView<AuthController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    return ResponsiveBuilder(
      builder: (context, isDesktop, isTablet, isMobile) {
        return Scaffold(
          body: LoadingOverlay(
            isLoading: controller.isLoading.value,
            message: 'Creating account...',
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: Responsive.responsivePaddingHorizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: Responsive.maxContentWidth,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: Responsive.blockSizeVertical * 4),
                        Center(
                          child: Icon(
                            Icons.insert_drive_file,
                            size: Responsive.responsiveFontSize(68),
                            color: const Color(0xFF176D8D),
                          ),
                        ),
                        SizedBox(height: Responsive.blockSizeVertical * 2),
                        Text(
                          'ResumeAI Analyser',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: Responsive.responsiveFontSize(24),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: Responsive.blockSizeVertical * 2),
                        Text(
                          'Create Account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: Responsive.responsiveFontSize(22),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: Responsive.blockSizeVertical * 4),
                        Form(
                          key: controller.signupFormKey,
                          child: Column(
                            children: [
                              TextFormField(
                                onChanged: (value) =>
                                    controller.name.value = value,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.person_outline),
                                  hintText: 'Name',
                                ),
                                validator: (value) => value?.isEmpty == true
                                    ? 'Enter your name'
                                    : null,
                              ),
                              SizedBox(
                                height: Responsive.blockSizeVertical * 2,
                              ),
                              TextFormField(
                                onChanged: (value) =>
                                    controller.email.value = value,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.email_outlined),
                                  hintText: 'Email',
                                ),
                                validator: (value) => value?.isEmpty == true
                                    ? 'Enter your email'
                                    : null,
                              ),
                              SizedBox(
                                height: Responsive.blockSizeVertical * 2,
                              ),
                              TextFormField(
                                onChanged: (value) =>
                                    controller.password.value = value,
                                obscureText: true,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  hintText: 'Password',
                                ),
                                validator: (value) => value?.isEmpty == true
                                    ? 'Enter a password'
                                    : null,
                              ),
                              SizedBox(
                                height: Responsive.blockSizeVertical * 3,
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: Responsive.buttonHeight,
                                child: Obx(
                                  () => ElevatedButton(
                                    onPressed: controller.isLoading.value
                                        ? null
                                        : controller.signup,
                                    child: controller.isLoading.value
                                        ? const LoadingButtonIndicator()
                                        : Text(
                                            'Sign Up',
                                            style: TextStyle(
                                              fontSize:
                                                  Responsive.responsiveFontSize(
                                                    16,
                                                  ),
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Responsive.blockSizeVertical * 2),
                        Center(
                          child: GestureDetector(
                            onTap: () => Get.back(),
                            child: const Text(
                              'Already have an account? Login',
                              style: TextStyle(
                                color: Color(0xFF176D8D),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: Responsive.blockSizeVertical * 4),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
