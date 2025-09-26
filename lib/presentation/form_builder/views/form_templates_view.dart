import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/form_builder.controller.dart';

class FormTemplatesView extends GetView<FormBuilderController> {
  const FormTemplatesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Form Templates',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Start with a pre-built template or create from scratch',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),

              // Search and Filter
              Row(
                children: [
                  Container(
                    width: 250,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search templates...',
                        prefixIcon: Icon(Icons.search_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  PopupMenuButton<String>(
                    onSelected: (value) => _filterTemplates(value),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'all',
                        child: Text('All Categories'),
                      ),
                      PopupMenuItem(
                        value: 'engineering',
                        child: Text('Engineering'),
                      ),
                      PopupMenuItem(
                        value: 'internship',
                        child: Text('Internship'),
                      ),
                      PopupMenuItem(value: 'graduate', child: Text('Graduate')),
                      PopupMenuItem(value: 'general', child: Text('General')),
                    ],
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.filter_list_outlined, size: 16),
                          SizedBox(width: 4),
                          Text('Filter'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 24),

          // Quick Start Options
          Row(
            children: [
              _buildQuickStartCard(
                'Blank Form',
                'Start with an empty form',
                Icons.add_box_outlined,
                Colors.blue,
                () => controller.createNewForm(),
              ),
              SizedBox(width: 16),
              _buildQuickStartCard(
                'Import Form',
                'Import from existing form',
                Icons.upload_file_outlined,
                Colors.green,
                () => _showImportDialog(),
              ),
              SizedBox(width: 16),
              _buildQuickStartCard(
                'AI Assistant',
                'Generate form with AI',
                Icons.auto_awesome_outlined,
                Colors.purple,
                () => _showAIAssistantDialog(),
              ),
            ],
          ),

          SizedBox(height: 32),

          // Templates Grid
          Text(
            'Pre-built Templates',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),

          SizedBox(height: 16),

          Expanded(
            child: Obx(
              () => GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: controller.formTemplates.length,
                itemBuilder: (context, index) {
                  final template = controller.formTemplates[index];
                  return _buildTemplateCard(template);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStartCard(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateCard(FormTemplate template) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Template Preview/Thumbnail
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.description_outlined,
                  size: 40,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 8),
                Text(
                  'Form Preview',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),

          // Template Info
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(
                        template.category,
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      template.category,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _getCategoryColor(template.category),
                      ),
                    ),
                  ),

                  SizedBox(height: 8),

                  // Template Name
                  Text(
                    template.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 4),

                  // Template Description
                  Text(
                    template.description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  Spacer(),

                  // Template Stats
                  Row(
                    children: [
                      Icon(
                        Icons.layers_outlined,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${template.sectionsCount} sections',
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      ),
                      SizedBox(width: 12),
                      Icon(
                        Icons.quiz_outlined,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${template.questionsCount} questions',
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      ),
                    ],
                  ),

                  SizedBox(height: 12),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _previewTemplate(template),
                          child: Text(
                            'Preview',
                            style: TextStyle(fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => controller.loadTemplate(template.id),
                          child: Text(
                            'Use Template',
                            style: TextStyle(fontSize: 12),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'engineering':
        return Colors.blue;
      case 'internship':
        return Colors.green;
      case 'graduate':
        return Colors.purple;
      case 'general':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _filterTemplates(String category) {
    // Filter templates by category
    Get.snackbar(
      'Filter Applied',
      'Showing templates for: $category',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void _previewTemplate(FormTemplate template) {
    Get.dialog(
      Dialog(
        child: Container(
          width: 600,
          height: 400,
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Template Preview: ${template.name}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close_outlined),
                  ),
                ],
              ),

              SizedBox(height: 16),

              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.preview_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Template Preview',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${template.sectionsCount} sections • ${template.questionsCount} questions',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Get.back(), child: Text('Close')),
                  SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      controller.loadTemplate(template.id);
                    },
                    child: Text('Use This Template'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImportDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Import Form'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Import a form from a JSON file or another platform'),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 32,
                    color: Colors.blue[600],
                  ),
                  SizedBox(height: 8),
                  Text('Click to upload or drag & drop'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(onPressed: () => Get.back(), child: Text('Import')),
        ],
      ),
    );
  }

  void _showAIAssistantDialog() {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.auto_awesome_outlined, color: Colors.purple[600]),
            SizedBox(width: 8),
            Text('AI Form Assistant'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Describe the type of form you want to create and AI will generate it for you.',
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Job Position',
                hintText: 'e.g., Software Engineer, Product Manager',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Required Information',
                hintText: 'e.g., Technical skills, Portfolio, Experience',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'AI Form Generated',
                'Your form has been generated successfully!',
                backgroundColor: Colors.purple,
                colorText: Colors.white,
              );
              controller.createNewForm();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            child: Text('Generate Form'),
          ),
        ],
      ),
    );
  }
}
