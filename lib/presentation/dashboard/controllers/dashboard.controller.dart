import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  // Reactive variables
  var isLoading = false.obs;
  var selectedTimeRange = 'Last 30 Days'.obs;
  var selectedMetricCard = 0.obs;

  // Dashboard Stats
  var totalJobs = 0.obs;
  var activeJobs = 0.obs;
  var totalApplications = 0.obs;
  var shortlistedCandidates = 0.obs;
  var interviewsScheduled = 0.obs;
  var offersExtended = 0.obs;
  var candidatesHired = 0.obs;
  var avgTimeToHire = 0.obs;

  // Performance Metrics
  var applicationConversionRate = 0.0.obs;
  var interviewSuccessRate = 0.0.obs;
  var offerAcceptanceRate = 0.0.obs;
  var recruitmentEfficiency = 0.0.obs;

  // Data Collections
  var recentJobs = <JobSummary>[].obs;
  var recentApplications = <ApplicationSummary>[].obs;
  var upcomingInterviews = <InterviewSummary>[].obs;
  var topPerformingJobs = <JobPerformance>[].obs;
  var recruitmentTrends = <TrendData>[].obs;
  var departmentStats = <DepartmentStat>[].obs;
  var urgentTasks = <UrgentTask>[].obs;
  var notifications = <NotificationItem>[].obs;

  // Time range options
  final timeRanges = [
    'Last 7 Days',
    'Last 30 Days',
    'Last 90 Days',
    'Last 6 Months',
    'Last Year',
  ];

  // Quick Action Items
  final quickActions = [
    {
      'title': 'Post New Job',
      'icon': Icons.add_business_outlined,
      'color': Colors.blue,
    },
    {
      'title': 'Review Applications',
      'icon': Icons.assignment_outlined,
      'color': Colors.green,
    },
    {
      'title': 'Schedule Interviews',
      'icon': Icons.calendar_today_outlined,
      'color': Colors.orange,
    },
    {
      'title': 'Send Messages',
      'icon': Icons.message_outlined,
      'color': Colors.purple,
    },
    {
      'title': 'Generate Report',
      'icon': Icons.assessment_outlined,
      'color': Colors.teal,
    },
    {
      'title': 'Manage Pipeline',
      'icon': Icons.timeline_outlined,
      'color': Colors.red,
    },
  ];

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  void loadDashboardData() {
    isLoading.value = true;

    // Simulate API call
    Future.delayed(Duration(seconds: 2), () {
      _loadMockData();
      isLoading.value = false;
    });
  }

  void _loadMockData() {
    // Basic Stats
    totalJobs.value = 24;
    activeJobs.value = 18;
    totalApplications.value = 1247;
    shortlistedCandidates.value = 284;
    interviewsScheduled.value = 67;
    offersExtended.value = 32;
    candidatesHired.value = 28;
    avgTimeToHire.value = 18;

    // Performance Metrics
    applicationConversionRate.value = 22.8;
    interviewSuccessRate.value = 78.5;
    offerAcceptanceRate.value = 87.5;
    recruitmentEfficiency.value = 85.2;

    // Recent Jobs
    recentJobs.value = [
      JobSummary(
        id: '1',
        title: 'Senior Software Engineer',
        department: 'Engineering',
        applications: 89,
        status: 'Active',
        postedDate: DateTime.now().subtract(Duration(days: 3)),
        deadline: DateTime.now().add(Duration(days: 27)),
        priority: 'High',
      ),
      JobSummary(
        id: '2',
        title: 'Product Manager',
        department: 'Product',
        applications: 45,
        status: 'Active',
        postedDate: DateTime.now().subtract(Duration(days: 7)),
        deadline: DateTime.now().add(Duration(days: 23)),
        priority: 'Medium',
      ),
      JobSummary(
        id: '3',
        title: 'Data Scientist',
        department: 'Analytics',
        applications: 67,
        status: 'Draft',
        postedDate: DateTime.now().subtract(Duration(days: 1)),
        deadline: DateTime.now().add(Duration(days: 29)),
        priority: 'High',
      ),
      JobSummary(
        id: '4',
        title: 'UX Designer',
        department: 'Design',
        applications: 34,
        status: 'Active',
        postedDate: DateTime.now().subtract(Duration(days: 12)),
        deadline: DateTime.now().add(Duration(days: 18)),
        priority: 'Low',
      ),
    ];

    // Recent Applications
    recentApplications.value = [
      ApplicationSummary(
        id: '1',
        candidateName: 'Arjun Kumar',
        jobTitle: 'Senior Software Engineer',
        status: 'Shortlisted',
        appliedDate: DateTime.now().subtract(Duration(hours: 2)),
        college: 'VIT Vellore',
        cgpa: 8.5,
        experience: '6 months',
      ),
      ApplicationSummary(
        id: '2',
        candidateName: 'Priya Sharma',
        jobTitle: 'Data Scientist',
        status: 'Under Review',
        appliedDate: DateTime.now().subtract(Duration(hours: 5)),
        college: 'VIT Chennai',
        cgpa: 9.2,
        experience: 'Fresher',
      ),
      ApplicationSummary(
        id: '3',
        candidateName: 'Rajesh Patel',
        jobTitle: 'Product Manager',
        status: 'Interviewed',
        appliedDate: DateTime.now().subtract(Duration(days: 1)),
        college: 'VIT Bhopal',
        cgpa: 7.8,
        experience: '1 year',
      ),
      ApplicationSummary(
        id: '4',
        candidateName: 'Sneha Reddy',
        jobTitle: 'UX Designer',
        status: 'Shortlisted',
        appliedDate: DateTime.now().subtract(Duration(days: 2)),
        college: 'VIT AP',
        cgpa: 8.9,
        experience: 'Internship',
      ),
    ];

    // Upcoming Interviews
    upcomingInterviews.value = [
      InterviewSummary(
        id: '1',
        candidateName: 'Arjun Kumar',
        jobTitle: 'Senior Software Engineer',
        interviewType: 'Technical Round',
        scheduledTime: DateTime.now().add(Duration(hours: 4)),
        interviewer: 'John Smith',
        mode: 'Video Call',
        status: 'Confirmed',
      ),
      InterviewSummary(
        id: '2',
        candidateName: 'Priya Sharma',
        jobTitle: 'Data Scientist',
        interviewType: 'HR Round',
        scheduledTime: DateTime.now().add(Duration(days: 1, hours: 2)),
        interviewer: 'Sarah Johnson',
        mode: 'In-person',
        status: 'Pending',
      ),
      InterviewSummary(
        id: '3',
        candidateName: 'Amit Verma',
        jobTitle: 'Product Manager',
        interviewType: 'Final Round',
        scheduledTime: DateTime.now().add(Duration(days: 2)),
        interviewer: 'Mike Wilson',
        mode: 'Video Call',
        status: 'Confirmed',
      ),
    ];

    // Top Performing Jobs
    topPerformingJobs.value = [
      JobPerformance(
        jobTitle: 'Software Engineer',
        applications: 156,
        shortlisted: 38,
        interviewed: 22,
        hired: 8,
        conversionRate: 5.1,
        efficiency: 92.0,
      ),
      JobPerformance(
        jobTitle: 'Data Scientist',
        applications: 89,
        shortlisted: 23,
        interviewed: 14,
        hired: 5,
        conversionRate: 5.6,
        efficiency: 88.0,
      ),
      JobPerformance(
        jobTitle: 'Product Manager',
        applications: 67,
        shortlisted: 18,
        interviewed: 12,
        hired: 3,
        conversionRate: 4.5,
        efficiency: 85.0,
      ),
    ];

    // Recruitment Trends
    recruitmentTrends.value = List.generate(30, (index) {
      return TrendData(
        date: DateTime.now().subtract(Duration(days: 29 - index)),
        applications: 15 + (index % 12) + (index ~/ 10),
        shortlisted: 3 + (index % 5),
        interviewed: 1 + (index % 3),
        hired: index % 7 == 0 ? 1 : 0,
      );
    });

    // Department Stats
    departmentStats.value = [
      DepartmentStat(
        department: 'Engineering',
        openings: 8,
        filled: 5,
        applications: 456,
      ),
      DepartmentStat(
        department: 'Product',
        openings: 3,
        filled: 2,
        applications: 123,
      ),
      DepartmentStat(
        department: 'Design',
        openings: 4,
        filled: 3,
        applications: 234,
      ),
      DepartmentStat(
        department: 'Analytics',
        openings: 2,
        filled: 1,
        applications: 178,
      ),
    ];

    // Urgent Tasks
    urgentTasks.value = [
      UrgentTask(
        id: '1',
        title: 'Review Senior Developer Applications',
        description: 'High priority applications need immediate attention',
        priority: 'High',
        dueDate: DateTime.now().add(Duration(hours: 2)),
        category: 'Review',
      ),
      UrgentTask(
        id: '2',
        title: 'Schedule Technical Interviews',
        description: '5 candidates waiting for interview scheduling',
        priority: 'Medium',
        dueDate: DateTime.now().add(Duration(days: 1)),
        category: 'Scheduling',
      ),
      UrgentTask(
        id: '3',
        title: 'Job Posting Deadline',
        description: 'Product Manager position closes tomorrow',
        priority: 'High',
        dueDate: DateTime.now().add(Duration(hours: 18)),
        category: 'Job Management',
      ),
    ];

    // Notifications
    notifications.value = [
      NotificationItem(
        id: '1',
        title: 'New Application Received',
        message: 'Arjun Kumar applied for Senior Software Engineer',
        timestamp: DateTime.now().subtract(Duration(minutes: 15)),
        type: 'application',
        isRead: false,
      ),
      NotificationItem(
        id: '2',
        title: 'Interview Reminder',
        message: 'Technical interview with Priya Sharma in 1 hour',
        timestamp: DateTime.now().subtract(Duration(minutes: 45)),
        type: 'interview',
        isRead: false,
      ),
      NotificationItem(
        id: '3',
        title: 'Job Posting Approved',
        message: 'UX Designer position is now live',
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        type: 'job',
        isRead: true,
      ),
    ];
  }

  // Computed properties
  double get totalApplicationsGrowth => 12.5;

  double get hiringEfficiency =>
      (candidatesHired.value / totalApplications.value * 100);

  int get unreadNotifications => notifications.where((n) => !n.isRead).length;

  int get highPriorityTasks =>
      urgentTasks.where((task) => task.priority == 'High').length;

  void selectMetricCard(int index) {
    selectedMetricCard.value = index;
  }

  void changeTimeRange(String timeRange) {
    selectedTimeRange.value = timeRange;
    loadDashboardData(); // Reload data for new time range
  }

  void refreshDashboard() {
    loadDashboardData();
    Get.snackbar(
      'Dashboard Refreshed',
      'Latest data has been loaded',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
  }

  void markTaskComplete(String taskId) {
    urgentTasks.removeWhere((task) => task.id == taskId);
    Get.snackbar(
      'Task Completed',
      'Task has been marked as complete',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
  }

  void markNotificationRead(String notificationId) {
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      notifications[index] = NotificationItem(
        id: notifications[index].id,
        title: notifications[index].title,
        message: notifications[index].message,
        timestamp: notifications[index].timestamp,
        type: notifications[index].type,
        isRead: true,
      );
    }
  }

  void handleQuickAction(String action) {
    switch (action) {
      case 'Post New Job':
        Get.toNamed('/job-management', arguments: {'tab': 1});
        break;
      case 'Review Applications':
        Get.toNamed('/candidate-management');
        break;
      case 'Schedule Interviews':
        Get.toNamed('/interview-scheduling');
        break;
      case 'Send Messages':
        Get.toNamed('/group-management');
        break;
      case 'Generate Report':
        Get.toNamed('/analytics');
        break;
      case 'Manage Pipeline':
        Get.toNamed('/pipeline-management');
        break;
    }
  }
}

