import '../models/job_enums.dart';
import '../models/job_posting_model.dart';

abstract class JobRepository {
  Future<List<JobPostingModel>> getAllJobs();

  Future<List<JobPostingModel>> getJobsByCompany(String companyId);

  Future<JobPostingModel> getJobById(String id);

  Future<JobPostingModel> createJob(JobPostingModel job);

  Future<JobPostingModel> updateJob(JobPostingModel job);

  Future<bool> deleteJob(String id);

  Future<bool> publishJob(String id);

  Future<bool> pauseJob(String id);

  Future<bool> closeJob(String id);

  Future<List<JobPostingModel>> getActiveJobs();

  Future<List<JobPostingModel>> getDraftJobs();

  Future<List<JobPostingModel>> getExpiredJobs();

  Future<JobStats> getJobStatistics(String jobId);

  Future<List<JobPostingModel>> searchJobs(JobSearchFilters filters);

  Future<bool> duplicateJob(String jobId);

  Future<List<String>> getJobTemplates();

  Future<JobPostingModel> createJobFromTemplate(String templateId);
}

class JobRepositoryImpl implements JobRepository {
  // Mock data storage
  List<JobPostingModel> _jobs = [];
  bool _isInitialized = false;

  JobRepositoryImpl() {
    _initializeMockData();
  }

