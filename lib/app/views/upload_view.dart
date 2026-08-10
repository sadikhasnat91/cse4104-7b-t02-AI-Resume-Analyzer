import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/upload_controller.dart';
import '../utils/responsive.dart';
import '../widgets/responsive_builder.dart';
import '../widgets/loading_spinner.dart';

class UploadView extends GetView<UploadController> {
  const UploadView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<UploadController>()) {
      Get.put(UploadController());
    }

    return ResponsiveBuilder(
      builder: (context, isDesktop, isTablet, isMobile) {
        return Scaffold(
          body: LoadingOverlay(
            isLoading: controller.isLoading.value,
            message: 'Analyzing your resume...',
            child: SafeArea(
              child: Padding(
                padding: Responsive.responsivePaddingHorizontal,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: Responsive.blockSizeVertical * 1),
                      Text(
                        'Analyze Resume',
                        style: TextStyle(
                          fontSize: Responsive.responsiveFontSize(28),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: Responsive.blockSizeVertical * 2.5),
                      // Upload Container or File Info
                      Obx(
                        () => controller.selectedFile.value == null
                            ? GestureDetector(
                                onTap: controller.pickFile,
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                    vertical: Responsive.blockSizeVertical * 3,
                                    horizontal:
                                        Responsive.blockSizeHorizontal * 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDCEAF3),
                                    borderRadius: BorderRadius.circular(
                                      Responsive.responsiveBorderRadius,
                                    ),
                                    border: Border.all(
                                      color: const Color(0xFFB5D1DE),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.upload_outlined,
                                        size: Responsive.responsiveFontSize(40),
                                        color: const Color(0xFF176D8D),
                                      ),
                                      SizedBox(
                                        height:
                                            Responsive.blockSizeVertical * 1.5,
                                      ),
                                      Text(
                                        'Tap to upload file',
                                        style: TextStyle(
                                          fontSize:
                                              Responsive.responsiveFontSize(18),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            Responsive.blockSizeVertical * 0.8,
                                      ),
                                      Text(
                                        '(PDF or Word, max 5MB)',
                                        style: TextStyle(
                                          fontSize:
                                              Responsive.responsiveFontSize(14),
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(
                                  Responsive.blockSizeHorizontal * 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    Responsive.responsiveBorderRadius,
                                  ),
                                  border: Border.all(
                                    color: const Color(0xFF4CAF50),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color.fromRGBO(
                                        76,
                                        175,
                                        80,
                                        0.1,
                                      ),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'File Selected ✓',
                                                style: TextStyle(
                                                  fontSize:
                                                      Responsive.responsiveFontSize(
                                                        14,
                                                      ),
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color(
                                                    0xFF4CAF50,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    Responsive
                                                        .blockSizeVertical *
                                                    0.8,
                                              ),
                                              Text(
                                                controller.fileName.value,
                                                style: TextStyle(
                                                  fontSize:
                                                      Responsive.responsiveFontSize(
                                                        16,
                                                      ),
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(
                                                height:
                                                    Responsive
                                                        .blockSizeVertical *
                                                    0.5,
                                              ),
                                              Text(
                                                'Size: ${(controller.selectedFile.value!.size / 1024).toStringAsFixed(2)} KB',
                                                style: TextStyle(
                                                  fontSize:
                                                      Responsive.responsiveFontSize(
                                                        13,
                                                      ),
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width:
                                              Responsive.blockSizeHorizontal *
                                              3,
                                        ),
                                        Icon(
                                          Icons.check_circle,
                                          size: Responsive.responsiveFontSize(
                                            40,
                                          ),
                                          color: const Color(0xFF4CAF50),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          Responsive.blockSizeVertical * 1.5,
                                    ),
                                    // Change or Remove Button
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextButton(
                                            onPressed: controller.pickFile,
                                            child: Text(
                                              'Change File',
                                              style: TextStyle(
                                                fontSize:
                                                    Responsive.responsiveFontSize(
                                                      14,
                                                    ),
                                                color: const Color(0xFF176D8D),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextButton(
                                            onPressed: controller.clearFile,
                                            child: Text(
                                              'Remove',
                                              style: TextStyle(
                                                fontSize:
                                                    Responsive.responsiveFontSize(
                                                      14,
                                                    ),
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      SizedBox(height: Responsive.blockSizeVertical * 2.5),
                      // Job Category
                      Text(
                        'Select Job Category',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Responsive.responsiveFontSize(16),
                        ),
                      ),
                      SizedBox(height: Responsive.blockSizeVertical * 1),
                      GetX<UploadController>(
                        builder: (controller) {
                          return DropdownButtonFormField<String>(
                            initialValue: controller.selectedCategory.value,
                            items: controller.categories
                                .map(
                                  (category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category),
                                  ),
                                )
                                .toList(),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: Responsive.blockSizeHorizontal * 4,
                                vertical: Responsive.blockSizeVertical * 2,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  Responsive.responsiveBorderRadius,
                                ),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (value) {
                              if (value != null) {
                                controller.selectedCategory.value = value;
                              }
                            },
                          );
                        },
                      ),
                      SizedBox(height: Responsive.blockSizeVertical * 2),
                      // Seniority Level
                      Text(
                        'Select Seniority Level',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Responsive.responsiveFontSize(16),
                        ),
                      ),
                      SizedBox(height: Responsive.blockSizeVertical * 1),
                      GetX<UploadController>(
                        builder: (controller) {
                          return DropdownButtonFormField<String>(
                            initialValue: controller.selectedSeniority.value,
                            items: controller.seniorities
                                .map(
                                  (level) => DropdownMenuItem(
                                    value: level,
                                    child: Text(level),
                                  ),
                                )
                                .toList(),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: Responsive.blockSizeHorizontal * 4,
                                vertical: Responsive.blockSizeVertical * 2,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  Responsive.responsiveBorderRadius,
                                ),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (value) {
                              if (value != null) {
                                controller.selectedSeniority.value = value;
                              }
                            },
                          );
                        },
                      ),
                      SizedBox(height: Responsive.blockSizeVertical * 3),
                      // Analyze Button
                      Obx(
                        () => Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: Responsive.buttonHeight,
                              child: ElevatedButton(
                                onPressed: controller.isLoading.value
                                    ? null
                                    : (controller.selectedFile.value == null
                                          ? null
                                          : controller.analyze),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      controller.selectedFile.value == null
                                      ? Colors.grey[400]
                                      : const Color(0xFF176D8D),
                                ),
                                child: controller.isLoading.value
                                    ? const LoadingButtonIndicator()
                                    : Text(
                                        'Analyze Now',
                                        style: TextStyle(
                                          fontSize:
                                              Responsive.responsiveFontSize(16),
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                            if (controller.selectedFile.value == null)
                              Padding(
                                padding: EdgeInsets.only(
                                  top: Responsive.blockSizeVertical * 1,
                                ),
                                child: Text(
                                  'Please select a resume file first',
                                  style: TextStyle(
                                    fontSize: Responsive.responsiveFontSize(12),
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: Responsive.blockSizeVertical * 2),
                    ],
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
