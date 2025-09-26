// Import for cos function
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/analytics.controller.dart';

class ApplicationStatisticsView extends GetView<AnalyticsController> {
  const ApplicationStatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Application Trends Chart
              Expanded(flex: 2, child: _buildApplicationTrendsCard()),

              SizedBox(width: 20),

              // Department Statistics
              Expanded(flex: 1, child: _buildDepartmentStatsCard()),
            ],
          ),

          SizedBox(height: 20),

          // Job Performance Table
          _buildJobPerformanceCard(),

          SizedBox(height: 20),

          Row(
            children: [
              // Conversion Funnel
              Expanded(child: _buildConversionFunnelCard()),

              SizedBox(width: 20),

              // Monthly Metrics
              Expanded(child: _buildMonthlyMetricsCard()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationTrendsCard() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Application Trends',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  controller.selectedTimeRange.value,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 24),

          // Simple Line Chart Alternative
          Container(height: 300, child: Obx(() => _buildSimpleLineChart())),
        ],
      ),
    );
  }

  Widget _buildSimpleLineChart() {
    final data = controller.applicationTrends;
    if (data.isEmpty) return Center(child: Text('No data available'));

    final maxValue = data
        .map((e) => e.applications)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();
    final minValue = data
        .map((e) => e.applications)
        .reduce((a, b) => a < b ? a : b)
        .toDouble();

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Chart Area
          Expanded(
            child: Container(
              width: double.infinity,
              child: CustomPaint(
                painter: LineChartPainter(
                  data: data.map((e) => e.applications.toDouble()).toList(),
                  maxValue: maxValue,
                  minValue: minValue,
                ),
              ),
            ),
          ),

          SizedBox(height: 16),

          // X-axis labels (showing some dates)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${data.first.date.day}/${data.first.date.month}',
                style: TextStyle(fontSize: 12),
              ),
              Text(
                '${data[data.length ~/ 2].date.day}/${data[data.length ~/ 2].date.month}',
                style: TextStyle(fontSize: 12),
              ),
              Text(
                '${data.last.date.day}/${data.last.date.month}',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentStatsCard() {
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
          Text(
            'Applications by Department',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),

          SizedBox(height: 24),

          // Simple Pie Chart Alternative
          Container(height: 200, child: Obx(() => _buildSimplePieChart())),

          SizedBox(height: 16),

          // Legend
          Column(
            children: controller.departmentStats.asMap().entries.map((entry) {
              final index = entry.key;
              final data = entry.value;
              final colors = [
                Colors.blue[600]!,
                Colors.green[600]!,
                Colors.orange[600]!,
                Colors.purple[600]!,
                Colors.red[600]!,
              ];

              return Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: colors[index % colors.length],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        data.department,
                        style: TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${data.applications}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
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

  Widget _buildSimplePieChart() {
    return Center(
      child: Container(
        width: 160,
        height: 160,
        child: Obx(
          () => CustomPaint(
            painter: PieChartPainter(data: controller.departmentStats),
          ),
        ),
      ),
    );
  }

  Widget _buildJobPerformanceCard() {
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
          Text(
            'Job Performance Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),

          SizedBox(height: 20),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.grey[50]),
              columns: [
                DataColumn(
                  label: Text(
                    'Job Title',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Applications',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Views',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Shortlisted',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Interviewed',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Selected',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Conversion %',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: controller.jobPerformanceData.map((job) {
                return DataRow(
                  cells: [
                    DataCell(
                      Container(
                        constraints: BoxConstraints(maxWidth: 200),
                        child: Text(
                          job.jobTitle,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    DataCell(Text('${job.applications}')),
                    DataCell(Text('${job.views}')),
                    DataCell(Text('${job.shortlisted}')),
                    DataCell(Text('${job.interviewed}')),
                    DataCell(Text('${job.selected}')),
                    DataCell(
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: job.conversionRate > 4.0
                              ? Colors.green[50]
                              : Colors.orange[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${job.conversionRate.toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: job.conversionRate > 4.0
                                ? Colors.green[600]
                                : Colors.orange[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversionFunnelCard() {
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
          Text(
            'Conversion Funnel',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),

          SizedBox(height: 24),

          _buildFunnelStep(
            'Applications',
            controller.totalApplications.value,
            100.0,
            Colors.blue,
          ),
          SizedBox(height: 12),
          _buildFunnelStep(
            'Shortlisted',
            (controller.totalApplications.value *
                    controller.shortlistRate.value /
                    100)
                .round(),
            controller.shortlistRate.value,
            Colors.green,
          ),
          SizedBox(height: 12),
          _buildFunnelStep(
            'Interviewed',
            (controller.totalApplications.value *
                    controller.shortlistRate.value *
                    controller.interviewRate.value /
                    10000)
                .round(),
            controller.interviewRate.value *
                controller.shortlistRate.value /
                100,
            Colors.orange,
          ),
          SizedBox(height: 12),
          _buildFunnelStep(
            'Selected',
            (controller.totalApplications.value *
                    controller.shortlistRate.value *
                    controller.interviewRate.value *
                    controller.selectionRate.value /
                    1000000)
                .round(),
            controller.selectionRate.value *
                controller.interviewRate.value *
                controller.shortlistRate.value /
                10000,
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildFunnelStep(
    String title,
    int count,
    double percentage,
    Color color,
  ) {
    return Column(
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
            Text(
              '$count (${percentage.toStringAsFixed(1)}%)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage / 100,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyMetricsCard() {
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
          Text(
            'Monthly Performance',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),

          SizedBox(height: 24),

          // Simple Bar Chart
          Container(height: 200, child: Obx(() => _buildSimpleBarChart())),
        ],
      ),
    );
  }

  Widget _buildSimpleBarChart() {
    final data = controller.monthlyMetrics;
    if (data.isEmpty) return Center(child: Text('No data available'));

    final maxValue = data
        .map((e) => e.applications)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    return Column(
      children: [
        // Chart
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: data.map((metric) {
              final height = (metric.applications / maxValue) * 150;
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 30,
                    height: height,
                    decoration: BoxDecoration(
                      color: Colors.blue[400],
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(metric.month, style: TextStyle(fontSize: 12)),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// Custom Painters for Charts
class LineChartPainter extends CustomPainter {
  final List<double> data;
  final double maxValue;
  final double minValue;

  LineChartPainter({
    required this.data,
    required this.maxValue,
    required this.minValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = Colors.blue[600]!
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y =
          size.height -
          ((data[i] - minValue) / (maxValue - minValue)) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Draw area under curve
    final areaPaint = Paint()
      ..color = Colors.blue[600]!.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final areaPath = Path.from(path);
    areaPath.lineTo(size.width, size.height);
    areaPath.lineTo(0, size.height);
    areaPath.close();

    canvas.drawPath(areaPath, areaPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class PieChartPainter extends CustomPainter {
  final List<DepartmentStats> data;

  PieChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final colors = [
      Colors.blue[600]!,
      Colors.green[600]!,
      Colors.orange[600]!,
      Colors.purple[600]!,
      Colors.red[600]!,
    ];

    double startAngle = 0;

    for (int i = 0; i < data.length; i++) {
      final sweepAngle = (data[i].percentage / 100) * 2 * 3.14159;

      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // Draw percentage text
      final textAngle = startAngle + sweepAngle / 2;
      final textRadius = radius * 0.7;
      final textCenter = Offset(
        center.dx + textRadius * cos(textAngle),
        center.dy + textRadius * sin(textAngle),
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: '${data[i].percentage.toStringAsFixed(1)}%',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          textCenter.dx - textPainter.width / 2,
          textCenter.dy - textPainter.height / 2,
        ),
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
