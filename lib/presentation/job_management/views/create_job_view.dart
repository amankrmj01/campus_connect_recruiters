import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/job_management.controller.dart';
import 'job_requirements_form_view.dart';

class CreateJobView extends GetView<JobManagementController> {
  const CreateJobView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(),

          SizedBox(height: 24),

          // Form Content
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Form
              Expanded(flex: 2, child: _buildMainForm()),

              SizedBox(width: 24),

              // Side Panel
              Expanded(child: _buildSidePanel()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create New Job Posting',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Fill out the details below to create a comprehensive job posting',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),

        Row(
          children: [
            OutlinedButton(
              onPressed: controller.cancelCreatingJob,
              child: Text('Cancel'),
            ),
            SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: _saveDraft,
              icon: Icon(Icons.save_outlined, size: 16),
              label: Text('Save Draft'),
            ),
            SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: _publishJob,
              icon: Icon(Icons.publish_outlined, size: 16),
              label: Text('Publish Job'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMainForm() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic Information Section
          _buildSectionHeader('Basic Information', Icons.info_outlined),
          SizedBox(height: 16),

          // Job Title
          _buildTextField(
            'Job Title',
            controller.jobTitleController,
            'e.g., Senior Software Engineer',
            isRequired: true,
          ),

          SizedBox(height: 16),

          // Department and Job Type Row
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  'Department',
                  controller.departmentOptions.skip(1).toList(),
                  'Engineering',
                  (value) {},
                  isRequired: true,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildDropdown(
                  'Job Type',
                  controller.jobTypeOptions.skip(1).toList(),
                  'Full Time',
                  (value) {},
                  isRequired: true,
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          // Location and Experience Row
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  'Location',
                  controller.locationOptions,
                  'Bangalore',
                  (value) {},
                  isRequired: true,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildDropdown(
                  'Experience Required',
                  controller.experienceOptions,
                  'Fresher',
                  (value) {},
                  isRequired: true,
                ),
              ),
            ],
          ),

          SizedBox(height: 24),

          // Job Description Section
          _buildSectionHeader('Job Description', Icons.description_outlined),
          SizedBox(height: 16),

          _buildTextArea(
            'Job Description',
            controller.jobDescriptionController,
            'Describe the role, responsibilities, and what makes this position exciting...',
            minLines: 5,
            isRequired: true,
          ),

          SizedBox(height: 24),

          // Requirements Section
          _buildSectionHeader(
            'Requirements & Skills',
            Icons.checklist_outlined,
          ),
          SizedBox(height: 16),

          JobRequirementsFormView(),

          SizedBox(height: 24),

