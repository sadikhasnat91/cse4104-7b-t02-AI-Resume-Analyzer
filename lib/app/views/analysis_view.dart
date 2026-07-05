import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../utils/responsive.dart';
import '../widgets/responsive_builder.dart';

class AnalysisView extends StatelessWidget {
  const AnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final fileName = args?['fileName'] as String? ?? 'resume.pdf';
    final category = args?['category'] as String? ?? 'Software Engineering';
    final seniority = args?['seniority'] as String? ?? 'Senior';
    final score = args?['score'] as int? ?? 78;
    final strengths = (args?['strengths'] as List?) ?? [];
    final weaknesses = (args?['weaknesses'] as List?) ?? [];
    final suggestions = (args?['suggestions'] as List?) ?? [];

    return ResponsiveBuilder(
      builder: (context, isDesktop, isTablet, isMobile) {
        return Scaffold(
          backgroundColor: const Color(0xFFE9F2F7),
          body: SafeArea(
            child: Padding(
              padding: Responsive.responsivePaddingHorizontal,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Responsive.blockSizeVertical * 1),
                    // Back Button and Title
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.black87,
                            size: Responsive.responsiveFontSize(20),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Analysis Results',
                                style: TextStyle(
                                  fontSize: Responsive.responsiveFontSize(22),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                fileName,
                                style: TextStyle(
                                  fontSize: Responsive.responsiveFontSize(12),
                                  color: Colors.black54,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Responsive.blockSizeVertical * 2),
                    // Info Cards
                    Row(
                      children: [
                        Expanded(
                          child: _InfoCard(
                            label: 'Category',
                            value: category,
                            icon: Icons.work_outline,
                          ),
                        ),
                        SizedBox(width: Responsive.blockSizeHorizontal * 2),
                        Expanded(
                          child: _InfoCard(
                            label: 'Level',
                            value: seniority,
                            icon: Icons.trending_up,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Responsive.blockSizeVertical * 2),
                    // Score Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(
                        Responsive.blockSizeHorizontal * 5,
                      ),
                      decoration: BoxDecoration(
                        color: _getScoreColor(score),
                        borderRadius: BorderRadius.circular(
                          Responsive.responsiveBorderRadius,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _getScoreColor(score).withValues(alpha: 0.3),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Resume Score',
                            style: TextStyle(
                              fontSize: Responsive.responsiveFontSize(14),
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: Responsive.blockSizeVertical * 1),
                          Text(
                            '$score%',
                            style: TextStyle(
                              fontSize: Responsive.responsiveFontSize(48),
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Responsive.blockSizeVertical * 2.5),
                    // Strengths Section
                    Text(
                      'Strengths',
                      style: TextStyle(
                        fontSize: Responsive.responsiveFontSize(18),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: Responsive.blockSizeVertical * 1),
                    _ResultSection(
                      items: strengths.cast<String>(),
                      backgroundColor: const Color(0xFFD5E9CC),
                      icon: Icons.check_circle,
                      iconColor: const Color(0xFF4CAF50),
                    ),
                    SizedBox(height: Responsive.blockSizeVertical * 2.5),
                    // Weaknesses Section
                    Text(
                      'Areas for Improvement',
                      style: TextStyle(
                        fontSize: Responsive.responsiveFontSize(18),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: Responsive.blockSizeVertical * 1),
                    _ResultSection(
                      items: weaknesses.cast<String>(),
                      backgroundColor: const Color(0xFFF4C3A6),
                      icon: Icons.warning_outlined,
                      iconColor: const Color(0xFFFF9800),
                    ),
                    SizedBox(height: Responsive.blockSizeVertical * 2.5),
                    // Suggestions Section
                    Text(
                      'Recommendations',
                      style: TextStyle(
                        fontSize: Responsive.responsiveFontSize(18),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: Responsive.blockSizeVertical * 1),
                    _ResultSection(
                      items: suggestions.cast<String>(),
                      backgroundColor: const Color(0xFFB6DCF2),
                      icon: Icons.lightbulb_outline,
                      iconColor: const Color(0xFF2196F3),
                    ),
                    SizedBox(height: Responsive.blockSizeVertical * 2.5),
                    // Action Buttons
                    SizedBox(
                      width: double.infinity,
                      height: Responsive.buttonHeight,
                      child: ElevatedButton(
                        onPressed: () => Get.offAllNamed(AppRoutes.dashboard),
                        child: Text(
                          'Back to Dashboard',
                          style: TextStyle(
                            fontSize: Responsive.responsiveFontSize(16),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: Responsive.blockSizeVertical * 1),
                    SizedBox(
                      width: double.infinity,
                      height: Responsive.buttonHeight,
                      child: OutlinedButton(
                        onPressed: () => Get.toNamed(AppRoutes.upload),
                        child: Text(
                          'Analyze Another Resume',
                          style: TextStyle(
                            fontSize: Responsive.responsiveFontSize(16),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: Responsive.blockSizeVertical * 2),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 85) return const Color(0xFF4CAF50); // Green
    if (score >= 70) return const Color(0xFF2196F3); // Blue
    if (score >= 50) return const Color(0xFFFFC107); // Amber
    return const Color(0xFFF44336); // Red
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Responsive.blockSizeHorizontal * 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Responsive.responsiveBorderRadius),
        boxShadow: [
          BoxShadow(color: const Color.fromRGBO(0, 0, 0, 0.05), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: Responsive.responsiveFontSize(16),
                color: const Color(0xFF176D8D),
              ),
              SizedBox(width: Responsive.blockSizeHorizontal * 2),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: Responsive.responsiveFontSize(12),
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.blockSizeVertical * 0.8),
          Text(
            value,
            style: TextStyle(
              fontSize: Responsive.responsiveFontSize(14),
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ResultSection extends StatelessWidget {
  const _ResultSection({
    required this.items,
    required this.backgroundColor,
    required this.icon,
    required this.iconColor,
  });

  final List<String> items;
  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.blockSizeHorizontal * 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(Responsive.responsiveBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.isNotEmpty
            ? items
                  .map(
                    (item) => Padding(
                      padding: EdgeInsets.only(
                        bottom: Responsive.blockSizeVertical * 1,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: Responsive.blockSizeVertical * 0.3,
                              right: Responsive.blockSizeHorizontal * 2,
                            ),
                            child: Icon(
                              icon,
                              size: Responsive.responsiveFontSize(18),
                              color: iconColor,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              item,
                              style: TextStyle(
                                fontSize: Responsive.responsiveFontSize(14),
                                color: Colors.black87,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList()
            : [
                Text(
                  'No items to display',
                  style: TextStyle(
                    fontSize: Responsive.responsiveFontSize(14),
                    color: Colors.black54,
                  ),
                ),
              ],
      ),
    );
  }
}
