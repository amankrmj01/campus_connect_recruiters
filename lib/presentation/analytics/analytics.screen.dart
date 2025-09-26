import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/analytics.controller.dart';
import 'views/application_statistics_view.dart';
import 'views/recruitment_reports_view.dart';

class AnalyticsScreen extends GetView<AnalyticsController> {
  const AnalyticsScreen({super.key});

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
                  'Loading analytics data...',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Header Section
            Container(
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
                            'Recruitment Analytics',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Track your hiring performance and candidate insights',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          // Time Range Selector
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
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

                          SizedBox(width: 12),

                          // Refresh Button
                          IconButton(
                            onPressed: controller.refreshData,
                            icon: Icon(Icons.refresh),
                            tooltip: 'Refresh Data',
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey[100],
                              foregroundColor: Colors.grey[700],
                            ),
                          ),

                          SizedBox(width: 8),

                          // Export Button
                          ElevatedButton.icon(
                            onPressed: controller.exportReport,
                            icon: Icon(Icons.download_outlined),
                            label: Text('Export Report'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 24),

                  // Key Metrics Row
                  Row(
                    children: [
                      _buildMetricCard(
                        'Total Applications',
                        controller.totalApplications.value.toString(),
                        Icons.assignment_outlined,
                        Colors.blue,
                        '+12.5%',
                        true,
                      ),
                      SizedBox(width: 16),
                      _buildMetricCard(
                        'Profile Views',
                        controller.totalViews.value.toString(),
                        Icons.visibility_outlined,
                        Colors.green,
                        '+8.3%',
                        true,
                      ),
                      SizedBox(width: 16),
                      _buildMetricCard(
                        'Shortlist Rate',
                        '${controller.shortlistRate.value.toStringAsFixed(1)}%',
                        Icons.star_outline,
                        Colors.orange,
                        '+2.1%',
                        true,
                      ),
                      SizedBox(width: 16),
                      _buildMetricCard(
                        'Avg. Time to Hire',
                        '${controller.averageTimeToHire.value} days',
                        Icons.timer_outlined,
                        Colors.purple,
                        '-3.2%',
                        false,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Content Area
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    // Tab Bar
                    Container(
                      color: Colors.white,
                      child: TabBar(
                        labelColor: Colors.blue[600],
                        unselectedLabelColor: Colors.grey[600],
                        indicatorColor: Colors.blue[600],
                        tabs: [
                          Tab(
                            icon: Icon(Icons.bar_chart_outlined),
                            text: 'Application Statistics',
                          ),
                          Tab(
                            icon: Icon(Icons.assessment_outlined),
                            text: 'Recruitment Reports',
                          ),
                        ],
                      ),
                    ),

                    // Tab Views
                    Expanded(
                      child: TabBarView(
                        children: [
                          ApplicationStatisticsView(),
                          RecruitmentReportsView(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String change,
    bool isPositive,
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
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPositive ? Colors.green[50] : Colors.red[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositive ? Icons.trending_up : Icons.trending_down,
                        size: 16,
                        color: isPositive ? Colors.green[600] : Colors.red[600],
                      ),
                      SizedBox(width: 4),
                      Text(
                        change,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isPositive
                              ? Colors.green[600]
                              : Colors.red[600],
                        ),
                      ),
                    ],
                  ),
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
          ],
        ),
      ),
    );
  }
}
