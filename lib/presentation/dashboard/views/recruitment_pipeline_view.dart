import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/dashboard.controller.dart';

class RecruitmentPipelineView extends GetView<DashboardController> {
  const RecruitmentPipelineView({super.key});

  @override
  Widget build(BuildContext context) {
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
          // Header
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(Icons.timeline_outlined, color: Colors.purple[600]),
                SizedBox(width: 8),
                Text(
                  'Recruitment Pipeline',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Spacer(),
                PopupMenuButton<String>(
                  onSelected: (value) => _handlePipelineAction(value),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'view_all',
                      child: Row(
                        children: [
                          Icon(Icons.visibility_outlined, size: 16),
                          SizedBox(width: 8),
                          Text('View All Stages'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'export',
                      child: Row(
                        children: [
                          Icon(Icons.download_outlined, size: 16),
                          SizedBox(width: 8),
                          Text('Export Pipeline'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'settings',
                      child: Row(
                        children: [
                          Icon(Icons.settings_outlined, size: 16),
                          SizedBox(width: 8),
                          Text('Pipeline Settings'),
                        ],
                      ),
                    ),
                  ],
                  child: Icon(
                    Icons.more_vert_outlined,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1),

          // Pipeline Visualization
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // Pipeline Stages Row
                Row(
                  children: [
                    _buildPipelineStage(
                      'Applications',
                      controller.totalApplications.value,
                      Colors.blue,
                      Icons.assignment_outlined,
                      isFirst: true,
                    ),
                    _buildPipelineConnector(),
                    _buildPipelineStage(
                      'Screening',
                      (controller.totalApplications.value * 0.7).round(),
                      Colors.indigo,
                      Icons.search_outlined,
                    ),
                    _buildPipelineConnector(),
                    _buildPipelineStage(
                      'Shortlisted',
                      controller.shortlistedCandidates.value,
                      Colors.orange,
                      Icons.star_outlined,
                    ),
                    _buildPipelineConnector(),
                    _buildPipelineStage(
                      'Interviews',
                      controller.interviewsScheduled.value,
                      Colors.green,
                      Icons.calendar_today_outlined,
                    ),
                    _buildPipelineConnector(),
                    _buildPipelineStage(
                      'Offers',
                      controller.offersExtended.value,
                      Colors.purple,
                      Icons.handshake_outlined,
                    ),
                    _buildPipelineConnector(),
                    _buildPipelineStage(
                      'Hired',
                      controller.candidatesHired.value,
                      Colors.teal,
                      Icons.check_circle_outlined,
                      isLast: true,
                    ),
                  ],
                ),

                SizedBox(height: 24),

                // Pipeline Performance Metrics
                _buildPipelineMetrics(),

                SizedBox(height: 20),

                // Top Performing Jobs in Pipeline
                _buildTopPerformingJobs(),

                SizedBox(height: 20),

                // Pipeline Trends Chart
                _buildPipelineTrends(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPipelineStage(
    String title,
    int count,
    Color color,
    IconData icon, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),

            SizedBox(height: 12),

            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),

            SizedBox(height: 4),

            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 8),

            // Conversion Rate (except for first stage)
            if (!isFirst)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_calculateConversionRate(title)}%',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPipelineConnector() {
    return Container(
      width: 30,
      height: 2,
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(1),
      ),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 2,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          // Animated flow indicator
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(seconds: 2),
            builder: (context, value, child) {
              return Container(
                width: 30 * value,
                height: 2,
                decoration: BoxDecoration(
                  color: Colors.blue[400],
                  borderRadius: BorderRadius.circular(1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPipelineMetrics() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pipeline Performance',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),

          SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  'Avg. Time in Pipeline',
                  '${controller.avgTimeToHire.value} days',
                  Icons.access_time_outlined,
                  Colors.blue,
                ),
              ),
              Expanded(
                child: _buildMetricItem(
                  'Bottleneck Stage',
                  'Screening',
                  Icons.warning_outlined,
                  Colors.orange,
                ),
              ),
              Expanded(
                child: _buildMetricItem(
                  'Pipeline Efficiency',
                  '${controller.recruitmentEfficiency.value.toStringAsFixed(1)}%',
                  Icons.speed_outlined,
                  Colors.green,
                ),
              ),
              Expanded(
                child: _buildMetricItem(
                  'Weekly Velocity',
                  '${(controller.candidatesHired.value * 7 / 30).toStringAsFixed(1)}',
                  Icons.trending_up_outlined,
                  Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTopPerformingJobs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Top Performing Jobs',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            TextButton(
              onPressed: () => Get.toNamed('/job-performance'),
              child: Text('View All'),
            ),
          ],
        ),

        SizedBox(height: 12),

        Obx(
          () => Column(
            children: controller.topPerformingJobs.take(3).map((job) {
              return Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    // Performance Indicator
                    Container(
                      width: 4,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getPerformanceColor(job.efficiency),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    SizedBox(width: 12),

                    // Job Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.jobTitle,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                '${job.applications} applications',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                '${job.hired} hired',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Performance Metrics
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getPerformanceColor(
                              job.efficiency,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${job.efficiency.toStringAsFixed(0)}% efficiency',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _getPerformanceColor(job.efficiency),
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${job.conversionRate.toStringAsFixed(1)}% conversion',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPipelineTrends() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pipeline Trends (Last 30 Days)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            Row(
              children: [
                _buildTrendLegend('Applications', Colors.blue),
                SizedBox(width: 16),
                _buildTrendLegend('Shortlisted', Colors.orange),
                SizedBox(width: 16),
                _buildTrendLegend('Hired', Colors.green),
              ],
            ),
          ],
        ),

        SizedBox(height: 16),

        Container(
          height: 200,
          child: Obx(
            () => CustomPaint(
              painter: PipelineTrendsPainter(
                trends: controller.recruitmentTrends,
              ),
              child: Container(),
            ),
          ),
        ),

        SizedBox(height: 12),

        // Trend Insights
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.insights_outlined, color: Colors.blue[600]),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pipeline Insights',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Applications increased 15% this week. Consider optimizing screening process to handle higher volume.',
                      style: TextStyle(fontSize: 11, color: Colors.blue[700]),
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

  Widget _buildTrendLegend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 2,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }

  // Helper Methods
  String _calculateConversionRate(String stage) {
    final total = controller.totalApplications.value;
    if (total == 0) return '0';

    switch (stage) {
      case 'Screening':
        return ((total * 0.7) / total * 100).toStringAsFixed(0);
      case 'Shortlisted':
        return (controller.shortlistedCandidates.value / total * 100)
            .toStringAsFixed(0);
      case 'Interviews':
        return (controller.interviewsScheduled.value / total * 100)
            .toStringAsFixed(0);
      case 'Offers':
        return (controller.offersExtended.value / total * 100).toStringAsFixed(
          0,
        );
      case 'Hired':
        return (controller.candidatesHired.value / total * 100).toStringAsFixed(
          0,
        );
      default:
        return '0';
    }
  }

  Color _getPerformanceColor(double efficiency) {
    if (efficiency >= 90) return Colors.green;
    if (efficiency >= 80) return Colors.blue;
    if (efficiency >= 70) return Colors.orange;
    return Colors.red;
  }

  void _handlePipelineAction(String action) {
    switch (action) {
      case 'view_all':
        Get.toNamed('/pipeline-detailed');
        break;
      case 'export':
        Get.snackbar(
          'Export Started',
          'Pipeline data is being exported...',
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
        break;
      case 'settings':
        _showPipelineSettings();
        break;
    }
  }

  void _showPipelineSettings() {
    Get.dialog(
      AlertDialog(
        title: Text('Pipeline Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Configure pipeline stages and automation rules'),
            SizedBox(height: 16),
            // Add pipeline configuration options here
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () => Get.back(),
            child: Text('Save Settings'),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for Pipeline Trends
class PipelineTrendsPainter extends CustomPainter {
  final List<TrendData> trends;

  PipelineTrendsPainter({required this.trends});

  @override
  void paint(Canvas canvas, Size size) {
    if (trends.isEmpty) return;

    final paint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw applications line
    paint.color = Colors.blue;
    _drawLine(
      canvas,
      size,
      trends.map((t) => t.applications.toDouble()).toList(),
      paint,
    );

    // Draw shortlisted line
    paint.color = Colors.orange;
    _drawLine(
      canvas,
      size,
      trends.map((t) => t.shortlisted.toDouble()).toList(),
      paint,
    );

    // Draw hired line
    paint.color = Colors.green;
    _drawLine(
      canvas,
      size,
      trends.map((t) => t.hired.toDouble()).toList(),
      paint,
    );
  }

  void _drawLine(Canvas canvas, Size size, List<double> data, Paint paint) {
    if (data.isEmpty) return;

    final maxValue = data.reduce((a, b) => a > b ? a : b);
    if (maxValue == 0) return;

    final path = Path();
    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height - (data[i] / maxValue) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
