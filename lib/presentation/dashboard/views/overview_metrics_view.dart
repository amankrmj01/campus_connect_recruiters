import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/dashboard.controller.dart';

class OverviewMetricsView extends GetView<DashboardController> {
  const OverviewMetricsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recruitment Metrics Overview',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.trending_up,
                          size: 14,
                          color: Colors.green[600],
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Performance Up 12%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  IconButton(
                    onPressed: () => Get.toNamed('/analytics'),
                    icon: Icon(Icons.analytics_outlined),
                    tooltip: 'View Detailed Analytics',
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 24),

          // Metrics Grid
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _buildMetricCard(
                'Total Applications',
                controller.totalApplications.value.toString(),
                Icons.assignment_outlined,
                Colors.blue,
                '+12.5% vs last month',
                true,
                0,
              ),
              _buildMetricCard(
                'Shortlisted',
                controller.shortlistedCandidates.value.toString(),
                Icons.star_outlined,
                Colors.orange,
                '22.8% conversion rate',
                false,
                1,
              ),
              _buildMetricCard(
                'Interviews',
                controller.interviewsScheduled.value.toString(),
                Icons.calendar_today_outlined,
                Colors.green,
                '${controller.interviewSuccessRate.value.toStringAsFixed(1)}% success rate',
                false,
                2,
              ),
              _buildMetricCard(
                'Offers Made',
                controller.offersExtended.value.toString(),
                Icons.handshake_outlined,
                Colors.purple,
                '${controller.offerAcceptanceRate.value.toStringAsFixed(1)}% acceptance',
                false,
                3,
              ),
            ],
          ),

          SizedBox(height: 24),

          // Performance Indicators Row
          Row(
            children: [
              Expanded(
                child: _buildPerformanceIndicator(
                  'Application Conversion',
                  controller.applicationConversionRate.value,
                  Icons.trending_up_outlined,
                  Colors.blue,
                  'From application to shortlist',
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildPerformanceIndicator(
                  'Interview Success',
                  controller.interviewSuccessRate.value,
                  Icons.check_circle_outlined,
                  Colors.green,
                  'Interviews leading to offers',
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildPerformanceIndicator(
                  'Offer Acceptance',
                  controller.offerAcceptanceRate.value,
                  Icons.thumb_up_outlined,
                  Colors.orange,
                  'Offers accepted by candidates',
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildPerformanceIndicator(
                  'Overall Efficiency',
                  controller.recruitmentEfficiency.value,
                  Icons.speed_outlined,
                  Colors.purple,
                  'End-to-end recruitment efficiency',
                ),
              ),
            ],
          ),

          SizedBox(height: 24),

          // Recruitment Funnel Visualization
          _buildRecruitmentFunnel(),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
    bool showTrend,
    int index,
  ) {
    return Obx(
      () => GestureDetector(
        onTap: () => controller.selectMetricCard(index),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: controller.selectedMetricCard.value == index
                ? color.withOpacity(0.1)
                : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: controller.selectedMetricCard.value == index
                  ? color
                  : Colors.grey[200]!,
              width: controller.selectedMetricCard.value == index ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
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

              SizedBox(height: 4),

              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 8),

              if (showTrend)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.trending_up,
                        size: 12,
                        color: Colors.green[600],
                      ),
                      SizedBox(width: 2),
                      Text(
                        subtitle.split(' ')[0], // Just the percentage
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.green[600],
                        ),
                      ),
                    ],
                  ),
                )
              else
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceIndicator(
    String title,
    double value,
    IconData icon,
    Color color,
    String description,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          // Circular Progress Indicator
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  value: value / 100,
                  strokeWidth: 6,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              Text(
                '${value.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          Text(
            description,
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRecruitmentFunnel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recruitment Funnel',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),

        SizedBox(height: 16),

        Column(
          children: [
            _buildFunnelStage(
              'Applications Received',
              controller.totalApplications.value,
              100.0,
              Colors.blue,
              Icons.assignment_outlined,
            ),
            _buildFunnelConnector(),
            _buildFunnelStage(
              'Candidates Shortlisted',
              controller.shortlistedCandidates.value,
              (controller.shortlistedCandidates.value /
                      controller.totalApplications.value) *
                  100,
              Colors.orange,
              Icons.star_outlined,
            ),
            _buildFunnelConnector(),
            _buildFunnelStage(
              'Interviews Scheduled',
              controller.interviewsScheduled.value,
              (controller.interviewsScheduled.value /
                      controller.totalApplications.value) *
                  100,
              Colors.green,
              Icons.calendar_today_outlined,
            ),
            _buildFunnelConnector(),
            _buildFunnelStage(
              'Offers Extended',
              controller.offersExtended.value,
              (controller.offersExtended.value /
                      controller.totalApplications.value) *
                  100,
              Colors.purple,
              Icons.handshake_outlined,
            ),
            _buildFunnelConnector(),
            _buildFunnelStage(
              'Candidates Hired',
              controller.candidatesHired.value,
              (controller.candidatesHired.value /
                      controller.totalApplications.value) *
                  100,
              Colors.teal,
              Icons.check_circle_outlined,
            ),
          ],
        ),

        SizedBox(height: 16),

        // Funnel Insights
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.lightbulb_outlined, color: Colors.blue[600]),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Funnel Insights',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Your conversion rate from application to hire is ${controller.hiringEfficiency.toStringAsFixed(1)}%, which is above industry average of 2.3%.',
                      style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFunnelStage(
    String title,
    int count,
    double percentage,
    Color color,
    IconData icon,
  ) {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          // Icon
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),

          SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          count.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '(${percentage.toStringAsFixed(1)}%)',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 8),

                // Progress Bar
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percentage / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFunnelConnector() {
    return Container(
      height: 20,
      width: 2,
      margin: EdgeInsets.only(left: 24, top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}
