import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/dashboard.controller.dart';

class QuickActionsView extends GetView<DashboardController> {
  const QuickActionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
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
          // Header
          Row(
            children: [
              Icon(Icons.flash_on_outlined, color: Colors.blue[600]),
              SizedBox(width: 8),
              Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Spacer(),
              Text(
                'Streamline your workflow',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),

          SizedBox(height: 20),

          // Quick Actions Grid
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: controller.quickActions.length,
            itemBuilder: (context, index) {
              final action = controller.quickActions[index];
              return _buildQuickActionCard(
                action['title'] as String,
                action['icon'] as IconData,
                action['color'] as Color,
                index,
              );
            },
          ),

          SizedBox(height: 20),

          // Smart Suggestions
          _buildSmartSuggestions(),

          SizedBox(height: 16),

          // Workflow Shortcuts
          _buildWorkflowShortcuts(),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    int index,
  ) {
    return GestureDetector(
      onTap: () => controller.handleQuickAction(title),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),

            SizedBox(height: 12),

            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartSuggestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.auto_awesome_outlined,
              size: 16,
              color: Colors.orange[600],
            ),
            SizedBox(width: 6),
            Text(
              'Smart Suggestions',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),

        SizedBox(height: 12),

        Column(
          children: [
            _buildSuggestionItem(
              'Review 12 pending applications',
              'High-priority applications are awaiting your review',
              Icons.assignment_outlined,
              Colors.red,
              () => Get.toNamed('/candidate-management'),
            ),

            SizedBox(height: 8),

            _buildSuggestionItem(
              'Schedule 5 pending interviews',
              'Candidates are waiting for interview slots',
              Icons.schedule_outlined,
              Colors.orange,
              () => Get.toNamed('/interview-scheduling'),
            ),

            SizedBox(height: 8),

            _buildSuggestionItem(
              'Send follow-up messages',
              '8 candidates haven\'t responded in 3 days',
              Icons.message_outlined,
              Colors.blue,
              () => _showBulkMessageDialog(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSuggestionItem(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: color, size: 16),
            ),

            SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            Icon(Icons.arrow_forward_ios_outlined, size: 12, color: color),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkflowShortcuts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.route_outlined, size: 16, color: Colors.green[600]),
            SizedBox(width: 6),
            Text(
              'Workflow Shortcuts',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),

        SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _buildWorkflowShortcut(
                'Bulk Shortlist',
                'Auto-shortlist top candidates',
                Icons.star_outlined,
                Colors.green,
                () => _showBulkShortlistDialog(),
              ),
            ),

            SizedBox(width: 12),

            Expanded(
              child: _buildWorkflowShortcut(
                'Interview Batch',
                'Schedule multiple interviews',
                Icons.calendar_view_week_outlined,
                Colors.blue,
                () => _showBatchInterviewDialog(),
              ),
            ),

            SizedBox(width: 12),

            Expanded(
              child: _buildWorkflowShortcut(
                'Template Message',
                'Send template messages',
                Icons.email_outlined,
                Colors.purple,
                () => _showTemplateMessageDialog(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWorkflowShortcut(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: color, size: 20),
            ),

            SizedBox(height: 8),

            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2),

            Text(
              description,
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // Dialog Methods
  void _showBulkMessageDialog() {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.message_outlined, color: Colors.blue[600]),
            SizedBox(width: 8),
            Text('Bulk Message'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Send messages to multiple candidates at once'),
            SizedBox(height: 16),

            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select Recipients',
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  value: 'shortlisted',
                  child: Text('Shortlisted Candidates'),
                ),
                DropdownMenuItem(
                  value: 'pending',
                  child: Text('Pending Applications'),
                ),
                DropdownMenuItem(
                  value: 'interviewed',
                  child: Text('Interviewed Candidates'),
                ),
              ],
              onChanged: (value) {},
            ),

            SizedBox(height: 12),

            TextField(
              decoration: InputDecoration(
                labelText: 'Message',
                hintText: 'Type your message here...',
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
                'Messages Sent',
                'Bulk messages sent successfully',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: Text('Send Messages'),
          ),
        ],
      ),
    );
  }

  void _showBulkShortlistDialog() {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.star_outlined, color: Colors.green[600]),
            SizedBox(width: 8),
            Text('Bulk Shortlist'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Automatically shortlist candidates based on criteria'),
            SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Min CGPA',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Top N Candidates',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            TextField(
              decoration: InputDecoration(
                labelText: 'Required Skills (comma separated)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Shortlisting Complete',
                'Candidates shortlisted based on criteria',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: Text('Shortlist'),
          ),
        ],
      ),
    );
  }

  void _showBatchInterviewDialog() {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.calendar_view_week_outlined, color: Colors.blue[600]),
            SizedBox(width: 8),
            Text('Batch Interview Scheduling'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Schedule multiple interviews in batches'),
            SizedBox(height: 16),

            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Interview Type',
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  value: 'technical',
                  child: Text('Technical Round'),
                ),
                DropdownMenuItem(value: 'hr', child: Text('HR Round')),
                DropdownMenuItem(value: 'final', child: Text('Final Round')),
              ],
              onChanged: (value) {},
            ),

            SizedBox(height: 12),

            TextField(
              decoration: InputDecoration(
                labelText: 'Date Range',
                hintText: 'Select date range',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today_outlined),
              ),
              readOnly: true,
            ),

            SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Start Time',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'End Time',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Interviews Scheduled',
                'Batch interviews scheduled successfully',
                backgroundColor: Colors.blue,
                colorText: Colors.white,
              );
            },
            child: Text('Schedule'),
          ),
        ],
      ),
    );
  }

  void _showTemplateMessageDialog() {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.email_outlined, color: Colors.purple[600]),
            SizedBox(width: 8),
            Text('Template Messages'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Use pre-defined templates for quick messaging'),
            SizedBox(height: 16),

            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select Template',
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  value: 'welcome',
                  child: Text('Welcome Message'),
                ),
                DropdownMenuItem(
                  value: 'shortlisted',
                  child: Text('Shortlisted Notification'),
                ),
                DropdownMenuItem(
                  value: 'interview',
                  child: Text('Interview Invitation'),
                ),
                DropdownMenuItem(
                  value: 'followup',
                  child: Text('Follow-up Message'),
                ),
                DropdownMenuItem(
                  value: 'rejection',
                  child: Text('Rejection Message'),
                ),
              ],
              onChanged: (value) {},
            ),

            SizedBox(height: 12),

            TextField(
              decoration: InputDecoration(
                labelText: 'Preview',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              readOnly: true,
              controller: TextEditingController(
                text:
                    'Dear [Candidate Name],\n\nThank you for your application...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          TextButton(onPressed: () {}, child: Text('Edit Template')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Template Sent',
                'Template message sent to selected candidates',
                backgroundColor: Colors.purple,
                colorText: Colors.white,
              );
            },
            child: Text('Send'),
          ),
        ],
      ),
    );
  }
}