          // Compensation Section
          _buildSectionHeader('Compensation', Icons.attach_money_outlined),
          SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  'Minimum Salary (LPA)',
                  controller.salaryMinController,
                  '0',
                  keyboardType: TextInputType.number,
                  isRequired: true,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  'Maximum Salary (LPA)',
                  controller.salaryMaxController,
                  '0',
                  keyboardType: TextInputType.number,
                  isRequired: true,
                ),
              ),
            ],
          ),

          SizedBox(height: 24),

          // Benefits Section
          _buildSectionHeader('Benefits & Perks', Icons.favorite_outlined),
          SizedBox(height: 16),

          _buildTextArea(
            'Benefits',
            controller.benefitsController,
            'List the benefits and perks (one per line):\n• Health insurance\n• Flexible working hours\n• Professional development budget',
            minLines: 4,
          ),

          SizedBox(height: 24),

          // Additional Settings
          _buildSectionHeader('Additional Settings', Icons.settings_outlined),
          SizedBox(height: 16),

          _buildAdditionalSettings(),
        ],
      ),
    );
  }

  Widget _buildSidePanel() {
    return Column(
      children: [
        // Job Preview
        _buildJobPreview(),

        SizedBox(height: 16),

        // Quick Tips
        _buildQuickTips(),

        SizedBox(height: 16),

        // Templates
        _buildJobTemplates(),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue[600]),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint, {
    bool isRequired = false,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            if (isRequired) ...[
              SizedBox(width: 4),
              Text('*', style: TextStyle(color: Colors.red, fontSize: 14)),
            ],
          ],
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
      ],
    );
  }

  Widget _buildTextArea(
    String label,
    TextEditingController controller,
    String hint, {
    int minLines = 3,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            if (isRequired) ...[
              SizedBox(width: 4),
              Text('*', style: TextStyle(color: Colors.red, fontSize: 14)),
            ],
          ],
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: null,
          minLines: minLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.grey[50],
            alignLabelWithHint: true,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> options,
    String initialValue,
    Function(String?) onChanged, {
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            if (isRequired) ...[
              SizedBox(width: 4),
              Text('*', style: TextStyle(color: Colors.red, fontSize: 14)),
            ],
          ],
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: initialValue,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          items: options.map((option) {
            return DropdownMenuItem(value: option, child: Text(option));
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildAdditionalSettings() {
    return Column(
      children: [
        // Priority Setting
        Row(
          children: [
            Expanded(
              child: Text(
                'Job Priority',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ),
            DropdownButton<String>(
              value: 'Medium',
              items: ['Low', 'Medium', 'High', 'Urgent'].map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _getPriorityColor(priority),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(priority),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {},
            ),
          ],
        ),

        SizedBox(height: 16),

        // Application Deadline
        Row(
          children: [
            Expanded(
              child: Text(
                'Application Deadline',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ),
            TextButton.icon(
              onPressed: _selectDeadline,
              icon: Icon(Icons.calendar_today_outlined, size: 16),
              label: Text('Select Date'),
            ),
          ],
        ),

        SizedBox(height: 16),

        // Job Tags
        _buildJobTags(),
      ],
    );
  }

  Widget _buildJobTags() {
    final tags = ['React', 'Flutter', 'Node.js', 'Python', 'AWS', 'MongoDB'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Job Tags',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.map((tag) {
            return FilterChip(
              label: Text(tag, style: TextStyle(fontSize: 12)),
              selected: false,
              onSelected: (selected) {},
              selectedColor: Colors.blue[100],
              checkmarkColor: Colors.blue[600],
            );
          }).toList(),
        ),
        SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: 'Add custom tag and press Enter',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            isDense: true,
          ),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              // Add tag logic
            }
          },
        ),
      ],
    );
  }

  Widget _buildJobPreview() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.preview_outlined, size: 16, color: Colors.blue[600]),
              SizedBox(width: 8),
              Text(
                'Live Preview',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          // Preview Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Job Title Preview (Static for now - will be updated via controller method)
                Text(
                  'Software Engineer', // Static preview text
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  'Engineering Department',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),

                SizedBox(height: 12),

                // Job Details Preview
                Row(
                  children: [
                    Icon(
                      Icons.work_outlined,
                      size: 12,
                      color: Colors.grey[500],
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Full Time',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),

                    SizedBox(width: 12),

                    Icon(
                      Icons.location_on_outlined,
                      size: 12,
                      color: Colors.grey[500],
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Bangalore',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  ],
                ),

                SizedBox(height: 8),

                // Salary Preview (Static for now)
                Text(
                  '₹12 - ₹18 LPA', // Static preview
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[700],
                  ),
                ),

                SizedBox(height: 12),

                // Description Preview
                Obx(
                  () => Text(
                    controller.jobDescriptionController.text.isEmpty
                        ? 'Job description will appear here...'
                        : controller.jobDescriptionController.text.length > 100
                        ? '${controller.jobDescriptionController.text.substring(0, 100)}...'
                        : controller.jobDescriptionController.text,
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12),

          ElevatedButton(
            onPressed: _showFullPreview,
            child: Text('Full Preview', style: TextStyle(fontSize: 12)),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickTips() {
    return Container(
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
              Icon(Icons.lightbulb_outlined, size: 16, color: Colors.blue[600]),
              SizedBox(width: 8),
              Text(
                'Quick Tips',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          Column(
            children: [
              _buildTipItem(
                'Use action verbs in job titles for better visibility',
              ),
              _buildTipItem(
                'Include salary range to attract quality candidates',
              ),
              _buildTipItem('List specific skills and technologies required'),
              _buildTipItem('Highlight unique benefits and company culture'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outlined, size: 12, color: Colors.blue[600]),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(fontSize: 11, color: Colors.blue[700]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobTemplates() {
    final templates = [
      {'name': 'Software Engineer', 'icon': Icons.code_outlined},
      {'name': 'Product Manager', 'icon': Icons.business_center_outlined},
      {'name': 'Designer', 'icon': Icons.design_services_outlined},
      {'name': 'Marketing Specialist', 'icon': Icons.campaign_outlined},
    ];

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.library_books_outlined,
                size: 16,
                color: Colors.orange[600],
              ),
              SizedBox(width: 8),
              Text(
                'Job Templates',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          Column(
            children: templates.map((template) {
              return Container(
                margin: EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(
                    template['icon'] as IconData,
                    size: 20,
                    color: Colors.grey[600],
                  ),
                  title: Text(
                    template['name'] as String,
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 12),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 0,
                  ),
                  onTap: () => _loadTemplate(template['name'] as String),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Low':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      case 'High':
        return Colors.red;
      case 'Urgent':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void _selectDeadline() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now().add(Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      Get.snackbar(
        'Deadline Set',
        'Application deadline set to ${picked.day}/${picked.month}/${picked.year}',
      );
    }
  }

  void _saveDraft() {
    if (_validateBasicFields()) {
      // Save as draft logic
      Get.snackbar(
        'Draft Saved',
        'Your job posting has been saved as draft',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  void _publishJob() {
    if (_validateAllFields()) {
      controller.createJob(
        title: controller.jobTitleController.text,
        department: 'Engineering',
        // Get from dropdown
        description: controller.jobDescriptionController.text,
        requirements: controller.requirementsController.text
            .split('\n')
            .where((r) => r.trim().isNotEmpty)
            .toList(),
        benefits: controller.benefitsController.text
            .split('\n')
            .where((b) => b.trim().isNotEmpty)
            .toList(),
        jobType: 'Full Time',
        // Get from dropdown
        experience: 'Fresher',
        // Get from dropdown
        location: 'Bangalore',
        // Get from dropdown
        salaryMin: int.tryParse(controller.salaryMinController.text) ?? 0,
        salaryMax: int.tryParse(controller.salaryMaxController.text) ?? 0,
        deadline: DateTime.now().add(Duration(days: 30)),
        priority: JobPriority.medium,
        tags: [], // Get from tags
      );
    }
  }

  bool _validateBasicFields() {
    if (controller.jobTitleController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter a job title');
      return false;
    }
    return true;
  }

  bool _validateAllFields() {
    if (!_validateBasicFields()) return false;

    if (controller.jobDescriptionController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter a job description');
      return false;
    }

    if (controller.salaryMinController.text.trim().isEmpty ||
        controller.salaryMaxController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please specify salary range');
      return false;
    }

    final minSalary = int.tryParse(controller.salaryMinController.text);
    final maxSalary = int.tryParse(controller.salaryMaxController.text);

    if (minSalary == null || maxSalary == null || minSalary >= maxSalary) {
      Get.snackbar('Error', 'Please enter a valid salary range');
      return false;
    }

    return true;
  }

  void _showFullPreview() {
    Get.dialog(
      Dialog(
        child: Container(
          width: 600,
          height: 700,
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Job Preview',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close_outlined),
                  ),
                ],
              ),

              SizedBox(height: 16),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Full job preview content
                      Text(
                        controller.jobTitleController.text.isEmpty
                            ? 'Job Title'
                            : controller.jobTitleController.text,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 8),

                      Text(
                        'Engineering Department • Full Time • Bangalore',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),

                      SizedBox(height: 16),

                      if (controller
                          .jobDescriptionController
                          .text
                          .isNotEmpty) ...[
                        Text(
                          'Job Description',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(controller.jobDescriptionController.text),
                        SizedBox(height: 16),
                      ],

                      // Add more preview sections as needed
                    ],
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Get.back(), child: Text('Close')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loadTemplate(String templateName) {
    // Load template data based on template name
    switch (templateName) {
      case 'Software Engineer':
        controller.jobTitleController.text = 'Software Engineer';
        controller.jobDescriptionController.text =
            'We are looking for a skilled software engineer to join our development team...';
        controller.requirementsController.text =
            '• Bachelor\'s degree in Computer Science\n• 2+ years of programming experience\n• Proficiency in modern programming languages';
        controller.benefitsController.text =
            '• Competitive salary\n• Health insurance\n• Flexible working hours\n• Professional development opportunities';
        break;
      // Add more templates as needed
    }

    Get.snackbar(
      'Template Loaded',
      'Template "$templateName" has been loaded. You can now customize it.',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