  void _initializeMockData() {
    if (_isInitialized) return;

    _jobs = [
      JobPostingModel(
        id: 'job_1',
        title: 'Software Development Engineer',
        description:
            'We are looking for passionate software developers to join our engineering team. You will be working on cutting-edge technology projects and contributing to product development.',
        companyId: 'company_1',
        companyName: 'TechCorp Solutions',
        recruiterId: 'recruiter_1',
        recruiterName: 'John Recruiter',
        jobType: JobType.fullTime,
        workMode: WorkMode.hybrid,
        location: 'Bangalore, Karnataka',
        skills: ['Java', 'Spring Boot', 'React', 'MySQL', 'AWS'],
        departments: ['Computer Science', 'Information Technology'],
        requirements: JobRequirements(
          minimumEducation: 'Bachelor\'s Degree',
          minimumCGPA: 7.0,
          minimumExperience: 0,
          maximumExperience: 2,
          mandatorySkills: ['Java', 'Spring Boot'],
          preferredSkills: ['React', 'AWS', 'Docker'],
          certifications: [],
          allowBacklogs: true,
          maxBacklogs: 2,
          eligibleBranches: [
            'Computer Science',
            'Information Technology',
            'Electronics',
          ],
          additionalCriteria: {},
        ),
        salaryRange: SalaryRange(
          minimumSalary: 6.0,
          maximumSalary: 12.0,
          currency: 'INR',
          salaryType: SalaryType.annual,
          benefits: [
            'Health Insurance',
            'PF',
            'Flexible Hours',
            'Learning Budget',
          ],
          additionalCompensation: {
            'bonus': 'Performance based',
            'stock_options': false,
          },
        ),
        applicationDeadline: DateTime.now().add(Duration(days: 30)),
        status: JobStatus.published,
        totalApplications: 125,
        shortlistedCount: 28,
        interviewedCount: 15,
        selectedCount: 5,
        recruitmentRounds: [
          RecruitmentRound(
            id: 'round_1',
            name: 'Online Assessment',
            roundType: RoundType.onlineTest,
            order: 1,
            description: 'Technical aptitude and coding test',
            scheduledDate: DateTime.now().add(Duration(days: 7)),
            venue: 'Online Platform',
            duration: 90,
            status: RoundStatus.scheduled,
            eligibleCandidates: [],
            selectedCandidates: [],
            settings: {},
          ),
          RecruitmentRound(
            id: 'round_2',
            name: 'Technical Interview',
            roundType: RoundType.technicalInterview,
            order: 2,
            description: 'Technical discussion and problem solving',
            scheduledDate: DateTime.now().add(Duration(days: 14)),
            venue: 'Office / Video Call',
            duration: 60,
            status: RoundStatus.planned,
            eligibleCandidates: [],
            selectedCandidates: [],
            settings: {},
          ),
          RecruitmentRound(
            id: 'round_3',
            name: 'HR Interview',
            roundType: RoundType.hrInterview,
            order: 3,
            description: 'Cultural fit and HR discussion',
            scheduledDate: DateTime.now().add(Duration(days: 21)),
            venue: 'Office',
            duration: 45,
            status: RoundStatus.planned,
            eligibleCandidates: [],
            selectedCandidates: [],
            settings: {},
          ),
        ],
        customFields: {},
        isActive: true,
        isFeatured: true,
        createdAt: DateTime.now().subtract(Duration(days: 15)),
        updatedAt: DateTime.now().subtract(Duration(days: 2)),
        publishedAt: DateTime.now().subtract(Duration(days: 10)),
      ),

      JobPostingModel(
        id: 'job_2',
        title: 'Frontend Developer Intern',
        description:
            'Exciting internship opportunity for frontend developers to work on modern web applications using React and TypeScript.',
        companyId: 'company_1',
        companyName: 'TechCorp Solutions',
        recruiterId: 'recruiter_1',
        recruiterName: 'John Recruiter',
        jobType: JobType.internship,
        workMode: WorkMode.remote,
        location: 'Remote',
        skills: ['React', 'TypeScript', 'CSS', 'HTML', 'JavaScript'],
        departments: ['Computer Science', 'Information Technology'],
        requirements: JobRequirements(
          minimumEducation: 'Pursuing Bachelor\'s',
          minimumCGPA: 6.5,
          minimumExperience: 0,
          maximumExperience: 0,
          mandatorySkills: ['React', 'JavaScript'],
          preferredSkills: ['TypeScript', 'Redux', 'Material-UI'],
          certifications: [],
          allowBacklogs: true,
          maxBacklogs: 3,
          eligibleBranches: ['Computer Science', 'Information Technology'],
          additionalCriteria: {},
        ),
        salaryRange: SalaryRange(
          minimumSalary: 15000,
          maximumSalary: 25000,
          currency: 'INR',
          salaryType: SalaryType.monthly,
          benefits: ['Certificate', 'Learning Resources', 'Mentorship'],
          additionalCompensation: {
            'pre_placement_offer': 'Based on performance',
          },
        ),
        applicationDeadline: DateTime.now().add(Duration(days: 20)),
        status: JobStatus.published,
        totalApplications: 89,
        shortlistedCount: 22,
        interviewedCount: 8,
        selectedCount: 3,
        recruitmentRounds: [
          RecruitmentRound(
            id: 'round_4',
            name: 'Portfolio Review',
            roundType: RoundType.presentation,
            order: 1,
            description: 'Portfolio and project presentation',
            scheduledDate: DateTime.now().add(Duration(days: 5)),
            venue: 'Video Call',
            duration: 30,
            status: RoundStatus.scheduled,
            eligibleCandidates: [],
            selectedCandidates: [],
            settings: {},
          ),
          RecruitmentRound(
            id: 'round_5',
            name: 'Technical Round',
            roundType: RoundType.technicalInterview,
            order: 2,
            description: 'Live coding and technical questions',
            scheduledDate: DateTime.now().add(Duration(days: 12)),
            venue: 'Video Call',
            duration: 45,
            status: RoundStatus.planned,
            eligibleCandidates: [],
            selectedCandidates: [],
            settings: {},
          ),
        ],
        customFields: {},
        isActive: true,
        isFeatured: false,
        createdAt: DateTime.now().subtract(Duration(days: 8)),
        updatedAt: DateTime.now().subtract(Duration(days: 1)),
        publishedAt: DateTime.now().subtract(Duration(days: 5)),
      ),

      JobPostingModel(
        id: 'job_3',
        title: 'Data Scientist',
        description:
            'Join our data science team to work on machine learning models and data analytics projects.',
        companyId: 'company_1',
        companyName: 'TechCorp Solutions',
        recruiterId: 'recruiter_2',
        recruiterName: 'Sarah Manager',
        jobType: JobType.fullTime,
        workMode: WorkMode.onsite,
        location: 'Chennai, Tamil Nadu',
        skills: ['Python', 'Machine Learning', 'SQL', 'TensorFlow', 'Pandas'],
        departments: ['Computer Science', 'Statistics', 'Mathematics'],
        requirements: JobRequirements(
          minimumEducation: 'Bachelor\'s Degree',
          minimumCGPA: 7.5,
          minimumExperience: 0,
          maximumExperience: 3,
          mandatorySkills: ['Python', 'Machine Learning', 'SQL'],
          preferredSkills: ['TensorFlow', 'PyTorch', 'R', 'Tableau'],
          certifications: ['Google Data Analytics', 'AWS ML'],
          allowBacklogs: false,
          maxBacklogs: 0,
          eligibleBranches: [
            'Computer Science',
            'Statistics',
            'Mathematics',
            'Data Science',
          ],
          additionalCriteria: {'projects': 'ML projects required'},
        ),
        salaryRange: SalaryRange(
          minimumSalary: 8.0,
          maximumSalary: 15.0,
          currency: 'INR',
          salaryType: SalaryType.annual,
          benefits: [
            'Health Insurance',
            'PF',
            'Research Budget',
            'Conference Attendance',
          ],
          additionalCompensation: {'research_bonus': 'Publication incentives'},
        ),
        applicationDeadline: DateTime.now().add(Duration(days: 25)),
        status: JobStatus.published,
        totalApplications: 67,
        shortlistedCount: 15,
        interviewedCount: 8,
        selectedCount: 2,
        recruitmentRounds: [
          RecruitmentRound(
            id: 'round_6',
            name: 'Data Science Challenge',
            roundType: RoundType.caseStudy,
            order: 1,
            description: 'Take-home data science problem',
            scheduledDate: DateTime.now().add(Duration(days: 10)),
            venue: 'Take Home',
            duration: 480,
            // 8 hours
            status: RoundStatus.planned,
            eligibleCandidates: [],
            selectedCandidates: [],
            settings: {},
          ),
        ],
        customFields: {},
        isActive: true,
        isFeatured: true,
        createdAt: DateTime.now().subtract(Duration(days: 12)),
        updatedAt: DateTime.now().subtract(Duration(days: 3)),
        publishedAt: DateTime.now().subtract(Duration(days: 8)),
      ),

      JobPostingModel(
        id: 'job_4',
        title: 'Product Manager Trainee',
        description:
            'Entry-level product management role for fresh graduates interested in product strategy and development.',
        companyId: 'company_2',
        companyName: 'InnovateTech',
        recruiterId: 'recruiter_3',
        recruiterName: 'Mike Product',
        jobType: JobType.fullTime,
        workMode: WorkMode.hybrid,
        location: 'Mumbai, Maharashtra',
        skills: ['Product Management', 'Analytics', 'Communication', 'Agile'],
        departments: ['MBA', 'Engineering', 'Computer Science'],
        requirements: JobRequirements(
          minimumEducation: 'Bachelor\'s Degree',
          minimumCGPA: 7.0,
          minimumExperience: 0,
          maximumExperience: 1,
          mandatorySkills: ['Communication', 'Analytics'],
          preferredSkills: ['Product Management', 'Agile', 'SQL', 'Excel'],
          certifications: [],
          allowBacklogs: true,
          maxBacklogs: 1,
          eligibleBranches: ['Any'],
          additionalCriteria: {'leadership': 'Leadership experience preferred'},
        ),
        salaryRange: SalaryRange(
          minimumSalary: 7.0,
          maximumSalary: 10.0,
          currency: 'INR',
          salaryType: SalaryType.annual,
          benefits: [
            'Health Insurance',
            'PF',
            'Product Training',
            'Certification Budget',
          ],
          additionalCompensation: {'equity': 'Stock options available'},
        ),
        applicationDeadline: DateTime.now().add(Duration(days: 18)),
        status: JobStatus.draft,
        totalApplications: 0,
        shortlistedCount: 0,
        interviewedCount: 0,
        selectedCount: 0,
        recruitmentRounds: [],
        customFields: {},
        isActive: false,
        isFeatured: false,
        createdAt: DateTime.now().subtract(Duration(days: 3)),
        updatedAt: DateTime.now().subtract(Duration(hours: 5)),
        publishedAt: null,
      ),

      JobPostingModel(
        id: 'job_5',
        title: 'DevOps Engineer',
        description:
            'Looking for DevOps engineers to manage our cloud infrastructure and deployment pipelines.',
        companyId: 'company_2',
        companyName: 'InnovateTech',
        recruiterId: 'recruiter_3',
        recruiterName: 'Mike Product',
        jobType: JobType.fullTime,
        workMode: WorkMode.remote,
        location: 'Remote India',
        skills: ['AWS', 'Docker', 'Kubernetes', 'CI/CD', 'Linux'],
        departments: ['Computer Science', 'Information Technology'],
        requirements: JobRequirements(
          minimumEducation: 'Bachelor\'s Degree',
          minimumCGPA: 6.5,
          minimumExperience: 1,
          maximumExperience: 4,
          mandatorySkills: ['AWS', 'Docker', 'Linux'],
          preferredSkills: ['Kubernetes', 'Terraform', 'Jenkins', 'Python'],
          certifications: ['AWS Certified', 'Docker Certified'],
          allowBacklogs: true,
          maxBacklogs: 2,
          eligibleBranches: ['Computer Science', 'Information Technology'],
          additionalCriteria: {},
        ),
        salaryRange: SalaryRange(
          minimumSalary: 10.0,
          maximumSalary: 18.0,
          currency: 'INR',
          salaryType: SalaryType.annual,
          benefits: [
            'Health Insurance',
            'PF',
            'Home Office Setup',
            'Cloud Certifications',
          ],
          additionalCompensation: {'on_call': 'On-call allowance'},
        ),
        applicationDeadline: DateTime.now().add(Duration(days: 35)),
        status: JobStatus.paused,
        totalApplications: 45,
        shortlistedCount: 12,
        interviewedCount: 0,
        selectedCount: 0,
        recruitmentRounds: [
          RecruitmentRound(
            id: 'round_7',
            name: 'System Design',
            roundType: RoundType.technicalInterview,
            order: 1,
            description: 'Cloud architecture and system design',
            scheduledDate: null,
            venue: 'Video Call',
            duration: 90,
            status: RoundStatus.planned,
            eligibleCandidates: [],
            selectedCandidates: [],
            settings: {},
          ),
        ],
        customFields: {},
        isActive: false,
        isFeatured: false,
        createdAt: DateTime.now().subtract(Duration(days: 20)),
        updatedAt: DateTime.now().subtract(Duration(days: 5)),
        publishedAt: DateTime.now().subtract(Duration(days: 15)),
      ),
    ];

    _isInitialized = true;
  }

