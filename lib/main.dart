import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/services/config_service.dart';
import 'app/services/supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final configService = Get.put(ConfigService());

  // ✅ Local Supabase credentials (for development)
  configService.setSupabaseCredentials(
    url: 'https://iyjnvtjblstpaovwhxdr.supabase.co',
    anonKey: 'sb_publishable_oRTNqJBOzAXg7SMwVeYp0Q_eO3qZySn',
  );

  configService.printCurrentConfig();

  await SupabaseService.initialize();

  runApp(const ResumeAnalyzerApp());
}

class ResumeAnalyzerApp extends StatelessWidget {
  const ResumeAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ResumeAI',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFE9F2F7),
        primaryColor: const Color(0xFF176D8D),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF176D8D),
          primary: const Color(0xFF176D8D),
          onPrimary: Colors.white,
          surface: const Color(0xFFE9F2F7),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFF176D8D)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF176D8D),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
        ),
      ),
      initialRoute: '/login',
      getPages: AppPages.pages,
    );
  }
}
