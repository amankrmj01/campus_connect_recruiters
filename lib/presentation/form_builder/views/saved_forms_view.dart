import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/form_builder.controller.dart';

class SavedFormsView extends GetView<FormBuilderController> {
  const SavedFormsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with tabs
          Row(
            children: [
              Text(
                'My Forms',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),

              Spacer(),

              // Search and Filter
              Container(
                width: 250,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search forms...',
                    prefixIcon: Icon(Icons.search_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  onChanged: (value) => _searchForms(value),
                ),
              ),

              SizedBox(width: 12),

              // Sort Dropdown
              PopupMenuButton<String>(
                onSelected: (value) => _sortForms(value),
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'recent', child: Text('Most Recent')),
                  PopupMenuItem(value: 'name', child: Text('Name A-Z')),
                  PopupMenuItem(value: 'status', child: Text('Status')),
                  PopupMenuItem(
                    value: 'responses',
                    child: Text('Most Responses'),
                  ),
                ],
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.sort_outlined, size: 16),
                      SizedBox(width: 4),
                      Text('Sort'),
                      Icon(Icons.arrow_drop_down, size: 16),
                    ],
                  ),
                ),
              ),

              SizedBox(width: 12),

              // New Form Button
              ElevatedButton.icon(
                onPressed: controller.createNewForm,
                icon: Icon(Icons.add_outlined, size: 16),
                label: Text('New Form'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),

          SizedBox(height: 24),

          // Status Tabs
          DefaultTabController(
            length: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TabBar(
                  labelColor: Colors.blue[600],
                  unselectedLabelColor: Colors.grey[600],
                  indicatorColor: Colors.blue[600],
                  isScrollable: true,
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('All Forms'),
                          SizedBox(width: 8),
                          Obx(
                            () => Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${controller.savedForms.length + controller.publishedForms.length}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Published'),
                          SizedBox(width: 8),
                          Obx(
                            () => Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${controller.publishedForms.length}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Drafts'),
                          SizedBox(width: 8),
                          Obx(
                            () => Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${controller.savedForms.where((f) => f.status == 'Draft').length}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[700],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24),

                // Tab Content
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildAllFormsTab(),
                      _buildPublishedFormsTab(),
                      _buildDraftsTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllFormsTab() {
    return Obx(() {
      final allForms = [
        ...controller.savedForms.map((f) => _FormItem.fromSaved(f)),
        ...controller.publishedForms.map((f) => _FormItem.fromPublished(f)),
      ];

      if (allForms.isEmpty) {
        return _buildEmptyState(
          'No forms created yet',
          'Create your first application form to get started',
          Icons.description_outlined,
        );
      }

      return _buildFormsGrid(allForms);
    });
  }

  Widget _buildPublishedFormsTab() {
    return Obx(() {
      final publishedForms = controller.publishedForms
          .map((f) => _FormItem.fromPublished(f))
          .toList();

      if (publishedForms.isEmpty) {
        return _buildEmptyState(
          'No published forms',
          'Publish forms to start receiving applications',
          Icons.publish_outlined,
        );
      }

      return Column(
        children: [
          // Published Forms Stats
          _buildPublishedStats(),
          SizedBox(height: 20),

          // Published Forms Grid
          Expanded(child: _buildFormsGrid(publishedForms)),
        ],
      );
    });
  }

  Widget _buildDraftsTab() {
    return Obx(() {
      final drafts = controller.savedForms
          .where((f) => f.status == 'Draft')
          .map((f) => _FormItem.fromSaved(f))
          .toList();

      if (drafts.isEmpty) {
        return _buildEmptyState(
          'No draft forms',
          'Draft forms will appear here when you save work in progress',
          Icons.drafts_outlined,
        );
      }

      return _buildFormsGrid(drafts);
    });
  }

  Widget _buildPublishedStats() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[50]!, Colors.blue[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Obx(() {
        final totalResponses = controller.publishedForms.fold<int>(
          0,
          (sum, form) => sum + form.responses,
        );
        final totalViews = controller.publishedForms.fold<int>(
          0,
          (sum, form) => sum + form.views,
        );
        final avgCompletionRate = controller.publishedForms.isNotEmpty
            ? controller.publishedForms.fold<double>(
                    0,
                    (sum, form) => sum + form.completionRate,
                  ) /
                  controller.publishedForms.length
            : 0.0;

        return Row(
          children: [
            _buildStatItem(
              'Total Responses',
              totalResponses.toString(),
              Icons.assignment_turned_in_outlined,
              Colors.green,
            ),
            _buildStatItem(
              'Total Views',
              totalViews.toString(),
              Icons.visibility_outlined,
              Colors.blue,
            ),
            _buildStatItem(
              'Avg Completion',
              '${avgCompletionRate.toStringAsFixed(1)}%',
              Icons.check_circle_outlined,
              Colors.purple,
            ),
            _buildStatItem(
              'Active Forms',
              '${controller.publishedForms.length}',
              Icons.publish_outlined,
              Colors.orange,
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withAlpha((0.2 * 255).toInt())),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormsGrid(List<_FormItem> forms) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: forms.length,
      itemBuilder: (context, index) {
        final form = forms[index];
        return _buildFormCard(form);
      },
    );
  }

  Widget _buildFormCard(_FormItem form) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).toInt()),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Form Preview/Thumbnail
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Stack(
              children: [
                // Preview Content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 32,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${form.questionsCount} questions',
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),

                // Status Badge
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        form.status,
                      ).withAlpha((0.9 * 255).toInt()),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      form.status,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Form Info
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Form Title
                  Text(
                    form.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 4),

                  // Job Title (if associated)
                  if (form.jobTitle.isNotEmpty) ...[
                    Text(
                      'For: ${form.jobTitle}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.blue[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                  ] else
                    SizedBox(height: 12),

                  // Form Stats
                  Row(
                    children: [
                      Icon(
                        Icons.quiz_outlined,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${form.questionsCount}',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                      SizedBox(width: 12),
                      Icon(
                        Icons.people_outlined,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${form.responsesCount}',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),

                  SizedBox(height: 8),

                  // Last Modified / Published Date
                  Text(
                    form.status == 'Published'
                        ? 'Published ${_formatDate(form.lastModified)}'
                        : 'Modified ${_formatDate(form.lastModified)}',
                    style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                  ),

                  Spacer(),

                  // Performance Indicator (for published forms)
                  if (form.status == 'Published' &&
                      form is _PublishedFormItem) ...[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getPerformanceColor(
                          form.completionRate,
                        ).withAlpha((0.1 * 255).toInt()),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.trending_up_outlined,
                            size: 12,
                            color: _getPerformanceColor(form.completionRate),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${form.completionRate.toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _getPerformanceColor(form.completionRate),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  SizedBox(height: 12),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _editForm(form),
                          child: Text('Edit', style: TextStyle(fontSize: 11)),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 6),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _viewForm(form),
                          child: Text(
                            form.status == 'Published' ? 'View' : 'Preview',
                            style: TextStyle(fontSize: 11),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: form.status == 'Published'
                                ? Colors.green[600]
                                : Colors.blue[600],
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 6),
                          ),
                        ),
                      ),
                      SizedBox(width: 4),
                      PopupMenuButton<String>(
                        onSelected: (action) => _handleFormAction(action, form),
                        itemBuilder: (context) => _buildFormContextMenu(form),
                        child: Icon(Icons.more_vert_outlined, size: 16),
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

  Widget _buildEmptyState(String title, String description, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: controller.createNewForm,
            icon: Icon(Icons.add_outlined),
            label: Text('Create New Form'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  List<PopupMenuEntry<String>> _buildFormContextMenu(_FormItem form) {
    List<PopupMenuEntry<String>> items = [
      PopupMenuItem(
        value: 'duplicate',
        child: Row(
          children: [
            Icon(Icons.copy_outlined, size: 16),
            SizedBox(width: 8),
            Text('Duplicate'),
          ],
        ),
      ),
      PopupMenuItem(
        value: 'export',
        child: Row(
          children: [
            Icon(Icons.download_outlined, size: 16),
            SizedBox(width: 8),
            Text('Export'),
          ],
        ),
      ),
    ];

    if (form.status == 'Published') {
      items.addAll([
        PopupMenuItem(
          value: 'analytics',
          child: Row(
            children: [
              Icon(Icons.analytics_outlined, size: 16),
              SizedBox(width: 8),
              Text('Analytics'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'responses',
          child: Row(
            children: [
              Icon(Icons.assignment_outlined, size: 16),
              SizedBox(width: 8),
              Text('View Responses'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'share',
          child: Row(
            children: [
              Icon(Icons.share_outlined, size: 16),
              SizedBox(width: 8),
              Text('Share Link'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'unpublish',
          child: Row(
            children: [
              Icon(Icons.drafts_outlined, size: 16, color: Colors.orange),
              SizedBox(width: 8),
              Text('Unpublish', style: TextStyle(color: Colors.orange)),
            ],
          ),
        ),
      ]);
    } else {
      items.add(
        PopupMenuItem(
          value: 'publish',
          child: Row(
            children: [
              Icon(Icons.publish_outlined, size: 16, color: Colors.green),
              SizedBox(width: 8),
              Text('Publish', style: TextStyle(color: Colors.green)),
            ],
          ),
        ),
      );
    }

    items.addAll([
      PopupMenuDivider(),
      PopupMenuItem(
        value: 'delete',
        child: Row(
          children: [
            Icon(Icons.delete_outlined, size: 16, color: Colors.red),
            SizedBox(width: 8),
            Text('Delete', style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    ]);

    return items;
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'published':
        return Colors.green;
      case 'draft':
        return Colors.orange;
      case 'archived':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  Color _getPerformanceColor(double completionRate) {
    if (completionRate >= 80) return Colors.green;
    if (completionRate >= 60) return Colors.blue;
    if (completionRate >= 40) return Colors.orange;
    return Colors.red;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _searchForms(String query) {
    // Implement search functionality
    Get.snackbar(
      'Search',
      'Searching for: $query',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void _sortForms(String sortBy) {
    // Implement sorting functionality
    Get.snackbar(
      'Sorted',
      'Forms sorted by: $sortBy',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void _editForm(_FormItem form) {
    controller.loadSavedForm(form.id);
    controller.changeTab(1); // Switch to builder tab
  }

  void _viewForm(_FormItem form) {
    if (form.status == 'Published') {
      // Open published form
      Get.dialog(
        AlertDialog(
          title: Text('View Published Form'),
          content: Text('This will open the live form that candidates see.'),
          actions: [
            TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: Text('Open Form'),
            ),
          ],
        ),
      );
    } else {
      // Preview draft form
      controller.loadSavedForm(form.id);
      controller.changeTab(2); // Switch to preview tab
    }
  }

  void _handleFormAction(String action, _FormItem form) {
    switch (action) {
      case 'duplicate':
        _duplicateForm(form);
        break;
      case 'export':
        _exportForm(form);
        break;
      case 'analytics':
        _viewAnalytics(form);
        break;
      case 'responses':
        _viewResponses(form);
        break;
      case 'share':
        _shareForm(form);
        break;
      case 'publish':
        _publishForm(form);
        break;
      case 'unpublish':
        _unpublishForm(form);
        break;
      case 'delete':
        _deleteForm(form);
        break;
    }
  }

  void _duplicateForm(_FormItem form) {
    Get.snackbar(
      'Form Duplicated',
      '${form.title} has been duplicated',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _exportForm(_FormItem form) {
    Get.dialog(
      AlertDialog(
        title: Text('Export Form'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.code_outlined),
              title: Text('JSON Format'),
              subtitle: Text('Export form structure as JSON'),
              onTap: () {
                Get.back();
                Get.snackbar('Exported', 'Form exported as JSON');
              },
            ),
            ListTile(
              leading: Icon(Icons.description_outlined),
              title: Text('PDF Format'),
              subtitle: Text('Export as printable PDF'),
              onTap: () {
                Get.back();
                Get.snackbar('Exported', 'Form exported as PDF');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _viewAnalytics(_FormItem form) {
    Get.snackbar(
      'Analytics',
      'Opening analytics for ${form.title}',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void _viewResponses(_FormItem form) {
    Get.snackbar(
      'Responses',
      'Opening responses for ${form.title}',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _shareForm(_FormItem form) {
    Get.dialog(
      AlertDialog(
        title: Text('Share Form'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Share this form link:'),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'https://forms.campusconnect.com/${form.id}',
                      style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        Get.snackbar('Copied', 'Link copied to clipboard'),
                    icon: Icon(Icons.copy_outlined, size: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Close')),
        ],
      ),
    );
  }

  void _publishForm(_FormItem form) {
    Get.dialog(
      AlertDialog(
        title: Text('Publish Form'),
        content: Text(
          'Are you sure you want to publish "${form.title}"? It will be available for candidates to fill.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar('Published', '${form.title} is now live');
            },
            child: Text('Publish'),
          ),
        ],
      ),
    );
  }

  void _unpublishForm(_FormItem form) {
    Get.dialog(
      AlertDialog(
        title: Text('Unpublish Form'),
        content: Text(
          'This will make the form unavailable to candidates. Existing responses will be preserved.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Unpublished',
                '${form.title} is no longer accepting responses',
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: Text('Unpublish'),
          ),
        ],
      ),
    );
  }

  void _deleteForm(_FormItem form) {
    Get.dialog(
      AlertDialog(
        title: Text('Delete Form'),
        content: Text(
          'Are you sure you want to delete "${form.title}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteForm(form.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// Helper classes for form items
abstract class _FormItem {
  final String id;
  final String title;
  final String jobTitle;
  final String status;
  final DateTime lastModified;
  final int questionsCount;
  final int responsesCount;

  _FormItem({
    required this.id,
    required this.title,
    required this.jobTitle,
    required this.status,
    required this.lastModified,
    required this.questionsCount,
    required this.responsesCount,
  });

  factory _FormItem.fromSaved(SavedForm form) = _SavedFormItem;

  factory _FormItem.fromPublished(PublishedForm form) = _PublishedFormItem;
}

class _SavedFormItem extends _FormItem {
  _SavedFormItem(SavedForm form)
    : super(
        id: form.id,
        title: form.title,
        jobTitle: form.jobTitle,
        status: form.status,
        lastModified: form.lastModified,
        questionsCount: form.questionsCount,
        responsesCount: form.responsesCount,
      );
}

class _PublishedFormItem extends _FormItem {
  final double completionRate;
  final double avgCompletionTime;

  _PublishedFormItem(PublishedForm form)
    : completionRate = form.completionRate,
      avgCompletionTime = form.avgCompletionTime,
      super(
        id: form.id,
        title: form.title,
        jobTitle: form.jobTitle,
        status: 'Published',
        lastModified: form.publishedDate,
        questionsCount: 0,
        // This would come from form structure
        responsesCount: form.responses,
      );
}
