import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../utils/responsive.dart';
import '../widgets/responsive_builder.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.find<DashboardController>();

    return ResponsiveBuilder(
      builder: (context, isDesktop, isTablet, isMobile) {
        return Scaffold(
          backgroundColor: const Color(0xFFE9F2F7),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: Responsive.responsivePaddingHorizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Responsive.blockSizeVertical * 2),
                  Text(
                    'ResumeAI',
                    style: TextStyle(
                      fontSize: Responsive.responsiveFontSize(28),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: Responsive.blockSizeVertical * 1),
                  Text(
                    'Resume analysis made simple',
                    style: TextStyle(
                      fontSize: Responsive.responsiveFontSize(16),
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: Responsive.blockSizeVertical * 3),
                  // Main Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(Responsive.blockSizeHorizontal * 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        Responsive.responsiveBorderRadius,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(0, 0, 0, 0.05),
                          blurRadius: 18,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Analyze your resume',
                          style: TextStyle(
                            fontSize: Responsive.responsiveFontSize(20),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: Responsive.blockSizeVertical * 1.5),
                        Text(
                          'Upload your resume and get an instant review of strengths, weaknesses, and update suggestions.',
                          style: TextStyle(
                            fontSize: Responsive.responsiveFontSize(15),
                            color: Colors.black54,
                            height: 1.6,
                          ),
                        ),
                        SizedBox(height: Responsive.blockSizeVertical * 3),
                        SizedBox(
                          width: double.infinity,
                          height: Responsive.buttonHeight,
                          child: ElevatedButton(
                            onPressed: () => dashboardController.changePage(1),
                            child: Text(
                              'Upload Resume',
                              style: TextStyle(
                                fontSize: Responsive.responsiveFontSize(16),
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Responsive.blockSizeVertical * 3),
                  // Features Section
                  Text(
                    'Features',
                    style: TextStyle(
                      fontSize: Responsive.responsiveFontSize(18),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: Responsive.blockSizeVertical * 2),
                  // Features Grid
                  isDesktop
                      ? Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  const _FeatureTile(
                                    title: 'Fast Review',
                                    description:
                                        'Static design ready for resume workflows.',
                                  ),
                                  SizedBox(
                                    height: Responsive.blockSizeVertical * 2,
                                  ),
                                  const _FeatureTile(
                                    title: 'Resume History',
                                    description:
                                        'Quick access to your previous analysis results.',
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: Responsive.blockSizeHorizontal * 3),
                            Expanded(
                              child: Column(
                                children: [
                                  const _FeatureTile(
                                    title: 'Smart Insights',
                                    description:
                                        'Strengths, weaknesses and update suggestions.',
                                  ),
                                  SizedBox(
                                    height: Responsive.blockSizeVertical * 2,
                                  ),
                                  const _FeatureTile(
                                    title: 'Profile Control',
                                    description:
                                        'Manage your account and settings easily.',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : isTablet
                      ? Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: const _FeatureTile(
                                    title: 'Fast Review',
                                    description:
                                        'Static design ready for resume workflows.',
                                  ),
                                ),
                                SizedBox(
                                  width: Responsive.blockSizeHorizontal * 3,
                                ),
                                Expanded(
                                  child: const _FeatureTile(
                                    title: 'Smart Insights',
                                    description:
                                        'Strengths, weaknesses and update suggestions.',
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: Responsive.blockSizeVertical * 2),
                            Row(
                              children: [
                                Expanded(
                                  child: const _FeatureTile(
                                    title: 'Resume History',
                                    description:
                                        'Quick access to your previous analysis results.',
                                  ),
                                ),
                                SizedBox(
                                  width: Responsive.blockSizeHorizontal * 3,
                                ),
                                Expanded(
                                  child: const _FeatureTile(
                                    title: 'Profile Control',
                                    description:
                                        'Manage your account and settings easily.',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Column(
                          children: const [
                            _FeatureTile(
                              title: 'Fast Review',
                              description:
                                  'Static design ready for resume workflows.',
                            ),
                            SizedBox(height: 16),
                            _FeatureTile(
                              title: 'Smart Insights',
                              description:
                                  'Strengths, weaknesses and update suggestions.',
                            ),
                            SizedBox(height: 16),
                            _FeatureTile(
                              title: 'Resume History',
                              description:
                                  'Quick access to your previous analysis results.',
                            ),
                            SizedBox(height: 16),
                            _FeatureTile(
                              title: 'Profile Control',
                              description:
                                  'Manage your account and settings easily.',
                            ),
                          ],
                        ),
                  SizedBox(height: Responsive.blockSizeVertical * 3),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Responsive.blockSizeHorizontal * 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Responsive.responsiveBorderRadius),
        boxShadow: [
          BoxShadow(color: const Color.fromRGBO(0, 0, 0, 0.05), blurRadius: 14),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: Responsive.responsiveFontSize(16),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: Responsive.blockSizeVertical * 1),
          Text(
            description,
            style: TextStyle(
              fontSize: Responsive.responsiveFontSize(14),
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
