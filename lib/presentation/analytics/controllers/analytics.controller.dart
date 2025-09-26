import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnalyticsController extends GetxController {
  // Reactive variables
  var isLoading = false.obs;
  var selectedTimeRange = 'Last 30 Days'.obs;
  var selectedMetric = 'Applications'.obs;

  // Analytics Data
  var totalApplications = 0.obs;
  var totalViews = 0.obs;
  var shortlistRate = 0.0.obs;
  var interviewRate = 0.0.obs;
  var selectionRate = 0.0.obs;
  var averageTimeToHire = 0.obs;

  // Chart Data
  var applicationTrends = <ApplicationTrendData>[].obs;
  var departmentStats = <DepartmentStats>[].obs;
  var jobPerformanceData = <JobPerformanceData>[].obs;
  var monthlyMetrics = <MonthlyMetrics>[].obs;

  // Filters
  final timeRanges = [
    'Last 7 Days',
    'Last 30 Days',
    'Last 90 Days',
    'Last 6 Months',
    'Last Year',
  ];
  final metrics = [
    'Applications',
    'Views',
    'Shortlists',
    'Interviews',
    'Selections',
  ];

  @override
  void onInit() {
    super.onInit();
    loadAnalyticsData();
  }

  void loadAnalyticsData() {
    isLoading.value = true;

    // Simulate API call
    Future.delayed(Duration(seconds: 2), () {
      // Mock data
      totalApplications.value = 1247;
      totalViews.value = 5830;
      shortlistRate.value = 22.4;
      interviewRate.value = 65.8;
      selectionRate.value = 78.5;
      averageTimeToHire.value = 18;

      // Application trends data
      applicationTrends.value = [
        ApplicationTrendData(
          date: DateTime.now().subtract(Duration(days: 29)),
          applications: 25,
        ),
        ApplicationTrendData(
          date: DateTime.now().subtract(Duration(days: 28)),
          applications: 32,
        ),
        ApplicationTrendData(
          date: DateTime.now().subtract(Duration(days: 27)),
          applications: 28,
        ),
        ApplicationTrendData(
          date: DateTime.now().subtract(Duration(days: 26)),
          applications: 45,
        ),
        ApplicationTrendData(
          date: DateTime.now().subtract(Duration(days: 25)),
          applications: 38,
        ),
        ApplicationTrendData(
          date: DateTime.now().subtract(Duration(days: 24)),
          applications: 52,
        ),
        ApplicationTrendData(
          date: DateTime.now().subtract(Duration(days: 23)),
          applications: 48,
        ),
        ApplicationTrendData(
          date: DateTime.now().subtract(Duration(days: 22)),
          applications: 41,
        ),
        ApplicationTrendData(
          date: DateTime.now().subtract(Duration(days: 21)),
          applications: 35,
        ),
        ApplicationTrendData(
          date: DateTime.now().subtract(Duration(days: 20)),
          applications: 58,
        ),
        ApplicationTrendData(
          date: DateTime.now().subtract(Duration(days: 19)),
          applications: 62,
        ),
        ApplicationTrendData(
          date: DateTime.now().subtract(Duration(days: 18)),
          applications: 45,
        ),
        ApplicationTrendData(
          date: DateTime.now().subtract(Duration(days: 17)),
          applications: 39,
        ),
        ApplicationTrendData(
          date: DateTime.now().subtract(Duration(days: 16)),
          applications: 47,
        ),
        ApplicationTrendData(
          date: DateTime.now().subtract(Duration(days: 15)),
          applications: 53,
        ),
        ApplicationTrendData(
          date: DateTime.now().subtract(Duration(days: 14)),
          applications: 49,
        ),
        ApplicationTrendData(
          date: DateTime.now().subtract(Duration(days: 13)),
          applications: 42,
        ),
        ApplicationTrendData(
          date: DateTime.now().subtract(Duration(days: 12)),
          applications: 55,
        ),
        ApplicationTrendData(
          date: DateTime.now().subtract(Duration(days: 11)),
          applications: 48,
        ),
        ApplicationTrendData(
          date: DateTime.now().subtract(Duration(days: 10)),
          applications: 43,
        ),
        ApplicationTrendData(
          date: DateTime.now().subtract(Duration(days: 9)),
          applications: 51,
        ),
        ApplicationTrendData(
          date: DateTime.now().subtract(Duration(days: 8)),
          applications: 46,
        ),
        ApplicationTrendData(
          date: DateTime.now().subtract(Duration(days: 7)),
          applications: 54,
        ),
        ApplicationTrendData(
          date: DateTime.now().subtract(Duration(days: 6)),
          applications: 47,
        ),
        ApplicationTrendData(
          date: DateTime.now().subtract(Duration(days: 5)),
          applications: 59,
        ),
        ApplicationTrendData(
          date: DateTime.now().subtract(Duration(days: 4)),
          applications: 52,
        ),
        ApplicationTrendData(
          date: DateTime.now().subtract(Duration(days: 3)),
          applications: 48,
        ),
        ApplicationTrendData(
          date: DateTime.now().subtract(Duration(days: 2)),
          applications: 45,
        ),
        ApplicationTrendData(
          date: DateTime.now().subtract(Duration(days: 1)),
          applications: 41,
        ),
        ApplicationTrendData(date: DateTime.now(), applications: 38),
      ];

      // Department stats
      departmentStats.value = [
        DepartmentStats(
          department: 'Computer Science',
          applications: 485,
          percentage: 38.9,
        ),
        DepartmentStats(
          department: 'Information Technology',
          applications: 312,
          percentage: 25.0,
        ),
        DepartmentStats(
          department: 'Electronics & Communication',
          applications: 198,
          percentage: 15.9,
        ),
        DepartmentStats(
          department: 'Mechanical Engineering',
          applications: 156,
          percentage: 12.5,
        ),
        DepartmentStats(
          department: 'Civil Engineering',
          applications: 96,
          percentage: 7.7,
        ),
      ];

      // Job performance data
      jobPerformanceData.value = [
        JobPerformanceData(
          jobTitle: 'Software Development Engineer',
          applications: 285,
          views: 1250,
          shortlisted: 68,
          interviewed: 42,
          selected: 15,
          conversionRate: 5.3,
        ),
        JobPerformanceData(
          jobTitle: 'Frontend Developer Intern',
          applications: 189,
          views: 856,
          shortlisted: 45,
          interviewed: 28,
          selected: 8,
          conversionRate: 4.2,
        ),
        JobPerformanceData(
          jobTitle: 'Data Scientist',
          applications: 156,
          views: 645,
          shortlisted: 32,
          interviewed: 18,
          selected: 5,
          conversionRate: 3.2,
        ),
        JobPerformanceData(
          jobTitle: 'DevOps Engineer',
          applications: 98,
          views: 432,
          shortlisted: 25,
          interviewed: 15,
          selected: 4,
          conversionRate: 4.1,
        ),
        JobPerformanceData(
          jobTitle: 'Product Manager Trainee',
          applications: 67,
          views: 298,
          shortlisted: 18,
          interviewed: 12,
          selected: 3,
          conversionRate: 4.5,
        ),
      ];

      // Monthly metrics
      monthlyMetrics.value = [
        MonthlyMetrics(
          month: 'Jan',
          applications: 823,
          interviews: 185,
          selections: 52,
        ),
        MonthlyMetrics(
          month: 'Feb',
          applications: 945,
          interviews: 215,
          selections: 68,
        ),
        MonthlyMetrics(
          month: 'Mar',
          applications: 1156,
          interviews: 248,
          selections: 75,
        ),
        MonthlyMetrics(
          month: 'Apr',
          applications: 1089,
          interviews: 234,
          selections: 71,
        ),
        MonthlyMetrics(
          month: 'May',
          applications: 1247,
          interviews: 278,
          selections: 82,
        ),
        MonthlyMetrics(
          month: 'Jun',
          applications: 1134,
          interviews: 251,
          selections: 69,
        ),
      ];

      isLoading.value = false;
    });
  }

  void changeTimeRange(String range) {
    selectedTimeRange.value = range;
    loadAnalyticsData(); // Reload data for new time range
  }

  void changeMetric(String metric) {
    selectedMetric.value = metric;
    // Update chart data based on selected metric
  }

  void exportReport() {
    Get.snackbar(
      'Export Started',
      'Analytics report is being generated...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );

    // TODO: Implement export functionality
    Future.delayed(Duration(seconds: 3), () {
      Get.snackbar(
        'Export Complete',
        'Analytics report has been downloaded',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    });
  }

  void refreshData() {
    loadAnalyticsData();
  }
}

// Data Models for Analytics
class ApplicationTrendData {
  final DateTime date;
  final int applications;

  ApplicationTrendData({required this.date, required this.applications});
}

class DepartmentStats {
  final String department;
  final int applications;
  final double percentage;

  DepartmentStats({
    required this.department,
    required this.applications,
    required this.percentage,
  });
}

class JobPerformanceData {
  final String jobTitle;
  final int applications;
  final int views;
  final int shortlisted;
  final int interviewed;
  final int selected;
  final double conversionRate;

  JobPerformanceData({
    required this.jobTitle,
    required this.applications,
    required this.views,
    required this.shortlisted,
    required this.interviewed,
    required this.selected,
    required this.conversionRate,
  });
}

class MonthlyMetrics {
  final String month;
  final int applications;
  final int interviews;
  final int selections;

  MonthlyMetrics({
    required this.month,
    required this.applications,
    required this.interviews,
    required this.selections,
  });
}
