import 'package:get/get.dart';
import '../views/analysis_view.dart';
import '../views/dashboard_view.dart';
import '../views/login_view.dart';
import '../views/signup_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.login, page: () => const LoginView()),
    GetPage(name: AppRoutes.signup, page: () => const SignupView()),
    GetPage(name: AppRoutes.dashboard, page: () => const DashboardView()),
    GetPage(name: AppRoutes.analysis, page: () => const AnalysisView()),
  ];
}
