import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/job_management.controller.dart';
import 'views/create_job_view.dart';
import 'views/job_list_view.dart';

class JobManagementScreen extends StatefulWidget {
  const JobManagementScreen({super.key});

  @override
  State<JobManagementScreen> createState() => _JobManagementScreenState();
}

class _JobManagementScreenState extends State<JobManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final JobManagementController controller =
      Get.find<JobManagementController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JobManagementController>(
      builder: (controller) {
        return Container(
          color: Colors.grey[50],
          child: Column(
            children: [
              // Header Section
              _buildHeader(),

              // Tab Bar
              _buildTabBar(),

              // Content Area
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value &&
                      controller.allJobs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Loading jobs...'),
                        ],
                      ),
                    );
                  }

                  switch (controller.selectedTab.value) {
                    case 0:
                      return JobListView();
                    case 1:
                      return CreateJobView();
                    case 2:
                      return _buildAnalyticsView();
                    case 3:
                      return _buildSettingsView();
                    default:
                      return JobListView();
                  }
                }),
              ),
            ],
          ),
        );
      },
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
                    'Job Management',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Manage job postings, track applications, and optimize your hiring process',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),

              Row(
                children: [
                  // Quick Stats
                  _buildQuickStat(
                    'Active Jobs',
                    controller.jobStatistics['published']?.toString() ?? '0',
                    Colors.green,
                    Icons.work_outlined,
                  ),
                  SizedBox(width: 16),
                  _buildQuickStat(
                    'Applications',
                    controller.jobStatistics['totalApplications']?.toString() ??
                        '0',
                    Colors.blue,
                    Icons.people_outlined,
                  ),
                  SizedBox(width: 16),
                  _buildQuickStat(
                    'Draft Jobs',
                    controller.jobStatistics['draft']?.toString() ?? '0',
                    Colors.orange,
                    Icons.edit_outlined,
                  ),

                  SizedBox(width: 24),

                  // Action Buttons
                  OutlinedButton.icon(
                    onPressed: controller.refreshJobs,
                    icon: Icon(Icons.refresh_outlined, size: 16),
                    label: Text('Refresh'),
                  ),

                  SizedBox(width: 12),

                  ElevatedButton.icon(
                    onPressed: controller.startCreatingJob,
                    icon: Icon(Icons.add_outlined, size: 16),
                    label: Text('Post New Job'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 20),

          // Key Metrics Cards
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Total Jobs Posted',
                  controller.jobStatistics['total']?.toString() ?? '0',
                  'All time job postings',
                  Icons.work_outline,
                  Colors.blue,
                  '+12% this month',
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard(
                  'Total Applications',
                  controller.jobStatistics['totalApplications']?.toString() ??
                      '0',
                  'Across all active jobs',
                  Icons.assignment_outlined,
                  Colors.green,
                  '+25% this week',
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard(
                  'Avg. Applications/Job',
                  controller.jobStatistics['avgApplicationsPerJob']
                          ?.toString() ??
                      '0',
                  'Application conversion rate',
                  Icons.trending_up_outlined,
                  Colors.purple,
                  '+8% improvement',
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard(
                  'Total Views',
                  controller.jobStatistics['totalViews']?.toString() ?? '0',
                  'Job posting visibility',
                  Icons.visibility_outlined,
                  Colors.orange,
                  '+45% reach',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
    String trend,
  ) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  trend,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[600],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),

          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),

          SizedBox(height: 4),

          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    final tabs = [
      {'title': 'Active Jobs', 'icon': Icons.work_outlined},
      {'title': 'Create Job', 'icon': Icons.add_circle_outlined},
      {'title': 'Analytics', 'icon': Icons.analytics_outlined},
      {'title': 'Settings', 'icon': Icons.settings_outlined},
    ];

    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        onTap: Get.find<JobManagementController>().changeTab,
        labelColor: Colors.blue[600],
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: Colors.blue[600],
        tabs: tabs.map((tab) {
          final index = tabs.indexOf(tab);
          return Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(tab['icon'] as IconData, size: 16),
                SizedBox(width: 8),
                Text(tab['title'] as String),

                // Badge for draft jobs count on create tab
                if (index == 1 &&
                    controller.jobStatistics['draft'] != null &&
                    controller.jobStatistics['draft'] > 0)
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${controller.jobStatistics['draft']}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAnalyticsView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Job Analytics & Performance',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),

          SizedBox(height: 20),

          // Analytics Cards
          Row(
            children: [
              Expanded(
                child: _buildAnalyticsCard(
                  'Application Conversion Rate',
                  '23.5%',
                  '+2.3% vs last month',
                  Icons.trending_up_outlined,
                  Colors.green,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildAnalyticsCard(
                  'Average Time to Fill',
                  '18 days',
                  '-3 days improvement',
                  Icons.access_time_outlined,
                  Colors.blue,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildAnalyticsCard(
                  'Job View Rate',
                  '1,234 views',
                  '+45% this week',
                  Icons.visibility_outlined,
                  Colors.purple,
                ),
              ),
            ],
          ),

          SizedBox(height: 24),

          // Department Performance
          _buildDepartmentPerformance(),

          SizedBox(height: 24),

          // Top Performing Jobs
          _buildTopPerformingJobs(),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard(
    String title,
    String value,
    String trend,
    IconData icon,
    Color color,
  ) {
    return Container(
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
              Icon(icon, color: color, size: 24),
              Icon(
                trend.startsWith('+') ? Icons.trending_up : Icons.trending_down,
                color: trend.startsWith('+') ? Colors.green : Colors.red,
                size: 20,
              ),
            ],
          ),

          SizedBox(height: 16),

          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),

          SizedBox(height: 4),

          Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[700])),

          SizedBox(height: 8),

          Text(
            trend,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: trend.startsWith('+') ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentPerformance() {
    final departments = [
      {'name': 'Engineering', 'jobs': 8, 'applications': 234, 'filled': 5},
      {'name': 'Product', 'jobs': 3, 'applications': 89, 'filled': 2},
      {'name': 'Design', 'jobs': 4, 'applications': 156, 'filled': 3},
      {'name': 'Marketing', 'jobs': 2, 'applications': 67, 'filled': 1},
    ];

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Department Performance',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),

          SizedBox(height: 16),

          Column(
            children: departments.map((dept) {
              return Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        dept['name'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),

                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '${dept['jobs']}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[600],
                            ),
                          ),
                          Text(
                            'Jobs',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '${dept['applications']}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[600],
                            ),
                          ),
                          Text(
                            'Applications',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '${dept['filled']}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple[600],
                            ),
                          ),
                          Text(
                            'Filled',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopPerformingJobs() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Performing Jobs',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),

          SizedBox(height: 16),

          Obx(
            () => Column(
              children: controller.filteredJobs.take(5).map((job) {
                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              job.title,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                              ),
                            ),
                            Text(
                              job.department,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),

                      _buildJobMetric(
                        '${job.applicationsCount}',
                        'Applications',
                        Colors.blue,
                      ),
                      _buildJobMetric(
                        '${job.viewsCount}',
                        'Views',
                        Colors.green,
                      ),
                      _buildJobMetric(
                        '${job.shortlistedCount}',
                        'Shortlisted',
                        Colors.orange,
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

  Widget _buildJobMetric(String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildSettingsView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Job Management Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),

          SizedBox(height: 20),

          // Default Job Settings
          _buildSettingsSection('Default Job Settings', [
            _buildSettingItem(
              'Auto-publish jobs',
              'Automatically publish jobs after creation',
              false,
              (value) {},
            ),
            _buildSettingItem(
              'Email notifications',
              'Receive email alerts for new applications',
              true,
              (value) {},
            ),
            _buildSettingItem(
              'Application deadline reminders',
              'Get notified before job deadlines',
              true,
              (value) {},
            ),
          ]),

          SizedBox(height: 24),

          // Application Settings
          _buildSettingsSection('Application Settings', [
            _buildSettingItem(
              'Auto-screen applications',
              'Automatically screen based on requirements',
              false,
              (value) {},
            ),
            _buildSettingItem(
              'Send acknowledgment emails',
              'Auto-send confirmation to applicants',
              true,
              (value) {},
            ),
          ]),

          SizedBox(height: 24),

          // Integration Settings
          _buildSettingsSection('Integration Settings', [
            ListTile(
              title: Text('Job Board Integrations'),
              subtitle: Text('Manage external job board postings'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              title: Text('ATS Integration'),
              subtitle: Text('Configure applicant tracking system'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),

          Divider(height: 1),

          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }
}
