import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/dashboard.controller.dart';
import 'views/overview_metrics_view.dart';
import 'views/quick_actions_view.dart';
import 'views/recent_activities_view.dart';
import 'views/recruitment_pipeline_view.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
                ),
                SizedBox(height: 16),
                Text(
                  'Loading dashboard...',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            // Header Section
            SliverToBoxAdapter(child: _buildDashboardHeader()),

            // Main Content
            SliverPadding(
              padding: EdgeInsets.all(24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Overview Metrics
                  OverviewMetricsView(),

                  SizedBox(height: 24),

                  // Quick Actions
                  QuickActionsView(),

                  SizedBox(height: 24),

                  // Main Content Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column - Activities and Pipeline
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            RecentActivitiesView(),
                            SizedBox(height: 24),
                            RecruitmentPipelineView(),
                          ],
                        ),
                      ),

                      SizedBox(width: 24),

                      // Right Column - Tasks and Notifications
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            _buildUrgentTasksCard(),
                            SizedBox(height: 24),
                            _buildNotificationsCard(),
                            SizedBox(height: 24),
                            _buildDepartmentStatsCard(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildDashboardHeader() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
                    'Recruitment Dashboard',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Welcome back! Here\'s what\'s happening with your recruitment activities.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
              Row(
                children: [
                  // Time Range Selector
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: Obx(
                        () => DropdownButton<String>(
                          value: controller.selectedTimeRange.value,
                          items: controller.timeRanges.map((range) {
                            return DropdownMenuItem(
                              value: range,
                              child: Text(range),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.changeTimeRange(value);
                            }
                          },
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 12),

                  // Notifications
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () => _showNotificationsPanel(),
                        icon: Icon(Icons.notifications_outlined),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey[100],
                          foregroundColor: Colors.grey[700],
                        ),
                      ),
                      Obx(() {
                        if (controller.unreadNotifications > 0) {
                          return Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${controller.unreadNotifications}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        return SizedBox.shrink();
                      }),
                    ],
                  ),

                  SizedBox(width: 8),

                  // Refresh Button
                  IconButton(
                    onPressed: controller.refreshDashboard,
                    icon: Icon(Icons.refresh_outlined),
                    tooltip: 'Refresh Dashboard',
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      foregroundColor: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 24),

          // Key Performance Indicators
          Row(
            children: [
              _buildKPICard(
                'Total Applications',
                controller.totalApplications.value.toString(),
                '+${controller.totalApplicationsGrowth.toStringAsFixed(1)}%',
                Icons.assignment_outlined,
                Colors.blue,
                true,
              ),
              SizedBox(width: 16),
              _buildKPICard(
                'Active Jobs',
                controller.activeJobs.value.toString(),
                'of ${controller.totalJobs.value}',
                Icons.work_outlined,
                Colors.green,
                false,
              ),
              SizedBox(width: 16),
              _buildKPICard(
                'Hiring Efficiency',
                '${controller.hiringEfficiency.toStringAsFixed(1)}%',
                '+2.3% vs last month',
                Icons.trending_up_outlined,
                Colors.orange,
                true,
              ),
              SizedBox(width: 16),
              _buildKPICard(
                'Avg. Time to Hire',
                '${controller.avgTimeToHire.value} days',
                '-3 days vs average',
                Icons.access_time_outlined,
                Colors.purple,
                true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKPICard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
    bool showTrend,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                if (showTrend)
                  Icon(
                    subtitle.startsWith('+')
                        ? Icons.trending_up
                        : Icons.trending_down,
                    color: subtitle.startsWith('+') ? Colors.green : Colors.red,
                    size: 20,
                  ),
              ],
            ),

            SizedBox(height: 16),

            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),

            SizedBox(height: 4),

            Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),

            SizedBox(height: 4),

            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: showTrend && subtitle.startsWith('+')
                    ? Colors.green
                    : Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUrgentTasksCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(Icons.priority_high_outlined, color: Colors.red[600]),
                SizedBox(width: 8),
                Text(
                  'Urgent Tasks',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Spacer(),
                Obx(
                  () => Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${controller.highPriorityTasks}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.red[700],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1),

          Container(
            constraints: BoxConstraints(maxHeight: 300),
            child: Obx(
              () => ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.all(16),
                itemCount: controller.urgentTasks.length,
                separatorBuilder: (context, index) => SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final task = controller.urgentTasks[index];
                  return _buildTaskItem(task);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(UrgentTask task) {
    Color priorityColor;
    switch (task.priority) {
      case 'High':
        priorityColor = Colors.red;
        break;
      case 'Medium':
        priorityColor = Colors.orange;
        break;
      default:
        priorityColor = Colors.green;
    }

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: priorityColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: () => controller.markTaskComplete(task.id),
                icon: Icon(Icons.check_circle_outline, size: 18),
                tooltip: 'Mark Complete',
                color: Colors.green[600],
              ),
            ],
          ),

          SizedBox(height: 8),

          Row(
            children: [
              Icon(
                Icons.access_time_outlined,
                size: 14,
                color: Colors.grey[500],
              ),
              SizedBox(width: 4),
              Text(
                _formatDueDate(task.dueDate),
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: priorityColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  task.priority,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: priorityColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(Icons.notifications_outlined, color: Colors.blue[600]),
                SizedBox(width: 8),
                Text(
                  'Recent Notifications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Spacer(),
                TextButton(
                  onPressed: () => _showNotificationsPanel(),
                  child: Text('View All'),
                ),
              ],
            ),
          ),

          Divider(height: 1),

          Container(
            constraints: BoxConstraints(maxHeight: 250),
            child: Obx(
              () => ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.all(16),
                itemCount: controller.notifications.take(5).length,
                separatorBuilder: (context, index) => SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final notification = controller.notifications[index];
                  return _buildNotificationItem(notification);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return InkWell(
      onTap: () => controller.markNotificationRead(notification.id),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.grey[50] : Colors.blue[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: notification.isRead ? Colors.grey[200]! : Colors.blue[200]!,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getNotificationIcon(notification.type),
                  size: 16,
                  color: notification.isRead
                      ? Colors.grey[600]
                      : Colors.blue[600],
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: notification.isRead
                          ? FontWeight.normal
                          : FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (!notification.isRead)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),

            SizedBox(height: 4),

            Text(
              notification.message,
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: 4),

            Text(
              _formatNotificationTime(notification.timestamp),
              style: TextStyle(fontSize: 10, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartmentStatsCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.business_outlined, color: Colors.green[600]),
              SizedBox(width: 8),
              Text(
                'Department Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          Obx(
            () => Column(
              children: controller.departmentStats.map((stat) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            stat.department,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            '${stat.filled}/${stat.openings}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: stat.openings > 0
                            ? stat.filled / stat.openings
                            : 0,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.green[600]!,
                        ),
                        minHeight: 4,
                      ),
                      SizedBox(height: 2),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${stat.applications} applications',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'application':
        return Icons.assignment_outlined;
      case 'interview':
        return Icons.schedule_outlined;
      case 'deadline':
        return Icons.warning_outlined;
      default:
        return Icons.info_outlined;
    }
  }

  String _formatDueDate(DateTime date) {
    final diff = date.difference(DateTime.now());
    if (diff.inHours < 24) {
      return 'Due in ${diff.inHours}h';
    } else {
      return 'Due in ${diff.inDays}d';
    }
  }

  String _formatNotificationTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  void _showNotificationsPanel() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'All Notifications',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Obx(
                () => ListView.separated(
                  itemCount: controller.notifications.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    final notification = controller.notifications[index];
                    return _buildNotificationItem(notification);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
