import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/upload_controller.dart';
import 'home_view.dart';
import 'upload_view.dart';
import 'history_view.dart';
import 'profile_view.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<DashboardController>()) {
      Get.put(DashboardController());
    }
    if (!Get.isRegistered<UploadController>()) {
      Get.put(UploadController());
    }

    final pages = const [
      HomeView(),
      UploadView(),
      HistoryView(),
      ProfileView(),
    ];

    return GetX<DashboardController>(
      builder: (controller) {
        return Scaffold(
          body: pages[controller.selectedIndex.value],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color.fromRGBO(0, 0, 0, 0.08),
                  blurRadius: 16,
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    index: 0,
                    label: 'Home',
                    icon: Icons.home_outlined,
                    controller: controller,
                  ),
                  _NavItem(
                    index: 1,
                    label: 'Upload',
                    icon: Icons.cloud_upload_outlined,
                    controller: controller,
                  ),
                  _NavItem(
                    index: 2,
                    label: 'History',
                    icon: Icons.history_rounded,
                    controller: controller,
                  ),
                  _NavItem(
                    index: 3,
                    label: 'Profile',
                    icon: Icons.person_outline,
                    controller: controller,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.index,
    required this.label,
    required this.icon,
    required this.controller,
  });

  final int index;
  final String label;
  final IconData icon;
  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => controller.changePage(index),
        child: GetX<DashboardController>(
          builder: (controller) {
            final selected = controller.selectedIndex.value == index;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 24,
                    color: selected
                        ? const Color(0xFF176D8D)
                        : Colors.grey[500],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: selected
                          ? const Color(0xFF176D8D)
                          : Colors.grey[600],
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
