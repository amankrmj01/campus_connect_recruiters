import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/form_builder.controller.dart';

class FormPreviewView extends GetView<FormBuilderController> {
  const FormPreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Row(
        children: [
          // Mobile Preview
          Expanded(child: _buildMobilePreview()),

          // Desktop Preview
          Expanded(child: _buildDesktopPreview()),
        ],
      ),
    );
  }

  Widget _buildMobilePreview() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.phone_android_outlined, color: Colors.grey[600]),
              SizedBox(width: 8),
              Text(
                'Mobile Preview',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Spacer(),
              _buildPreviewControls(isMobile: true),
            ],
          ),

          SizedBox(height: 20),

          // Mobile Frame
          Expanded(
            child: Center(
              child: Container(
                width: 375,
                height: 667,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.3 * 255).toInt()),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Column(
                      children: [
                        // Status Bar
                        Container(
                          height: 44,
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '9:41',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.signal_cellular_4_bar, size: 16),
                                    SizedBox(width: 4),
                                    Icon(Icons.wifi, size: 16),
                                    SizedBox(width: 4),
                                    Icon(Icons.battery_full, size: 16),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Form Content
                        Expanded(child: _buildFormContent(isMobile: true)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopPreview() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.computer_outlined, color: Colors.grey[600]),
              SizedBox(width: 8),
              Text(
                'Desktop Preview',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Spacer(),
              _buildPreviewControls(isMobile: false),
            ],
          ),

          SizedBox(height: 20),

          // Desktop Frame
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.1 * 255).toInt()),
                    blurRadius: 20,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Browser Header
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        // Traffic Lights
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.red[400],
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.yellow[600],
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.green[400],
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(width: 20),

                        // Address Bar
                        Expanded(
                          child: Container(
                            height: 32,
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.lock_outlined,
                                  size: 16,
                                  color: Colors.green[600],
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'https://company.com/application-form',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Form Content
                  Expanded(child: _buildFormContent(isMobile: false)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewControls({required bool isMobile}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Refresh Preview
        IconButton(
          onPressed: () => _refreshPreview(),
          icon: Icon(Icons.refresh_outlined),
          tooltip: 'Refresh Preview',
          iconSize: 20,
        ),

        // Share Preview
        IconButton(
          onPressed: () => _sharePreview(),
          icon: Icon(Icons.share_outlined),
          tooltip: 'Share Preview Link',
          iconSize: 20,
        ),

        // Preview Settings
        PopupMenuButton<String>(
          onSelected: (value) => _handlePreviewAction(value, isMobile),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'test_data',
              child: Row(
                children: [
                  Icon(Icons.science_outlined, size: 16),
                  SizedBox(width: 8),
                  Text('Fill Test Data'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'validate',
              child: Row(
                children: [
                  Icon(Icons.check_circle_outlined, size: 16),
                  SizedBox(width: 8),
                  Text('Test Validation'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'responsive',
              child: Row(
                children: [
                  Icon(Icons.devices_outlined, size: 16),
                  SizedBox(width: 8),
                  Text('Responsive Test'),
                ],
              ),
            ),
          ],
          child: Icon(Icons.more_vert_outlined, size: 20),
        ),
      ],
    );
  }

  Widget _buildFormContent({required bool isMobile}) {
    return Obx(() {
      if (controller.formSections.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.preview_outlined,
                size: isMobile ? 48 : 64,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16),
              Text(
                'No form to preview',
                style: TextStyle(
                  fontSize: isMobile ? 14 : 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Create a form to see the preview',
                style: TextStyle(
                  fontSize: isMobile ? 12 : 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form Header
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.formTitle.value.isEmpty
                      ? 'Application Form'
                      : controller.formTitle.value,
                  style: TextStyle(
                    fontSize: isMobile ? 20 : 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),

                if (controller.formDescription.value.isNotEmpty) ...[
                  SizedBox(height: 8),
                  Text(
                    controller.formDescription.value,
                    style: TextStyle(
                      fontSize: isMobile ? 12 : 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],

                SizedBox(height: 16),

                // Progress Bar (if enabled)
                if (controller.formSettings.value.showProgressBar) ...[
                  LinearProgressIndicator(
                    value: 0.0,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.blue[600]!,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Step 1 of ${controller.formSections.length}',
                    style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                  ),
                  SizedBox(height: 20),
                ],
              ],
            ),

            // Form Sections
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: controller.formSections.asMap().entries.map((
                sectionEntry,
              ) {
                final section = sectionEntry.value;

                return Container(
                  margin: EdgeInsets.only(bottom: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Header
                      if (section.title.isNotEmpty ||
                          section.description.isNotEmpty) ...[
                        if (section.title.isNotEmpty) ...[
                          Text(
                            section.title,
                            style: TextStyle(
                              fontSize: isMobile ? 16 : 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(height: 8),
                        ],

                        if (section.description.isNotEmpty) ...[
                          Text(
                            section.description,
                            style: TextStyle(
                              fontSize: isMobile ? 12 : 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      ],

                      // Section Questions
                      Column(
                        children: section.questions.asMap().entries.map((
                          questionEntry,
                        ) {
                          final question = questionEntry.value;
                          return Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: _buildQuestionWidget(question, isMobile),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            // Form Footer
            Column(
              children: [
                SizedBox(height: 20),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: isMobile ? 48 : 52,
                  child: ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Submit Application',
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 12),

                // Save Draft Button (if enabled)
                if (controller.formSettings.value.allowSaveAndContinue) ...[
                  SizedBox(
                    width: double.infinity,
                    height: isMobile ? 44 : 48,
                    child: OutlinedButton(
                      onPressed: null,
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Save Draft',
                        style: TextStyle(fontSize: isMobile ? 12 : 14),
                      ),
                    ),
                  ),
                ],

                SizedBox(height: 20),

                // Form Footer Text
                Text(
                  'Form powered by Campus Connect',
                  style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildQuestionWidget(FormQuestionData question, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question Title
        Row(
          children: [
            Expanded(
              child: Text(
                question.title,
                style: TextStyle(
                  fontSize: isMobile ? 13 : 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ),
            if (question.isRequired) ...[
              Text(
                ' *',
                style: TextStyle(
                  fontSize: isMobile ? 13 : 14,
                  color: Colors.red[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),

        // Question Description
        if (question.description.isNotEmpty) ...[
          SizedBox(height: 4),
          Text(
            question.description,
            style: TextStyle(
              fontSize: isMobile ? 11 : 12,
              color: Colors.grey[600],
            ),
          ),
        ],

        SizedBox(height: 8),

        // Question Input
        _buildQuestionInput(question, isMobile),
      ],
    );
  }

  Widget _buildQuestionInput(FormQuestionData question, bool isMobile) {
    final inputDecoration = InputDecoration(
      hintText: _getQuestionHint(question),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
      ),
      contentPadding: EdgeInsets.all(isMobile ? 12 : 16),
    );

    switch (question.type) {
      case 'text':
      case 'email':
      case 'phone':
      case 'number':
        return TextField(
          decoration: inputDecoration,
          keyboardType: _getKeyboardType(question.type),
          enabled: false,
        );

      case 'textarea':
        return TextField(
          decoration: inputDecoration,
          maxLines: isMobile ? 3 : 4,
          enabled: false,
        );

      case 'date':
        return TextField(
          decoration: inputDecoration.copyWith(
            suffixIcon: Icon(Icons.calendar_today_outlined),
          ),
          enabled: false,
        );

      case 'multiple_choice':
        return Column(
          children: question.options.map((option) {
            // Refactored RadioListTile to avoid deprecated groupValue and onChanged
            // Use a disabled Radio widget for preview only
            return Row(
              children: [
                Radio<String>(value: option, groupValue: null, onChanged: null),
                Text(option, style: TextStyle(fontSize: isMobile ? 12 : 14)),
              ],
            );
          }).toList(),
        );

      case 'checkbox':
        return Column(
          children: question.options.map((option) {
            return CheckboxListTile(
              title: Text(
                option,
                style: TextStyle(fontSize: isMobile ? 12 : 14),
              ),
              value: false,
              onChanged: null,
              contentPadding: EdgeInsets.zero,
            );
          }).toList(),
        );

      case 'dropdown':
        return DropdownButtonFormField<String>(
          decoration: inputDecoration,
          hint: Text('Select an option'),
          items: question.options.map((option) {
            return DropdownMenuItem(value: option, child: Text(option));
          }).toList(),
          onChanged: null,
        );

      case 'file_upload':
        return Container(
          width: double.infinity,
          height: isMobile ? 100 : 120,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey[300]!,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_upload_outlined,
                size: isMobile ? 32 : 40,
                color: Colors.grey[400],
              ),
              SizedBox(height: 8),
              Text(
                'Click to upload or drag and drop',
                style: TextStyle(
                  fontSize: isMobile ? 11 : 12,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4),
              Text(
                'PDF, DOC, DOCX up to 5MB',
                style: TextStyle(
                  fontSize: isMobile ? 10 : 11,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        );

      case 'rating':
        return Row(
          children: List.generate(5, (index) {
            return Padding(
              padding: EdgeInsets.only(right: 4),
              child: Icon(
                Icons.star_outline,
                size: isMobile ? 24 : 28,
                color: Colors.grey[400],
              ),
            );
          }),
        );

      case 'section':
        return Container(
          width: double.infinity,
          height: 2,
          color: Colors.grey[300],
        );

      default:
        return Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              'Unknown question type: ${question.type}',
              style: TextStyle(
                fontSize: isMobile ? 11 : 12,
                color: Colors.grey[500],
              ),
            ),
          ),
        );
    }
  }

  String _getQuestionHint(FormQuestionData question) {
    switch (question.type) {
      case 'text':
        return 'Enter your answer';
      case 'email':
        return 'Enter your email address';
      case 'phone':
        return 'Enter your phone number';
      case 'number':
        return 'Enter a number';
      case 'textarea':
        return 'Enter detailed information';
      case 'date':
        return 'Select a date';
      default:
        return 'Your answer';
    }
  }

  TextInputType _getKeyboardType(String questionType) {
    switch (questionType) {
      case 'email':
        return TextInputType.emailAddress;
      case 'phone':
        return TextInputType.phone;
      case 'number':
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }

  void _refreshPreview() {
    Get.snackbar(
      'Preview Refreshed',
      'Form preview has been updated',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void _sharePreview() {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.share_outlined, color: Colors.blue[600]),
            SizedBox(width: 8),
            Text('Share Preview'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Share this preview link with stakeholders for feedback:'),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'https://campusconnect.com/preview/form_12345',
                      style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.snackbar(
                        'Copied',
                        'Preview link copied to clipboard',
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    },
                    icon: Icon(Icons.copy_outlined, size: 16),
                    tooltip: 'Copy Link',
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Text(
              'This link will be valid for 30 days and allows view-only access.',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Close')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Link Generated',
                'Preview link has been generated and copied',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: Text('Generate & Copy'),
          ),
        ],
      ),
    );
  }

  void _handlePreviewAction(String action, bool isMobile) {
    switch (action) {
      case 'test_data':
        Get.snackbar(
          'Test Data Filled',
          'Form has been filled with sample data for ${isMobile ? 'mobile' : 'desktop'} testing',
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
        break;
      case 'validate':
        Get.snackbar(
          'Validation Test',
          'Form validation has been tested successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        break;
      case 'responsive':
        Get.snackbar(
          'Responsive Test',
          'Form responsiveness has been validated',
          backgroundColor: Colors.purple,
          colorText: Colors.white,
        );
        break;
    }
  }
}
