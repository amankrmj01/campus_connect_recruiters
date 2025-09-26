import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/analytics.controller.dart';

class RecruitmentReportsView extends GetView<AnalyticsController> {
  const RecruitmentReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          // Reports Header with Export Options
          _buildReportsHeader(),

          SizedBox(height: 24),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hiring Pipeline Overview
              Expanded(flex: 2, child: _buildHiringPipelineCard()),

              SizedBox(width: 20),

              // Time to Hire Metrics
              Expanded(flex: 1, child: _buildTimeToHireCard()),
            ],
          ),

          SizedBox(height: 20),

          Row(
            children: [
              // Source Analysis
              Expanded(child: _buildSourceAnalysisCard()),

              SizedBox(width: 20),

              // Candidate Quality Metrics
              Expanded(child: _buildCandidateQualityCard()),
            ],
          ),

          SizedBox(height: 20),

          // Detailed Recruitment Performance Table
          _buildDetailedPerformanceTable(),

          SizedBox(height: 20),

          Row(
            children: [
              // Interview Success Rate
              Expanded(child: _buildInterviewSuccessCard()),

              SizedBox(width: 20),

              // Recruiter Performance
              Expanded(child: _buildRecruiterPerformanceCard()),
            ],
          ),

          SizedBox(height: 20),

          // Cost Per Hire Analysis
          _buildCostPerHireCard(),
        ],
      ),
    );
  }

  Widget _buildReportsHeader() {
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recruitment Performance Reports',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Comprehensive insights into your hiring process and outcomes',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildReportButton(
                    'PDF Report',
                    Icons.picture_as_pdf,
                    Colors.red,
                  ),
                  SizedBox(width: 12),
                  _buildReportButton(
                    'Excel Export',
                    Icons.table_chart,
                    Colors.green,
                  ),
                  SizedBox(width: 12),
                  _buildReportButton(
                    'Email Report',
                    Icons.email_outlined,
                    Colors.blue,
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 20),

          // Quick Stats Row
          Row(
            children: [
              _buildQuickStat('Total Positions', '24', Colors.blue),
              SizedBox(width: 20),
              _buildQuickStat('Positions Filled', '18', Colors.green),
              SizedBox(width: 20),
              _buildQuickStat('Open Positions', '6', Colors.orange),
              SizedBox(width: 20),
              _buildQuickStat('Fill Rate', '75%', Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportButton(String title, IconData icon, Color color) {
    return ElevatedButton.icon(
      onPressed: () => _exportReport(title),
      icon: Icon(icon, size: 16),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildQuickStat(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(
              value,
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
                color: color.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHiringPipelineCard() {
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
                'Hiring Pipeline Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Icon(Icons.timeline_outlined, color: Colors.grey[600]),
            ],
          ),

          SizedBox(height: 24),

          // Pipeline Stages
          _buildPipelineStage('Application Received', 1247, 100, Colors.blue),
          SizedBox(height: 16),
          _buildPipelineStage('Initial Screening', 892, 71.5, Colors.indigo),
          SizedBox(height: 16),
          _buildPipelineStage('Technical Assessment', 534, 42.8, Colors.purple),
          SizedBox(height: 16),
          _buildPipelineStage('Technical Interview', 287, 23.0, Colors.orange),
          SizedBox(height: 16),
          _buildPipelineStage('HR Interview', 156, 12.5, Colors.green),
          SizedBox(height: 16),
          _buildPipelineStage('Final Selection', 89, 7.1, Colors.red),

          SizedBox(height: 20),

          // Pipeline Insights
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pipeline Insights',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '• Highest drop-off occurs between Technical Assessment and Interview (46.2%)',
                  style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                ),
                Text(
                  '• Strong conversion rate from HR to Final Selection (57.1%)',
                  style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                ),
                Text(
                  '• Overall pipeline efficiency: 7.1% (Industry average: 8.5%)',
                  style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPipelineStage(
    String stage,
    int count,
    double percentage,
    Color color,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              stage,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            Row(
              children: [
                Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 8),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 6,
        ),
      ],
    );
  }

  Widget _buildTimeToHireCard() {
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
                'Time to Hire',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Icon(Icons.access_time_outlined, color: Colors.grey[600]),
            ],
          ),

          SizedBox(height: 24),

          // Average Time to Hire
          Center(
            child: Column(
              children: [
                Text(
                  '${controller.averageTimeToHire.value}',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[600],
                  ),
                ),
                Text(
                  'DAYS AVERAGE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          // Time Breakdown
          _buildTimeBreakdown('Screening', 3, Colors.blue),
          SizedBox(height: 12),
          _buildTimeBreakdown('Assessment', 5, Colors.green),
          SizedBox(height: 12),
          _buildTimeBreakdown('Interviews', 7, Colors.orange),
          SizedBox(height: 12),
          _buildTimeBreakdown('Decision', 3, Colors.purple),

          SizedBox(height: 20),

          // Comparison with Industry
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.trending_down, color: Colors.green[600], size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '15% faster than industry average',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      Text(
                        'Industry avg: 21 days',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.green[600],
                        ),
                      ),
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

  Widget _buildTimeBreakdown(String stage, int days, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(stage, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$days days',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSourceAnalysisCard() {
    final sourceData = [
      {
        'source': 'Campus Placement',
        'candidates': 487,
        'percentage': 39.1,
        'color': Colors.blue[600]!,
      },
      {
        'source': 'Job Portals',
        'candidates': 312,
        'percentage': 25.0,
        'color': Colors.green[600]!,
      },
      {
        'source': 'Company Website',
        'candidates': 234,
        'percentage': 18.8,
        'color': Colors.orange[600]!,
      },
      {
        'source': 'Employee Referrals',
        'candidates': 145,
        'percentage': 11.6,
        'color': Colors.purple[600]!,
      },
      {
        'source': 'Social Media',
        'candidates': 69,
        'percentage': 5.5,
        'color': Colors.red[600]!,
      },
    ];

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
                'Candidate Source Analysis',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Icon(Icons.source_outlined, color: Colors.grey[600]),
            ],
          ),

          SizedBox(height: 24),

          // Source List
          ...sourceData
              .map(
                (source) => Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: source['color'] as Color,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                source['source'] as String,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '${source['candidates']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: source['color'] as Color,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '${(source['percentage'] as double).toStringAsFixed(1)}%',
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
                      LinearProgressIndicator(
                        value: (source['percentage'] as double) / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          source['color'] as Color,
                        ),
                        minHeight: 4,
                      ),
                    ],
                  ),
                ),
              )
              .toList(),

          SizedBox(height: 16),

          // Source Insights
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Source Performance Insights',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '• Campus Placement delivers highest volume and quality',
                  style: TextStyle(fontSize: 12, color: Colors.orange[700]),
                ),
                Text(
                  '• Employee Referrals have 2.3x higher conversion rate',
                  style: TextStyle(fontSize: 12, color: Colors.orange[700]),
                ),
                Text(
                  '• Consider increasing Social Media investment',
                  style: TextStyle(fontSize: 12, color: Colors.orange[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCandidateQualityCard() {
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
                'Candidate Quality Metrics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Icon(Icons.star_outline, color: Colors.grey[600]),
            ],
          ),

          SizedBox(height: 24),

          // Quality Score
          Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: 0.82,
                        strokeWidth: 12,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.green[600]!,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          '8.2',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[600],
                          ),
                        ),
                        Text(
                          'QUALITY SCORE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          // Quality Metrics
          _buildQualityMetric('Average CGPA', '8.1', Colors.blue),
          SizedBox(height: 12),
          _buildQualityMetric('Skill Match %', '87%', Colors.green),
          SizedBox(height: 12),
          _buildQualityMetric('Experience Relevance', '74%', Colors.orange),
          SizedBox(height: 12),
          _buildQualityMetric('Cultural Fit Score', '8.5', Colors.purple),

          SizedBox(height: 20),

          // Quality Trend
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.trending_up, color: Colors.green[600], size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quality improving',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      Text(
                        '+12% vs last quarter',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.green[600],
                        ),
                      ),
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

  Widget _buildQualityMetric(String metric, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(metric, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedPerformanceTable() {
    final performanceData = [
      {
        'position': 'Software Development Engineer',
        'openings': 5,
        'applications': 285,
        'interviews': 42,
        'offers': 15,
        'filled': 5,
        'timeToFill': 22,
        'cost': 45000,
      },
      {
        'position': 'Frontend Developer Intern',
        'openings': 3,
        'applications': 189,
        'interviews': 28,
        'offers': 8,
        'filled': 3,
        'timeToFill': 15,
        'cost': 25000,
      },
      {
        'position': 'Data Scientist',
        'openings': 2,
        'applications': 156,
        'interviews': 18,
        'offers': 5,
        'filled': 2,
        'timeToFill': 28,
        'cost': 65000,
      },
      {
        'position': 'DevOps Engineer',
        'openings': 2,
        'applications': 98,
        'interviews': 15,
        'offers': 4,
        'filled': 2,
        'timeToFill': 35,
        'cost': 55000,
      },
      {
        'position': 'Product Manager Trainee',
        'openings': 1,
        'applications': 67,
        'interviews': 12,
        'offers': 3,
        'filled': 1,
        'timeToFill': 18,
        'cost': 35000,
      },
    ];

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
                'Detailed Position Performance',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _exportTableData(),
                    icon: Icon(Icons.download_outlined),
                    tooltip: 'Export Table',
                  ),
                  IconButton(
                    onPressed: () => _refreshTableData(),
                    icon: Icon(Icons.refresh_outlined),
                    tooltip: 'Refresh Data',
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 20),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.grey[50]),
              headingTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              columns: [
                DataColumn(label: Text('Position')),
                DataColumn(label: Text('Openings')),
                DataColumn(label: Text('Applications')),
                DataColumn(label: Text('Interviews')),
                DataColumn(label: Text('Offers')),
                DataColumn(label: Text('Filled')),
                DataColumn(label: Text('Time to Fill')),
                DataColumn(label: Text('Cost per Hire')),
                DataColumn(label: Text('Fill Rate')),
              ],
              rows: performanceData.map((data) {
                final fillRate =
                    ((data['filled'] as int) / (data['openings'] as int) * 100);
                return DataRow(
                  cells: [
                    DataCell(
                      Container(
                        constraints: BoxConstraints(maxWidth: 200),
                        child: Text(
                          data['position'] as String,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    DataCell(Text('${data['openings']}')),
                    DataCell(Text('${data['applications']}')),
                    DataCell(Text('${data['interviews']}')),
                    DataCell(Text('${data['offers']}')),
                    DataCell(Text('${data['filled']}')),
                    DataCell(Text('${data['timeToFill']} days')),
                    DataCell(Text('₹${(data['cost'] as int).toString()}')),
                    DataCell(
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: fillRate == 100
                              ? Colors.green[50]
                              : Colors.orange[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${fillRate.toStringAsFixed(0)}%',
                          style: TextStyle(
                            color: fillRate == 100
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

  Widget _buildInterviewSuccessCard() {
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
            'Interview Success Analysis',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),

          SizedBox(height: 24),

          // Success Rate by Round
          _buildInterviewRound('Technical Round', 78.5, Colors.blue),
          SizedBox(height: 16),
          _buildInterviewRound('HR Round', 85.2, Colors.green),
          SizedBox(height: 16),
          _buildInterviewRound('Final Round', 72.3, Colors.orange),

          SizedBox(height: 20),

          // Average Scores
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Average Interview Scores',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Technical Skills', style: TextStyle(fontSize: 12)),
                    Text(
                      '8.2/10',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Communication', style: TextStyle(fontSize: 12)),
                    Text(
                      '7.8/10',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Cultural Fit', style: TextStyle(fontSize: 12)),
                    Text(
                      '8.5/10',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterviewRound(String round, double successRate, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              round,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            Text(
              '${successRate.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        LinearProgressIndicator(
          value: successRate / 100,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 6,
        ),
      ],
    );
  }

  Widget _buildRecruiterPerformanceCard() {
    final recruiterData = [
      {'name': 'John Recruiter', 'positions': 12, 'filled': 9, 'rating': 4.8},
      {'name': 'Sarah Manager', 'positions': 8, 'filled': 7, 'rating': 4.6},
      {'name': 'Mike Product', 'positions': 6, 'filled': 4, 'rating': 4.2},
    ];

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
            'Recruiter Performance',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),

          SizedBox(height: 24),

          ...recruiterData
              .map(
                (recruiter) => Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recruiter['name'] as String,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                              Text(
                                '${recruiter['positions']} positions',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${recruiter['filled']}/${recruiter['positions']} filled',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[600],
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  Text(
                                    '${recruiter['rating']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      LinearProgressIndicator(
                        value:
                            (recruiter['filled'] as int) /
                            (recruiter['positions'] as int),
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.green[600]!,
                        ),
                        minHeight: 4,
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildCostPerHireCard() {
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
            'Cost Per Hire Analysis',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),

          SizedBox(height: 24),

          Row(
            children: [
              // Average Cost Per Hire
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '₹45,000',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[600],
                        ),
                      ),
                      Text(
                        'Average Cost per Hire',
                        style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(width: 20),

              // Cost Breakdown
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _buildCostItem(
                      'Advertising & Sourcing',
                      15000,
                      Colors.blue,
                    ),
                    SizedBox(height: 12),
                    _buildCostItem('Recruitment Team', 18000, Colors.green),
                    SizedBox(height: 12),
                    _buildCostItem('Assessment Tools', 5000, Colors.orange),
                    SizedBox(height: 12),
                    _buildCostItem('Interview Process', 7000, Colors.purple),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          // Cost Comparison
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.trending_down, color: Colors.green[600]),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cost optimization successful',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      Text(
                        '18% reduction compared to last quarter (₹55,000)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green[600],
                        ),
                      ),
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

  Widget _buildCostItem(String item, int cost, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(item, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '₹${cost.toString()}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  void _exportReport(String reportType) {
    Get.snackbar(
      'Export Started',
      '$reportType is being generated...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );

    Future.delayed(Duration(seconds: 2), () {
      Get.snackbar(
        'Export Complete',
        '$reportType has been downloaded',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    });
  }

  void _exportTableData() {
    Get.snackbar(
      'Export Started',
      'Table data is being exported...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void _refreshTableData() {
    controller.refreshData();
  }
}