// Data Model Classes
class JobSummary {
  final String id;
  final String title;
  final String department;
  final int applications;
  final String status;
  final DateTime postedDate;
  final DateTime deadline;
  final String priority;

  JobSummary({
    required this.id,
    required this.title,
    required this.department,
    required this.applications,
    required this.status,
    required this.postedDate,
    required this.deadline,
    required this.priority,
  });
}

class ApplicationSummary {
  final String id;
  final String candidateName;
  final String jobTitle;
  final String status;
  final DateTime appliedDate;
  final String college;
  final double cgpa;
  final String experience;

  ApplicationSummary({
    required this.id,
    required this.candidateName,
    required this.jobTitle,
    required this.status,
    required this.appliedDate,
    required this.college,
    required this.cgpa,
    required this.experience,
  });
}

class InterviewSummary {
  final String id;
  final String candidateName;
  final String jobTitle;
  final String interviewType;
  final DateTime scheduledTime;
  final String interviewer;
  final String mode;
  final String status;

  InterviewSummary({
    required this.id,
    required this.candidateName,
    required this.jobTitle,
    required this.interviewType,
    required this.scheduledTime,
    required this.interviewer,
    required this.mode,
    required this.status,
  });
}

class JobPerformance {
  final String jobTitle;
  final int applications;
  final int shortlisted;
  final int interviewed;
  final int hired;
  final double conversionRate;
  final double efficiency;

  JobPerformance({
    required this.jobTitle,
    required this.applications,
    required this.shortlisted,
    required this.interviewed,
    required this.hired,
    required this.conversionRate,
    required this.efficiency,
  });
}

class TrendData {
  final DateTime date;
  final int applications;
  final int shortlisted;
  final int interviewed;
  final int hired;

  TrendData({
    required this.date,
    required this.applications,
    required this.shortlisted,
    required this.interviewed,
    required this.hired,
  });
}

class DepartmentStat {
  final String department;
  final int openings;
  final int filled;
  final int applications;

  DepartmentStat({
    required this.department,
    required this.openings,
    required this.filled,
    required this.applications,
  });
}

class UrgentTask {
  final String id;
  final String title;
  final String description;
  final String priority;
  final DateTime dueDate;
  final String category;

  UrgentTask({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
    required this.category,
  });
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final String type;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    required this.isRead,
  });
}
