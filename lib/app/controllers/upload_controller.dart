import 'package:get/get.dart';
import '../routes/app_routes.dart';

class UploadController extends GetxController {
  final selectedCategory = 'Software Engineering'.obs;
  final selectedSeniority = 'Senior'.obs;
  final categories = <String>[
    'Software Engineering',
    'Data Science',
    'Product Management',
  ].obs;
  final seniorities = <String>['Junior', 'Mid', 'Senior', 'Lead'].obs;

  void analyze() {
    Get.toNamed(AppRoutes.analysis, arguments: {'fileName': 'John Doe.pdf'});
  }
}
