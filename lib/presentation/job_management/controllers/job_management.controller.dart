import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobManagementController extends GetxController {
  // Reactive variables
  var isLoading = false.obs;
  var selectedTab = 0.obs;
  var selectedJobId = ''.obs;
  var isCreatingJob = false.obs;
  var searchQuery = ''.obs;

  // Job data
  var allJobs = <JobPosting>[].obs;
  var filteredJobs = <JobPosting>[].obs;
  var jobStatistics = <String, dynamic>{}.obs;
  var recentActivities = <JobActivity>[].obs;

  // Filters and settings
  var selectedStatus = 'All'.obs;
  var selectedDepartment = 'All'.obs;
  var selectedPriority = 'All'.obs;
  var selectedJobType = 'All'.obs;
  var dateFilter = 'All Time'.obs;

  // Form controllers
  final searchController = TextEditingController();
  final jobTitleController = TextEditingController();
  final jobDescriptionController = TextEditingController();
  final requirementsController = TextEditingController();
  final benefitsController = TextEditingController();
  final salaryMinController = TextEditingController();
  final salaryMaxController = TextEditingController();

  // Dropdown options
  final statusOptions = [
    'All',
    'Draft',
    'Published',
    'Closed',
    'On Hold',
    'Archived',
  ];
  final departmentOptions = [
    'All',
    'Engineering',
    'Product',
    'Design',
    'Marketing',
    'Sales',
    'HR',
    'Finance',
  ];
  final priorityOptions = ['All', 'Low', 'Medium', 'High', 'Urgent'];
  final jobTypeOptions = [
    'All',
    'Full Time',
    'Part Time',
    'Contract',
    'Internship',
    'Remote',
  ];
  final experienceOptions = [
    'Fresher',
    '0-1 years',
    '1-3 years',
    '3-5 years',
    '5+ years',
  ];
  final locationOptions = [
    'Bangalore',
    'Mumbai',
    'Delhi',
    'Chennai',
    'Hyderabad',
    'Pune',
    'Remote',
  ];

  @override
  void onInit() {
    super.onInit();
    loadJobData();
    searchController.addListener(_onSearchChanged);
    _startPeriodicUpdates();
  }

  @override
  void onClose() {
    searchController.dispose();
    jobTitleController.dispose();
    jobDescriptionController.dispose();
    requirementsController.dispose();
    benefitsController.dispose();
    salaryMinController.dispose();
    salaryMaxController.dispose();
    super.onClose();
  }

  void loadJobData() {
    isLoading.value = true;

    Future.delayed(Duration(seconds: 1), () {
      _loadMockData();
      applyFilters();
      _calculateStatistics();
      isLoading.value = false;
    });
  }

  void _loadMockData() {
    allJobs.value = [
      JobPosting(
        id: 'job_1',
        title: 'Senior Software Engineer',
        department: 'Engineering',
        description:
            'We are looking for an experienced software engineer to join our team...',
        requirements: [
          '5+ years experience',
          'React/Flutter expertise',
          'Strong problem-solving skills',
        ],
        benefits: [
          'Health insurance',
          'Flexible working hours',
          'Professional development',
        ],
        status: JobStatus.published,
        priority: JobPriority.high,
        jobType: 'Full Time',
        experience: '3-5 years',
        location: 'Bangalore',
        salaryMin: 120000,
        salaryMax: 180000,
        postedDate: DateTime.now().subtract(Duration(days: 5)),
        deadline: DateTime.now().add(Duration(days: 25)),
        applicationsCount: 89,
        viewsCount: 456,
        shortlistedCount: 12,
        postedBy: 'Sarah Johnson',
        tags: ['React', 'Flutter', 'JavaScript', 'API'],
      ),

      JobPosting(
        id: 'job_2',
        title: 'Product Manager',
        department: 'Product',
        description:
            'Looking for a strategic product manager to drive product vision...',
        requirements: [
          '3+ years PM experience',
          'Strong analytical skills',
          'Leadership experience',
        ],
        benefits: ['Stock options', 'Health insurance', 'Remote work options'],
        status: JobStatus.published,
        priority: JobPriority.medium,
        jobType: 'Full Time',
        experience: '3-5 years',
        location: 'Mumbai',
        salaryMin: 150000,
        salaryMax: 220000,
        postedDate: DateTime.now().subtract(Duration(days: 12)),
        deadline: DateTime.now().add(Duration(days: 18)),
        applicationsCount: 67,
        viewsCount: 234,
        shortlistedCount: 8,
        postedBy: 'Mike Wilson',
        tags: ['Strategy', 'Analytics', 'Leadership', 'Agile'],
      ),

      JobPosting(
        id: 'job_3',
        title: 'Data Scientist',
        department: 'Engineering',
        description:
            'Join our data science team to build ML models and analytics...',
        requirements: [
          'Python/R expertise',
          'ML/AI experience',
          'Statistics background',
        ],
        benefits: [
          'Learning budget',
          'Conference attendance',
          'Flexible hours',
        ],
        status: JobStatus.draft,
        priority: JobPriority.high,
        jobType: 'Full Time',
        experience: '1-3 years',
        location: 'Bangalore',
        salaryMin: 100000,
        salaryMax: 150000,
        postedDate: DateTime.now().subtract(Duration(days: 2)),
        deadline: DateTime.now().add(Duration(days: 28)),
        applicationsCount: 34,
        viewsCount: 123,
        shortlistedCount: 5,
        postedBy: 'Emily Davis',
        tags: ['Python', 'Machine Learning', 'Statistics', 'SQL'],
      ),

      JobPosting(
        id: 'job_4',
        title: 'UX Designer',
        department: 'Design',
        description:
            'Creative UX designer to craft amazing user experiences...',
        requirements: [
          'UI/UX portfolio',
          'Figma/Sketch expertise',
          'User research skills',
        ],
        benefits: ['Design tools budget', 'Creative freedom', 'Team outings'],
        status: JobStatus.published,
        priority: JobPriority.medium,
        jobType: 'Full Time',
        experience: '1-3 years',
        location: 'Delhi',
        salaryMin: 80000,
        salaryMax: 120000,
        postedDate: DateTime.now().subtract(Duration(days: 8)),
        deadline: DateTime.now().add(Duration(days: 22)),
        applicationsCount: 45,
        viewsCount: 189,
        shortlistedCount: 7,
        postedBy: 'Alex Chen',
        tags: ['Figma', 'User Research', 'Prototyping', 'Design Systems'],
      ),

      JobPosting(
        id: 'job_5',
        title: 'Marketing Intern',
        department: 'Marketing',
        description: 'Exciting internship opportunity in digital marketing...',
        requirements: [
          'Marketing background',
          'Social media knowledge',
          'Creative thinking',
        ],
        benefits: [
          'Mentorship program',
          'Certificate',
          'Networking opportunities',
        ],
        status: JobStatus.published,
        priority: JobPriority.low,
        jobType: 'Internship',
        experience: 'Fresher',
        location: 'Remote',
        salaryMin: 15000,
        salaryMax: 25000,
        postedDate: DateTime.now().subtract(Duration(days: 1)),
        deadline: DateTime.now().add(Duration(days: 29)),
        applicationsCount: 156,
        viewsCount: 678,
        shortlistedCount: 23,
        postedBy: 'Lisa Brown',
        tags: [
          'Digital Marketing',
          'Social Media',
          'Content Creation',
          'Analytics',
        ],
      ),

      JobPosting(
        id: 'job_6',
        title: 'DevOps Engineer',
        department: 'Engineering',
        description:
            'DevOps engineer to manage cloud infrastructure and deployments...',
        requirements: [
          'AWS/Azure experience',
          'Docker/Kubernetes',
          'CI/CD pipelines',
        ],
        benefits: [
          'Cloud certifications',
          'Latest tools access',
          'Flexible schedule',
        ],
        status: JobStatus.closed,
        priority: JobPriority.medium,
        jobType: 'Full Time',
        experience: '3-5 years',
        location: 'Chennai',
        salaryMin: 130000,
        salaryMax: 170000,
        postedDate: DateTime.now().subtract(Duration(days: 45)),
        deadline: DateTime.now().subtract(Duration(days: 15)),
        applicationsCount: 78,
        viewsCount: 345,
        shortlistedCount: 10,
        postedBy: 'John Smith',
        tags: ['AWS', 'Docker', 'Kubernetes', 'Jenkins'],
      ),
    ];

    // Mock recent activities
    recentActivities.value = [
      JobActivity(
        id: 'activity_1',
        type: ActivityType.jobPosted,
        jobId: 'job_1',
        jobTitle: 'Senior Software Engineer',
        description: 'Job posted successfully',
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        userName: 'Sarah Johnson',
      ),
      JobActivity(
        id: 'activity_2',
        type: ActivityType.applicationReceived,
        jobId: 'job_2',
        jobTitle: 'Product Manager',
        description: 'New application received from John Doe',
        timestamp: DateTime.now().subtract(Duration(hours: 4)),
        userName: 'System',
      ),
      JobActivity(
        id: 'activity_3',
        type: ActivityType.jobUpdated,
        jobId: 'job_3',
        jobTitle: 'Data Scientist',
        description: 'Job requirements updated',
        timestamp: DateTime.now().subtract(Duration(hours: 6)),
        userName: 'Emily Davis',
      ),
    ];
  }

  void _onSearchChanged() {
    searchQuery.value = searchController.text;
    applyFilters();
  }

  void applyFilters() {
    var filtered = List<JobPosting>.from(allJobs);

    // Search filter
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered
          .where(
            (job) =>
                job.title.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ||
                job.department.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ||
                job.tags.any(
                  (tag) => tag.toLowerCase().contains(
                    searchQuery.value.toLowerCase(),
                  ),
                ),
          )
          .toList();
    }

    // Status filter
    if (selectedStatus.value != 'All') {
      final statusEnum = _getStatusEnum(selectedStatus.value);
      filtered = filtered.where((job) => job.status == statusEnum).toList();
    }

    // Department filter
    if (selectedDepartment.value != 'All') {
      filtered = filtered
          .where((job) => job.department == selectedDepartment.value)
          .toList();
    }

    // Priority filter
    if (selectedPriority.value != 'All') {
      final priorityEnum = _getPriorityEnum(selectedPriority.value);
      filtered = filtered.where((job) => job.priority == priorityEnum).toList();
    }

    // Job type filter
    if (selectedJobType.value != 'All') {
      filtered = filtered
          .where((job) => job.jobType == selectedJobType.value)
          .toList();
    }

    // Sort by posting date (newest first)
    filtered.sort((a, b) => b.postedDate.compareTo(a.postedDate));

    filteredJobs.value = filtered;
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }

  void selectJob(String jobId) {
    selectedJobId.value = jobId;
  }

  Future<void> createJob({
    required String title,
    required String department,
    required String description,
    required List<String> requirements,
    required List<String> benefits,
    required String jobType,
    required String experience,
    required String location,
    required int salaryMin,
    required int salaryMax,
    required DateTime deadline,
    required JobPriority priority,
    required List<String> tags,
  }) async {
    try {
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(Duration(seconds: 1));

      final newJob = JobPosting(
        id: 'job_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        department: department,
        description: description,
        requirements: requirements,
        benefits: benefits,
        status: JobStatus.draft,
        priority: priority,
        jobType: jobType,
        experience: experience,
        location: location,
        salaryMin: salaryMin,
        salaryMax: salaryMax,
        postedDate: DateTime.now(),
        deadline: deadline,
        applicationsCount: 0,
        viewsCount: 0,
        shortlistedCount: 0,
        postedBy: 'Current User',
        tags: tags,
      );

      allJobs.insert(0, newJob);
      applyFilters();
      _calculateStatistics();

      // Add activity
      recentActivities.insert(
        0,
        JobActivity(
          id: 'activity_${DateTime.now().millisecondsSinceEpoch}',
          type: ActivityType.jobCreated,
          jobId: newJob.id,
          jobTitle: newJob.title,
          description: 'New job created as draft',
          timestamp: DateTime.now(),
          userName: 'Current User',
        ),
      );

      // Clear form
      _clearJobForm();

      Get.snackbar(
        'Success',
        'Job "$title" created successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Switch to jobs tab
      selectedTab.value = 0;
    } catch (e) {
      Get.snackbar('Error', 'Failed to create job. Please try again.');
    } finally {
      isLoading.value = false;
      isCreatingJob.value = false;
    }
  }

  Future<void> updateJobStatus(String jobId, JobStatus newStatus) async {
    try {
      final jobIndex = allJobs.indexWhere((job) => job.id == jobId);
      if (jobIndex == -1) return;

      final oldStatus = allJobs[jobIndex].status;
      allJobs[jobIndex] = allJobs[jobIndex].copyWith(status: newStatus);

      // Add activity
      recentActivities.insert(
        0,
        JobActivity(
          id: 'activity_${DateTime.now().millisecondsSinceEpoch}',
          type: _getActivityTypeForStatus(newStatus),
          jobId: jobId,
          jobTitle: allJobs[jobIndex].title,
          description:
              'Status changed from ${_getStatusString(oldStatus)} to ${_getStatusString(newStatus)}',
          timestamp: DateTime.now(),
          userName: 'Current User',
        ),
      );

      applyFilters();
      _calculateStatistics();

      Get.snackbar(
        'Status Updated',
        'Job status updated to ${_getStatusString(newStatus)}',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to update job status');
    }
  }

  Future<void> duplicateJob(String jobId) async {
    try {
      final originalJob = allJobs.firstWhereOrNull((job) => job.id == jobId);
      if (originalJob == null) return;

      final duplicatedJob = originalJob.copyWith(
        id: 'job_${DateTime.now().millisecondsSinceEpoch}',
        title: '${originalJob.title} (Copy)',
        status: JobStatus.draft,
        postedDate: DateTime.now(),
        deadline: DateTime.now().add(Duration(days: 30)),
        applicationsCount: 0,
        viewsCount: 0,
        shortlistedCount: 0,
        postedBy: 'Current User',
      );

      allJobs.insert(0, duplicatedJob);
      applyFilters();

      Get.snackbar(
        'Job Duplicated',
        'Job duplicated successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to duplicate job');
    }
  }

  Future<void> deleteJob(String jobId) async {
    Get.dialog(
      AlertDialog(
        title: Text('Delete Job'),
        content: Text(
          'Are you sure you want to delete this job? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Get.back();

              try {
                final job = allJobs.firstWhereOrNull((j) => j.id == jobId);
                if (job != null) {
                  allJobs.removeWhere((j) => j.id == jobId);

                  // Add activity
                  recentActivities.insert(
                    0,
                    JobActivity(
                      id: 'activity_${DateTime.now().millisecondsSinceEpoch}',
                      type: ActivityType.jobDeleted,
                      jobId: jobId,
                      jobTitle: job.title,
                      description: 'Job deleted permanently',
                      timestamp: DateTime.now(),
                      userName: 'Current User',
                    ),
                  );

                  applyFilters();
                  _calculateStatistics();

                  if (selectedJobId.value == jobId) {
                    selectedJobId.value = '';
                  }

                  Get.snackbar(
                    'Job Deleted',
                    'Job deleted successfully',
                    backgroundColor: Colors.orange,
                    colorText: Colors.white,
                  );
                }
              } catch (e) {
                Get.snackbar('Error', 'Failed to delete job');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _calculateStatistics() {
    final total = allJobs.length;
    final published = allJobs
        .where((job) => job.status == JobStatus.published)
        .length;
    final draft = allJobs.where((job) => job.status == JobStatus.draft).length;
    final closed = allJobs
        .where((job) => job.status == JobStatus.closed)
        .length;
    final totalApplications = allJobs.fold<int>(
      0,
      (sum, job) => sum + job.applicationsCount,
    );
    final totalViews = allJobs.fold<int>(0, (sum, job) => sum + job.viewsCount);
    final avgApplicationsPerJob = total > 0
        ? (totalApplications / total).round()
        : 0;

    jobStatistics.value = {
      'total': total,
      'published': published,
      'draft': draft,
      'closed': closed,
      'totalApplications': totalApplications,
      'totalViews': totalViews,
      'avgApplicationsPerJob': avgApplicationsPerJob,
    };
  }

  void _clearJobForm() {
    jobTitleController.clear();
    jobDescriptionController.clear();
    requirementsController.clear();
    benefitsController.clear();
    salaryMinController.clear();
    salaryMaxController.clear();
  }

  void _startPeriodicUpdates() {
    Timer.periodic(Duration(minutes: 5), (timer) {
      // Simulate real-time updates (new applications, views, etc.)
      if (allJobs.isNotEmpty) {
        final randomJob = allJobs[DateTime.now().millisecond % allJobs.length];
        final index = allJobs.indexWhere((job) => job.id == randomJob.id);

        if (index != -1) {
          allJobs[index] = allJobs[index].copyWith(
            applicationsCount:
                randomJob.applicationsCount + (DateTime.now().millisecond % 3),
            viewsCount:
                randomJob.viewsCount + (DateTime.now().millisecond % 10),
          );

          applyFilters();
          _calculateStatistics();
        }
      }
    });
  }

  void startCreatingJob() {
    isCreatingJob.value = true;
    selectedTab.value = 1; // Switch to create job tab
  }

  void cancelCreatingJob() {
    isCreatingJob.value = false;
    _clearJobForm();
  }

  void refreshJobs() {
    loadJobData();
  }

  // Helper methods
  JobStatus _getStatusEnum(String status) {
    switch (status) {
      case 'Draft':
        return JobStatus.draft;
      case 'Published':
        return JobStatus.published;
      case 'Closed':
        return JobStatus.closed;
      case 'On Hold':
        return JobStatus.onHold;
      case 'Archived':
        return JobStatus.archived;
      default:
        return JobStatus.draft;
    }
  }

  JobPriority _getPriorityEnum(String priority) {
    switch (priority) {
      case 'Low':
        return JobPriority.low;
      case 'Medium':
        return JobPriority.medium;
      case 'High':
        return JobPriority.high;
      case 'Urgent':
        return JobPriority.urgent;
      default:
        return JobPriority.medium;
    }
  }

  String _getStatusString(JobStatus status) {
    switch (status) {
      case JobStatus.draft:
        return 'Draft';
      case JobStatus.published:
        return 'Published';
      case JobStatus.closed:
        return 'Closed';
      case JobStatus.onHold:
        return 'On Hold';
      case JobStatus.archived:
        return 'Archived';
    }
  }

  ActivityType _getActivityTypeForStatus(JobStatus status) {
    switch (status) {
      case JobStatus.published:
        return ActivityType.jobPublished;
      case JobStatus.closed:
        return ActivityType.jobClosed;
      default:
        return ActivityType.jobUpdated;
    }
  }
}

// Data Models
class JobPosting {
  final String id;
  final String title;
  final String department;
  final String description;
  final List<String> requirements;
  final List<String> benefits;
  final JobStatus status;
  final JobPriority priority;
  final String jobType;
  final String experience;
  final String location;
  final int salaryMin;
  final int salaryMax;
  final DateTime postedDate;
  final DateTime deadline;
  final int applicationsCount;
  final int viewsCount;
  final int shortlistedCount;
  final String postedBy;
  final List<String> tags;

  JobPosting({
    required this.id,
    required this.title,
    required this.department,
    required this.description,
    required this.requirements,
    required this.benefits,
    required this.status,
    required this.priority,
    required this.jobType,
    required this.experience,
    required this.location,
    required this.salaryMin,
    required this.salaryMax,
    required this.postedDate,
    required this.deadline,
    required this.applicationsCount,
    required this.viewsCount,
    required this.shortlistedCount,
    required this.postedBy,
    required this.tags,
  });

  JobPosting copyWith({
    String? id,
    String? title,
    String? department,
    String? description,
    List<String>? requirements,
    List<String>? benefits,
    JobStatus? status,
    JobPriority? priority,
    String? jobType,
    String? experience,
    String? location,
    int? salaryMin,
    int? salaryMax,
    DateTime? postedDate,
    DateTime? deadline,
    int? applicationsCount,
    int? viewsCount,
    int? shortlistedCount,
    String? postedBy,
    List<String>? tags,
  }) {
    return JobPosting(
      id: id ?? this.id,
      title: title ?? this.title,
      department: department ?? this.department,
      description: description ?? this.description,
      requirements: requirements ?? this.requirements,
      benefits: benefits ?? this.benefits,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      jobType: jobType ?? this.jobType,
      experience: experience ?? this.experience,
      location: location ?? this.location,
      salaryMin: salaryMin ?? this.salaryMin,
      salaryMax: salaryMax ?? this.salaryMax,
      postedDate: postedDate ?? this.postedDate,
      deadline: deadline ?? this.deadline,
      applicationsCount: applicationsCount ?? this.applicationsCount,
      viewsCount: viewsCount ?? this.viewsCount,
      shortlistedCount: shortlistedCount ?? this.shortlistedCount,
      postedBy: postedBy ?? this.postedBy,
      tags: tags ?? this.tags,
    );
  }
}

class JobActivity {
  final String id;
  final ActivityType type;
  final String jobId;
  final String jobTitle;
  final String description;
  final DateTime timestamp;
  final String userName;

  JobActivity({
    required this.id,
    required this.type,
    required this.jobId,
    required this.jobTitle,
    required this.description,
    required this.timestamp,
    required this.userName,
  });
}

enum JobStatus { draft, published, closed, onHold, archived }

enum JobPriority { low, medium, high, urgent }

enum ActivityType {
  jobCreated,
  jobPosted,
  jobPublished,
  jobUpdated,
  jobClosed,
  jobDeleted,
  applicationReceived,
  candidateShortlisted,
}
