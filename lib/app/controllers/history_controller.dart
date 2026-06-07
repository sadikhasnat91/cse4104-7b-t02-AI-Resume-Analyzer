import 'package:get/get.dart';
import '../models/resume_item.dart';

class HistoryController extends GetxController {
  final resumes = <ResumeItem>[
    ResumeItem(name: 'JohnDoe_SE.pdf', date: 'Oct 26, ’24', score: '78%'),
    ResumeItem(name: 'Sarah_MK.pdf', date: 'Oct 24, ’24', score: '84%'),
    ResumeItem(name: 'Michael_DS.pdf', date: 'Oct 20, ’24', score: '72%'),
  ].obs;
}
