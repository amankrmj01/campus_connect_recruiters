import 'package:campus_connect_recruiter/presentation/form_builder/views/form_builder_view.dart';
import 'package:campus_connect_recruiter/presentation/form_builder/views/form_preview_view.dart';
import 'package:campus_connect_recruiter/presentation/form_builder/views/saved_forms_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/form_builder.controller.dart';

class FormBuilderScreen extends GetView<FormBuilderController> {
  const FormBuilderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Header Section
          _buildHeader(),

          // Tab Bar
          _buildTabBar(),

          // Content Area
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading form builder...'),
                    ],
                  ),
                );
              }

              switch (controller.selectedTab.value) {
                case 0:
                  return FormTemplatesView();
                case 1:
                  return FormTemplatesView();
                case 2:
                  return FormPreviewView();
                case 3:
                  return SavedFormsView();
                default:
                  return FormTemplatesView();
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Application Form Builder',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Create custom application forms for your job postings',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),

              Row(
                children: [
                  // Preview Toggle (only show when in builder)
                  Obx(() {
                    if (controller.selectedTab.value == 1) {
                      return Row(
                        children: [
                          Switch(
                            value: controller.isPreviewMode.value,
                            onChanged: (_) => controller.togglePreviewMode(),
                            activeColor: Colors.blue[600],
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Preview Mode',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(width: 20),
                        ],
                      );
                    }
                    return SizedBox.shrink();
                  }),

                  // Action Buttons
                  Obx(() {
                    if (controller.selectedTab.value == 1) {
                      return Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: controller.saveForm,
                            icon: Icon(Icons.save_outlined, size: 16),
                            label: Text('Save Draft'),
                          ),
                          SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: controller.publishForm,
                            icon: Icon(Icons.publish_outlined, size: 16),
                            label: Text('Publish Form'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[600],
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return ElevatedButton.icon(
                        onPressed: controller.createNewForm,
                        icon: Icon(Icons.add_outlined, size: 16),
                        label: Text('Create New Form'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          foregroundColor: Colors.white,
                        ),
                      );
                    }
                  }),
                ],
              ),
            ],
          ),

          SizedBox(height: 20),

          // Form Title Input (only show when in builder)
          Obx(() {
            if (controller.selectedTab.value == 1) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: controller.formTitleController,
                          onChanged: controller.setFormTitle,
                          decoration: InputDecoration(
                            labelText: 'Form Title',
                            hintText: 'Enter your form title',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Associated Job',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          items: [
                            DropdownMenuItem(
                              value: '',
                              child: Text('Select Job'),
                            ),
                            DropdownMenuItem(
                              value: 'job_1',
                              child: Text('Software Engineer'),
                            ),
                            DropdownMenuItem(
                              value: 'job_2',
                              child: Text('Product Manager'),
                            ),
                            DropdownMenuItem(
                              value: 'job_3',
                              child: Text('Data Scientist'),
                            ),
                          ],
                          onChanged: (value) {
                            controller.selectedJobId.value = value ?? '';
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: controller.formDescriptionController,
                    onChanged: controller.setFormDescription,
                    decoration: InputDecoration(
                      labelText: 'Form Description (Optional)',
                      hintText:
                          'Provide instructions or context for candidates',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    maxLines: 2,
                  ),
                ],
              );
            }
            return SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    final tabs = [
      {'title': 'Templates', 'icon': Icons.library_books_outlined},
      {'title': 'Form Builder', 'icon': Icons.build_outlined},
      {'title': 'Preview', 'icon': Icons.preview_outlined},
      {'title': 'Saved Forms', 'icon': Icons.folder_outlined},
    ];

    return Container(
      color: Colors.white,
      child: TabBar(
        controller: TabController(
          length: tabs.length,
          vsync: Scaffold.of(Get.context!),
        ),
        onTap: controller.changeTab,
        labelColor: Colors.blue[600],
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: Colors.blue[600],
        tabs: tabs.map((tab) {
          return Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(tab['icon'] as IconData, size: 16),
                SizedBox(width: 8),
                Text(tab['title'] as String),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
