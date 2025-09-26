import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth.controller.dart';

class CompanyProfileSetupView extends GetView<AuthController> {
  const CompanyProfileSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Container(
          constraints: BoxConstraints(maxWidth: 600),
          child: Card(
            elevation: 20,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Obx(() {
                switch (controller.currentStep.value) {
                  case 1:
                    return _buildCompanySetupForm();
                  case 2:
                    return _buildVerificationStep();
                  default:
                    return _buildCompanySetupForm();
                }
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompanySetupForm() {
    return Form(
      key: controller.companySetupFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          _buildStepHeader(
            'Company Profile Setup',
            'Tell us about your company to complete registration',
            Icons.business_outlined,
            2,
            3,
          ),

          SizedBox(height: 32),

          // Company Name
          TextFormField(
            controller: controller.companyNameController,
            validator: (value) =>
                controller.validateRequired(value, 'Company name'),
            decoration: InputDecoration(
              labelText: 'Company Name *',
              hintText: 'Enter your company name',
              prefixIcon: Icon(Icons.business_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),

          SizedBox(height: 16),

          Row(
            children: [
              // Industry Dropdown
              Expanded(
                child: Obx(
                  () => DropdownButtonFormField<String>(
                    value: controller.selectedIndustry.value,
                    decoration: InputDecoration(
                      labelText: 'Industry *',
                      prefixIcon: Icon(Icons.factory_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    items: controller.industries.map((industry) {
                      return DropdownMenuItem(
                        value: industry,
                        child: Text(industry),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null)
                        controller.selectedIndustry.value = value;
                    },
                  ),
                ),
              ),

              SizedBox(width: 16),

              // Company Size Dropdown
              Expanded(
                child: Obx(
                  () => DropdownButtonFormField<String>(
                    value: controller.selectedCompanySize.value,
                    decoration: InputDecoration(
                      labelText: 'Company Size *',
                      prefixIcon: Icon(Icons.people_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    items: controller.companySizes.map((size) {
                      return DropdownMenuItem(value: size, child: Text(size));
                    }).toList(),
                    onChanged: (value) {
                      if (value != null)
                        controller.selectedCompanySize.value = value;
                    },
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          // Website URL
          TextFormField(
            controller: controller.companyWebsiteController,
            keyboardType: TextInputType.url,
            validator: controller.validateUrl,
            decoration: InputDecoration(
              labelText: 'Company Website *',
              hintText: 'https://yourcompany.com',
              prefixIcon: Icon(Icons.language_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),

          SizedBox(height: 16),

          // Company Phone
          TextFormField(
            controller: controller.companyPhoneController,
            keyboardType: TextInputType.phone,
            validator: controller.validatePhone,
            decoration: InputDecoration(
              labelText: 'Company Phone *',
              hintText: 'Enter company contact number',
              prefixIcon: Icon(Icons.phone_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),

          SizedBox(height: 16),

          // Company Address
          TextFormField(
            controller: controller.companyAddressController,
            maxLines: 2,
            validator: (value) =>
                controller.validateRequired(value, 'Company address'),
            decoration: InputDecoration(
              labelText: 'Company Address *',
              hintText: 'Enter complete company address',
              prefixIcon: Icon(Icons.location_on_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              alignLabelWithHint: true,
            ),
          ),

          SizedBox(height: 16),

          // Company Description
          TextFormField(
            controller: controller.companyDescriptionController,
            maxLines: 4,
            validator: (value) =>
                controller.validateRequired(value, 'Company description'),
            decoration: InputDecoration(
              labelText: 'Company Description *',
              hintText:
                  'Describe your company, what you do, and your mission...',
              prefixIcon: Padding(
                padding: EdgeInsets.only(bottom: 80),
                child: Icon(Icons.description_outlined),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              alignLabelWithHint: true,
            ),
          ),

          SizedBox(height: 24),

          // Additional Information Card
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outlined, color: Colors.blue[600]),
                    SizedBox(width: 8),
                    Text(
                      'Verification Requirements',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  '• Your company profile will be reviewed by our admin team\n'
                  '• Verification typically takes 24-48 hours\n'
                  '• You\'ll receive an email once verification is complete\n'
                  '• Ensure all information is accurate to avoid delays',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.blue[700],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 32),

          // Action Buttons
          Row(
            children: [
              // Back Button
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.goBack,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Back',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              SizedBox(width: 16),

              // Skip Button
              Expanded(
                child: TextButton(
                  onPressed: controller.skipCompanySetup,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Skip for now',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 16),

              // Continue Button
              Expanded(
                flex: 2,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.setupCompany,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: controller.isLoading.value
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Setup Company',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationStep() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        _buildStepHeader(
          'Company Verification',
          'Your company profile is being verified',
          Icons.verified_outlined,
          3,
          3,
        ),

        SizedBox(height: 40),

        Obx(() {
          if (controller.isCompanyVerified.value) {
            return _buildVerificationSuccess();
          } else {
            return _buildVerificationPending();
          }
        }),
      ],
    );
  }

  Widget _buildVerificationPending() {
    return Column(
      children: [
        // Verification Animation
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.orange[100],
            shape: BoxShape.circle,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange[600]!),
                strokeWidth: 4,
              ),
              Icon(
                Icons.hourglass_empty_outlined,
                size: 40,
                color: Colors.orange[600],
              ),
            ],
          ),
        ),

        SizedBox(height: 24),

        Text(
          'Verification in Progress',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),

        SizedBox(height: 12),

        Text(
          'Our admin team is reviewing your company profile.',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 8),

        Text(
          'This usually takes 24-48 hours.',
          style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 32),

        // Company Details Summary
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Submitted Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 16),
              _buildDetailRow(
                'Company Name',
                controller.companyNameController.text,
              ),
              _buildDetailRow('Industry', controller.selectedIndustry.value),
              _buildDetailRow(
                'Company Size',
                controller.selectedCompanySize.value,
              ),
              _buildDetailRow(
                'Website',
                controller.companyWebsiteController.text,
              ),
              _buildDetailRow('Phone', controller.companyPhoneController.text),
            ],
          ),
        ),

        SizedBox(height: 32),

        // Action Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: controller.resendVerification,
                icon: Icon(Icons.refresh_outlined),
                label: Text('Resend Request'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            SizedBox(width: 16),

            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => Get.offAllNamed('/home'),
                icon: Icon(Icons.skip_next_outlined),
                label: Text('Continue to Dashboard'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 16),

        Text(
          'You can continue to use the platform with limited features.\nFull access will be enabled after verification.',
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildVerificationSuccess() {
    return Column(
      children: [
        // Success Animation
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.green[100],
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle_outlined,
            size: 60,
            color: Colors.green[600],
          ),
        ),

        SizedBox(height: 24),

        Text(
          'Verification Complete!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green[600],
          ),
        ),

        SizedBox(height: 12),

        Text(
          'Your company has been successfully verified.',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 8),

        Text(
          'Welcome to Campus Connect Recruiter!',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 32),

        // Welcome Features
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green[200]!),
          ),
          child: Column(
            children: [
              Text(
                'You now have access to:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              SizedBox(height: 16),
              _buildFeatureItem(
                'Post unlimited job openings',
                Icons.work_outlined,
              ),
              _buildFeatureItem(
                'Access to student database',
                Icons.people_outlined,
              ),
              _buildFeatureItem(
                'Advanced recruitment tools',
                Icons.build_outlined,
              ),
              _buildFeatureItem(
                'Analytics and reports',
                Icons.analytics_outlined,
              ),
              _buildFeatureItem(
                'Priority support',
                Icons.support_agent_outlined,
              ),
            ],
          ),
        ),

        SizedBox(height: 32),

        // Continue Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () => Get.offAllNamed('/home'),
            icon: Icon(Icons.dashboard_outlined),
            label: Text(
              'Go to Dashboard',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepHeader(
    String title,
    String subtitle,
    IconData icon,
    int currentStep,
    int totalSteps,
  ) {
    return Column(
      children: [
        // Step Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(totalSteps, (index) {
            final isActive = index < currentStep;
            final isCurrent = index == currentStep - 1;

            return Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.blue[600] : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isCurrent
                        ? Icon(icon, color: Colors.white, size: 18)
                        : Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: isActive ? Colors.white : Colors.grey[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                  ),
                ),
                if (index < totalSteps - 1) ...[
                  Container(
                    width: 30,
                    height: 2,
                    color: isActive ? Colors.blue[600] : Colors.grey[300],
                  ),
                ],
              ],
            );
          }),
        ),

        SizedBox(height: 24),

        // Title and Subtitle
        Text(
          title,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),

        SizedBox(height: 8),

        Text(
          subtitle,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[800],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.green[600]),
          SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.green[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