  @override
  Future<List<JobPostingModel>> getAllJobs() async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate API delay
    return List.from(_jobs);
  }

  @override
  Future<List<JobPostingModel>> getJobsByCompany(String companyId) async {
    await Future.delayed(Duration(milliseconds: 300));
    return _jobs.where((job) => job.companyId == companyId).toList();
  }

  @override
  Future<JobPostingModel> getJobById(String id) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _jobs.firstWhere(
      (job) => job.id == id,
      orElse: () => throw Exception('Job not found'),
    );
  }

  @override
  Future<JobPostingModel> createJob(JobPostingModel job) async {
    await Future.delayed(Duration(milliseconds: 800));
    final newJob = job.copyWith(
      id: 'job_${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
      totalApplications: 0,
      shortlistedCount: 0,
      interviewedCount: 0,
      selectedCount: 0,
    );
    _jobs.add(newJob);
    return newJob;
  }

  @override
  Future<JobPostingModel> updateJob(JobPostingModel job) async {
    await Future.delayed(Duration(milliseconds: 600));
    final index = _jobs.indexWhere((j) => j.id == job.id);
    if (index != -1) {
      _jobs[index] = job.copyWith(updatedAt: DateTime.now());
      return _jobs[index];
    }
    throw Exception('Job not found');
  }

  @override
  Future<bool> deleteJob(String id) async {
    await Future.delayed(Duration(milliseconds: 400));
    final index = _jobs.indexWhere((job) => job.id == id);
    if (index != -1) {
      _jobs.removeAt(index);
      return true;
    }
    return false;
  }

  @override
  Future<bool> publishJob(String id) async {
    await Future.delayed(Duration(milliseconds: 500));
    final index = _jobs.indexWhere((job) => job.id == id);
    if (index != -1) {
      _jobs[index] = _jobs[index].copyWith(
        status: JobStatus.published,
        isActive: true,
        publishedAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      return true;
    }
    return false;
  }

  @override
  Future<bool> pauseJob(String id) async {
    await Future.delayed(Duration(milliseconds: 300));
    final index = _jobs.indexWhere((job) => job.id == id);
    if (index != -1) {
      _jobs[index] = _jobs[index].copyWith(
        status: JobStatus.paused,
        isActive: false,
        updatedAt: DateTime.now(),
      );
      return true;
    }
    return false;
  }

  @override
  Future<bool> closeJob(String id) async {
    await Future.delayed(Duration(milliseconds: 300));
    final index = _jobs.indexWhere((job) => job.id == id);
    if (index != -1) {
      _jobs[index] = _jobs[index].copyWith(
        status: JobStatus.closed,
        isActive: false,
        updatedAt: DateTime.now(),
      );
      return true;
    }
    return false;
  }

  @override
  Future<List<JobPostingModel>> getActiveJobs() async {
    await Future.delayed(Duration(milliseconds: 300));
    return _jobs
        .where((job) => job.status == JobStatus.published && job.isActive)
        .toList();
  }

  @override
  Future<List<JobPostingModel>> getDraftJobs() async {
    await Future.delayed(Duration(milliseconds: 300));
    return _jobs.where((job) => job.status == JobStatus.draft).toList();
  }

  @override
  Future<List<JobPostingModel>> getExpiredJobs() async {
    await Future.delayed(Duration(milliseconds: 300));
    return _jobs
        .where(
          (job) =>
              job.status == JobStatus.expired ||
              DateTime.now().isAfter(job.applicationDeadline),
        )
        .toList();
  }

  @override
  Future<JobStats> getJobStatistics(String jobId) async {
    await Future.delayed(Duration(milliseconds: 400));
    final job = _jobs.firstWhere((j) => j.id == jobId);

    return JobStats(
      jobId: jobId,
      totalViews: job.totalApplications * 4,
      // Mock calculation
      totalApplications: job.totalApplications,
      shortlistedCount: job.shortlistedCount,
      interviewedCount: job.interviewedCount,
      selectedCount: job.selectedCount,
      rejectedCount: job.totalApplications - job.shortlistedCount,
      conversionRate: job.totalApplications > 0
          ? (job.selectedCount / job.totalApplications) * 100
          : 0.0,
      averageTimeToFill: 25,
      // Mock data
      departmentWiseApplications: {
        'Computer Science': (job.totalApplications * 0.6).round(),
        'Information Technology': (job.totalApplications * 0.25).round(),
        'Electronics': (job.totalApplications * 0.15).round(),
      },
      dailyApplicationTrends: _generateDailyTrends(),
    );
  }

  @override
  Future<List<JobPostingModel>> searchJobs(JobSearchFilters filters) async {
    await Future.delayed(Duration(milliseconds: 600));

    var filteredJobs = List<JobPostingModel>.from(_jobs);

    if (filters.title != null && filters.title!.isNotEmpty) {
      filteredJobs = filteredJobs
          .where(
            (job) =>
                job.title.toLowerCase().contains(filters.title!.toLowerCase()),
          )
          .toList();
    }

    if (filters.status != null) {
      filteredJobs = filteredJobs
          .where((job) => job.status == filters.status)
          .toList();
    }

    if (filters.jobType != null) {
      filteredJobs = filteredJobs
          .where((job) => job.jobType == filters.jobType)
          .toList();
    }

    if (filters.workMode != null) {
      filteredJobs = filteredJobs
          .where((job) => job.workMode == filters.workMode)
          .toList();
    }

    if (filters.location != null && filters.location!.isNotEmpty) {
      filteredJobs = filteredJobs
          .where(
            (job) => job.location.toLowerCase().contains(
              filters.location!.toLowerCase(),
            ),
          )
          .toList();
    }

    return filteredJobs;
  }

  @override
  Future<bool> duplicateJob(String jobId) async {
    await Future.delayed(Duration(milliseconds: 500));
    final originalJob = _jobs.firstWhere((job) => job.id == jobId);

    final duplicatedJob = originalJob.copyWith(
      id: 'job_${DateTime.now().millisecondsSinceEpoch}',
      title: '${originalJob.title} (Copy)',
      status: JobStatus.draft,
      isActive: false,
      totalApplications: 0,
      shortlistedCount: 0,
      interviewedCount: 0,
      selectedCount: 0,
      createdAt: DateTime.now(),
      updatedAt: null,
      publishedAt: null,
    );

    _jobs.add(duplicatedJob);
    return true;
  }

  @override
  Future<List<String>> getJobTemplates() async {
    await Future.delayed(Duration(milliseconds: 300));
    return [
      'Software Engineer Template',
      'Data Scientist Template',
      'Product Manager Template',
      'DevOps Engineer Template',
      'Frontend Developer Template',
      'Backend Developer Template',
      'Internship Template',
    ];
  }

  @override
  Future<JobPostingModel> createJobFromTemplate(String templateId) async {
    await Future.delayed(Duration(milliseconds: 800));

    // Mock template job creation
    final templateJob = JobPostingModel(
      id: 'job_${DateTime.now().millisecondsSinceEpoch}',
      title: 'New Job from $templateId',
      description: 'Template-based job description. Please update as needed.',
      companyId: 'company_1',
      companyName: 'TechCorp Solutions',
      recruiterId: 'recruiter_1',
      recruiterName: 'John Recruiter',
      jobType: JobType.fullTime,
      workMode: WorkMode.hybrid,
      location: 'Bangalore, Karnataka',
      skills: ['Skill 1', 'Skill 2', 'Skill 3'],
      departments: ['Computer Science'],
      requirements: JobRequirements(
        minimumEducation: 'Bachelor\'s Degree',
        minimumCGPA: 6.0,
        minimumExperience: 0,
        maximumExperience: 2,
        mandatorySkills: ['Skill 1'],
        preferredSkills: ['Skill 2'],
        certifications: [],
        allowBacklogs: true,
        maxBacklogs: 2,
        eligibleBranches: ['Computer Science'],
        additionalCriteria: {},
      ),
      salaryRange: SalaryRange(
        minimumSalary: 5.0,
        maximumSalary: 10.0,
        currency: 'INR',
        salaryType: SalaryType.annual,
        benefits: ['Health Insurance', 'PF'],
        additionalCompensation: {},
      ),
      applicationDeadline: DateTime.now().add(Duration(days: 30)),
      status: JobStatus.draft,
      totalApplications: 0,
      shortlistedCount: 0,
      interviewedCount: 0,
      selectedCount: 0,
      recruitmentRounds: [],
      customFields: {},
      isActive: false,
      isFeatured: false,
      createdAt: DateTime.now(),
    );

    _jobs.add(templateJob);
    return templateJob;
  }

  List<DailyTrend> _generateDailyTrends() {
    final trends = <DailyTrend>[];
    for (int i = 30; i >= 0; i--) {
      trends.add(
        DailyTrend(
          date: DateTime.now().subtract(Duration(days: i)),
          applications: (5 + (i % 8)).toDouble(),
        ),
      );
    }
    return trends;
  }
}

// Supporting classes
class JobSearchFilters {
  final String? title;
  final JobStatus? status;
  final JobType? jobType;
  final WorkMode? workMode;
  final String? location;
  final List<String>? skills;
  final String? companyId;

  JobSearchFilters({
    this.title,
    this.status,
    this.jobType,
    this.workMode,
    this.location,
    this.skills,
    this.companyId,
  });
}

class JobStats {
  final String jobId;
  final int totalViews;
  final int totalApplications;
  final int shortlistedCount;
  final int interviewedCount;
  final int selectedCount;
  final int rejectedCount;
  final double conversionRate;
  final int averageTimeToFill;
  final Map<String, int> departmentWiseApplications;
  final List<DailyTrend> dailyApplicationTrends;

  JobStats({
    required this.jobId,
    required this.totalViews,
    required this.totalApplications,
    required this.shortlistedCount,
    required this.interviewedCount,
    required this.selectedCount,
    required this.rejectedCount,
    required this.conversionRate,
    required this.averageTimeToFill,
    required this.departmentWiseApplications,
    required this.dailyApplicationTrends,
  });
}

class DailyTrend {
  final DateTime date;
  final double applications;

  DailyTrend({required this.date, required this.applications});
}
