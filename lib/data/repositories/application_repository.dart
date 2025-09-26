abstract class ApplicationRepository {
  Future<List<JobApplication>> getAllApplications();
  Future<List<JobApplication>> getApplicationsByJob(String jobId);
  Future<List<JobApplication>> getApplicationsByCandidate(String candidateId);
  Future<JobApplication> getApplicationById(String id);
  Future<JobApplication> createApplication(JobApplication application);
  Future<JobApplication> updateApplication(JobApplication application);
  Future<bool> deleteApplication(String id);
  Future<bool> shortlistApplication(String id);
  Future<bool> rejectApplication(String id, String reason);
  Future<bool> moveToNextRound(String id, String roundId);
  Future<List<JobApplication>> getShortlistedApplications(String jobId);
  Future<List<JobApplication>> getRejectedApplications(String jobId);
  Future<ApplicationStats> getApplicationStatistics(String jobId);
  Future<List<JobApplication>> searchApplications(
    ApplicationSearchFilters filters,
  );
  Future<bool> bulkUpdateApplicationStatus(
    List<String> applicationIds,
    ApplicationStatus status,
  );
  Future<List<JobApplication>> getApplicationsForRound(
    String jobId,
    String roundId,
  );
  Future<bool> scheduleInterview(
    String applicationId,
    InterviewSchedule schedule,
  );
  Future<List<InterviewSchedule>> getInterviewSchedules(String jobId);
}

class ApplicationRepositoryImpl implements ApplicationRepository {
  List<JobApplication> _applications = [];
  bool _isInitialized = false;

  ApplicationRepositoryImpl() {
    _initializeMockData();
  }

  void _initializeMockData() {
    if (_isInitialized) return;

    _applications = [
      JobApplication(
        id: 'app_1',
        jobId: 'job_1',
        jobTitle: 'Software Development Engineer',
        candidateId: 'candidate_1',
        candidateName: 'Arjun Kumar',
        candidateEmail: 'arjun.kumar@student.vit.ac.in',
        candidatePhone: '+91 9876543210',
        candidateCollege: 'VIT Vellore',
        candidateDepartment: 'Computer Science',
        candidateCGPA: 8.5,
        candidateGraduationYear: 2025,
        resumeUrl: 'https://example.com/resume1.pdf',
        coverLetter:
            'I am excited to apply for the Software Development Engineer position...',
        status: ApplicationStatus.shortlisted,
        currentRoundId: 'round_1',
        currentRoundName: 'Online Assessment',
        applicationData: {
          'skills': ['Java', 'Spring Boot', 'React', 'MySQL'],
          'projects': [
            {
              'name': 'E-commerce Platform',
              'description':
                  'Built a full-stack e-commerce platform using Java Spring Boot and React',
              'technologies': ['Java', 'Spring Boot', 'React', 'MySQL', 'AWS'],
              'github': 'https://github.com/arjun/ecommerce',
            },
          ],
          'experience': 'Internship at TechStart Solutions',
          'preferred_location': 'Bangalore',
          'notice_period': '0 days (Fresher)',
        },
        appliedAt: DateTime.now().subtract(Duration(days: 12)),
        updatedAt: DateTime.now().subtract(Duration(days: 3)),
        shortlistedAt: DateTime.now().subtract(Duration(days: 3)),
        score: 85.0,
        feedback: 'Strong technical background, good project experience',
        tags: ['java-expert', 'full-stack', 'fresh-graduate'],
        notes: 'Good candidate for SDE role, has relevant project experience',
      ),

      JobApplication(
        id: 'app_2',
        jobId: 'job_1',
        jobTitle: 'Software Development Engineer',
        candidateId: 'candidate_2',
        candidateName: 'Priya Sharma',
        candidateEmail: 'priya.sharma@student.vit.ac.in',
        candidatePhone: '+91 9876543220',
        candidateCollege: 'VIT Chennai',
        candidateDepartment: 'Information Technology',
        candidateCGPA: 9.2,
        candidateGraduationYear: 2025,
        resumeUrl: 'https://example.com/resume2.pdf',
        coverLetter:
            'With my strong background in software development and problem-solving skills...',
        status: ApplicationStatus.interviewed,
        currentRoundId: 'round_2',
        currentRoundName: 'Technical Interview',
        applicationData: {
          'skills': ['Python', 'Django', 'React', 'PostgreSQL', 'Docker'],
          'projects': [
            {
              'name': 'Task Management System',
              'description':
                  'Developed a comprehensive task management application',
              'technologies': ['Python', 'Django', 'React', 'PostgreSQL'],
            },
            {
              'name': 'Data Analysis Dashboard',
              'description':
                  'Created interactive dashboard for data visualization',
              'technologies': ['Python', 'Pandas', 'Plotly', 'Streamlit'],
            },
          ],
          'certifications': [
            'AWS Certified Developer',
            'Google Cloud Associate',
          ],
          'hackathons': [
            'Smart India Hackathon 2024 - Winner',
            'TechFest 2023 - Runner Up',
          ],
        },
        appliedAt: DateTime.now().subtract(Duration(days: 15)),
        updatedAt: DateTime.now().subtract(Duration(days: 1)),
        shortlistedAt: DateTime.now().subtract(Duration(days: 8)),
        interviewedAt: DateTime.now().subtract(Duration(days: 1)),
        score: 92.0,
        feedback:
            'Excellent technical skills, great communication, performed well in technical round',
        tags: ['python-expert', 'certified', 'top-performer'],
        notes: 'Outstanding candidate, strong technical and soft skills',
        interviewSchedule: InterviewSchedule(
          id: 'interview_1',
          applicationId: 'app_2',
          roundId: 'round_2',
          scheduledAt: DateTime.now().add(Duration(days: 2)),
          duration: 60,
          interviewerName: 'Tech Lead - Sarah Johnson',
          interviewerEmail: 'sarah.johnson@techcorp.com',
          meetingLink: 'https://meet.google.com/abc-def-ghi',
          venue: 'Video Call',
          status: InterviewStatus.scheduled,
        ),
      ),

      JobApplication(
        id: 'app_3',
        jobId: 'job_1',
        jobTitle: 'Software Development Engineer',
        candidateId: 'candidate_3',
        candidateName: 'Rajesh Patel',
        candidateEmail: 'rajesh.patel@student.vit.ac.in',
        candidatePhone: '+91 9876543230',
        candidateCollege: 'VIT Bhopal',
        candidateDepartment: 'Computer Science',
        candidateCGPA: 7.8,
        candidateGraduationYear: 2025,
        resumeUrl: 'https://example.com/resume3.pdf',
        coverLetter:
            'I am passionate about software development and eager to contribute...',
        status: ApplicationStatus.applied,
        currentRoundId: null,
        currentRoundName: 'Under Review',
        applicationData: {
          'skills': ['JavaScript', 'Node.js', 'React', 'MongoDB'],
          'projects': [
            {
              'name': 'Social Media App',
              'description':
                  'Built a social media platform with real-time chat',
              'technologies': ['Node.js', 'React', 'MongoDB', 'Socket.io'],
            },
          ],
          'internships': [
            {
              'company': 'StartupTech',
              'role': 'Frontend Developer Intern',
              'duration': '3 months',
              'description': 'Worked on React-based web applications',
            },
          ],
        },
        appliedAt: DateTime.now().subtract(Duration(days: 8)),
        updatedAt: DateTime.now().subtract(Duration(days: 8)),
        score: 78.0,
        feedback: 'Good technical foundation, needs more experience',
        tags: ['javascript', 'frontend', 'internship-experience'],
        notes:
            'Decent candidate, has some practical experience through internship',
      ),

      JobApplication(
        id: 'app_4',
        jobId: 'job_2',
        jobTitle: 'Frontend Developer Intern',
        candidateId: 'candidate_4',
        candidateName: 'Sneha Reddy',
        candidateEmail: 'sneha.reddy@student.vit.ac.in',
        candidatePhone: '+91 9876543240',
        candidateCollege: 'VIT Vellore',
        candidateDepartment: 'Information Technology',
        candidateCGPA: 8.9,
        candidateGraduationYear: 2026,
        resumeUrl: 'https://example.com/resume4.pdf',
        coverLetter:
            'As a passionate frontend developer, I would love to intern at your company...',
        status: ApplicationStatus.selected,
        currentRoundId: 'round_5',
        currentRoundName: 'Technical Round',
        applicationData: {
          'skills': ['React', 'TypeScript', 'CSS', 'HTML', 'JavaScript'],
          'portfolio': 'https://sneha-portfolio.vercel.app',
          'projects': [
            {
              'name': 'Weather Dashboard',
              'description':
                  'Interactive weather dashboard with charts and maps',
              'technologies': ['React', 'TypeScript', 'Chart.js', 'Mapbox API'],
              'live_demo': 'https://weather-dash-sneha.vercel.app',
            },
            {
              'name': 'E-learning Platform UI',
              'description': 'Modern UI for e-learning platform',
              'technologies': ['React', 'Material-UI', 'Framer Motion'],
              'live_demo': 'https://elearn-ui-sneha.vercel.app',
            },
          ],
          'design_tools': ['Figma', 'Adobe XD'],
          'github': 'https://github.com/sneha-reddy',
        },
        appliedAt: DateTime.now().subtract(Duration(days: 20)),
        updatedAt: DateTime.now().subtract(Duration(days: 2)),
        shortlistedAt: DateTime.now().subtract(Duration(days: 15)),
        interviewedAt: DateTime.now().subtract(Duration(days: 5)),
        selectedAt: DateTime.now().subtract(Duration(days: 2)),
        score: 95.0,
        feedback:
            'Exceptional frontend skills, great portfolio, excellent cultural fit',
        tags: ['react-expert', 'designer', 'portfolio-excellent', 'selected'],
        notes:
            'Top performer, excellent technical and design skills, offered internship',
      ),

      JobApplication(
        id: 'app_5',
        jobId: 'job_2',
        jobTitle: 'Frontend Developer Intern',
        candidateId: 'candidate_5',
        candidateName: 'Amit Singh',
        candidateEmail: 'amit.singh@student.vit.ac.in',
        candidatePhone: '+91 9876543250',
        candidateCollege: 'VIT Chennai',
        candidateDepartment: 'Computer Science',
        candidateCGPA: 7.5,
        candidateGraduationYear: 2026,
        resumeUrl: 'https://example.com/resume5.pdf',
        coverLetter:
            'I am excited about the opportunity to learn and grow as a frontend developer...',
        status: ApplicationStatus.rejected,
        currentRoundId: 'round_4',
        currentRoundName: 'Portfolio Review',
        applicationData: {
          'skills': ['HTML', 'CSS', 'JavaScript', 'Bootstrap'],
          'projects': [
            {
              'name': 'Personal Website',
              'description': 'Built a personal portfolio website',
              'technologies': ['HTML', 'CSS', 'JavaScript'],
            },
          ],
          'learning': [
            'Currently learning React',
            'Planning to learn TypeScript',
          ],
        },
        appliedAt: DateTime.now().subtract(Duration(days: 18)),
        updatedAt: DateTime.now().subtract(Duration(days: 12)),
        shortlistedAt: DateTime.now().subtract(Duration(days: 15)),
        rejectedAt: DateTime.now().subtract(Duration(days: 12)),
        score: 65.0,
        feedback:
            'Basic skills, limited project experience, needs more practice with modern frameworks',
        tags: ['beginner', 'learning', 'basic-skills'],
        notes:
            'Needs more experience with React and modern frontend technologies',
        rejectionReason:
            'Limited experience with required technologies (React, TypeScript)',
      ),

      JobApplication(
        id: 'app_6',
        jobId: 'job_3',
        jobTitle: 'Data Scientist',
        candidateId: 'candidate_6',
        candidateName: 'Kavya Nair',
        candidateEmail: 'kavya.nair@student.vit.ac.in',
        candidatePhone: '+91 9876543260',
        candidateCollege: 'VIT Vellore',
        candidateDepartment: 'Computer Science',
        candidateCGPA: 8.7,
        candidateGraduationYear: 2025,
        resumeUrl: 'https://example.com/resume6.pdf',
        coverLetter:
            'With my strong background in mathematics and programming, I am excited to apply...',
        status: ApplicationStatus.shortlisted,
        currentRoundId: 'round_6',
        currentRoundName: 'Data Science Challenge',
        applicationData: {
          'skills': [
            'Python',
            'Machine Learning',
            'SQL',
            'TensorFlow',
            'Pandas',
            'NumPy',
          ],
          'projects': [
            {
              'name': 'Stock Price Prediction',
              'description':
                  'ML model to predict stock prices using historical data',
              'technologies': ['Python', 'TensorFlow', 'Pandas', 'Matplotlib'],
              'github': 'https://github.com/kavya/stock-prediction',
            },
            {
              'name': 'Customer Segmentation',
              'description': 'Clustering analysis for customer segmentation',
              'technologies': ['Python', 'Scikit-learn', 'Pandas', 'Seaborn'],
              'kaggle': 'https://kaggle.com/kavya/customer-segmentation',
            },
          ],
          'research': [
            {
              'title': 'Deep Learning for Image Classification',
              'conference': 'Student Research Symposium 2024',
              'status': 'Published',
            },
          ],
          'certifications': ['Google Data Analytics', 'IBM Data Science'],
          'competitions': [
            'Kaggle Competition Participant',
            'Analytics Vidhya Hackathon',
          ],
        },
        appliedAt: DateTime.now().subtract(Duration(days: 25)),
        updatedAt: DateTime.now().subtract(Duration(days: 8)),
        shortlistedAt: DateTime.now().subtract(Duration(days: 8)),
        score: 89.0,
        feedback:
            'Strong mathematical foundation, excellent ML skills, research experience',
        tags: ['ml-expert', 'researcher', 'certified', 'competition-winner'],
        notes:
            'Excellent candidate for data scientist role, has research experience',
      ),

      JobApplication(
        id: 'app_7',
        jobId: 'job_5',
        jobTitle: 'DevOps Engineer',
        candidateId: 'candidate_7',
        candidateName: 'Rohit Gupta',
        candidateEmail: 'rohit.gupta@student.vit.ac.in',
        candidatePhone: '+91 9876543270',
        candidateCollege: 'VIT Bhopal',
        candidateDepartment: 'Information Technology',
        candidateCGPA: 8.2,
        candidateGraduationYear: 2024,
        resumeUrl: 'https://example.com/resume7.pdf',
        coverLetter:
            'I am passionate about cloud technologies and automation...',
        status: ApplicationStatus.shortlisted,
        currentRoundId: 'round_7',
        currentRoundName: 'System Design',
        applicationData: {
          'skills': [
            'AWS',
            'Docker',
            'Kubernetes',
            'Linux',
            'Python',
            'Terraform',
          ],
          'experience': [
            {
              'company': 'CloudTech Solutions',
              'role': 'DevOps Intern',
              'duration': '6 months',
              'description':
                  'Worked on CI/CD pipelines and cloud infrastructure',
            },
          ],
          'certifications': [
            'AWS Solutions Architect',
            'Docker Certified Associate',
          ],
          'projects': [
            {
              'name': 'Microservices Deployment',
              'description':
                  'Automated deployment of microservices using Kubernetes',
              'technologies': ['Kubernetes', 'Docker', 'Jenkins', 'AWS'],
            },
            {
              'name': 'Infrastructure as Code',
              'description':
                  'Terraform scripts for AWS infrastructure automation',
              'technologies': ['Terraform', 'AWS', 'CloudFormation'],
            },
          ],
        },
        appliedAt: DateTime.now().subtract(Duration(days: 35)),
        updatedAt: DateTime.now().subtract(Duration(days: 20)),
        shortlistedAt: DateTime.now().subtract(Duration(days: 20)),
        score: 86.0,
        feedback: 'Strong DevOps skills, good hands-on experience, certified',
        tags: ['aws-certified', 'experienced', 'devops-expert'],
        notes:
            'Good candidate with practical DevOps experience and certifications',
      ),
    ];

    _isInitialized = true;
  }

  @override
  Future<List<JobApplication>> getAllApplications() async {
    await Future.delayed(Duration(milliseconds: 500));
    return List.from(_applications);
  }

  @override
  Future<List<JobApplication>> getApplicationsByJob(String jobId) async {
    await Future.delayed(Duration(milliseconds: 300));
    return _applications.where((app) => app.jobId == jobId).toList();
  }

  @override
  Future<List<JobApplication>> getApplicationsByCandidate(
    String candidateId,
  ) async {
    await Future.delayed(Duration(milliseconds: 300));
    return _applications
        .where((app) => app.candidateId == candidateId)
        .toList();
  }

  @override
  Future<JobApplication> getApplicationById(String id) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _applications.firstWhere(
      (app) => app.id == id,
      orElse: () => throw Exception('Application not found'),
    );
  }

  @override
  Future<JobApplication> createApplication(JobApplication application) async {
    await Future.delayed(Duration(milliseconds: 800));
    final newApp = application.copyWith(
      id: 'app_${DateTime.now().millisecondsSinceEpoch}',
      appliedAt: DateTime.now(),
      status: ApplicationStatus.applied,
    );
    _applications.add(newApp);
    return newApp;
  }

  @override
  Future<JobApplication> updateApplication(JobApplication application) async {
    await Future.delayed(Duration(milliseconds: 600));
    final index = _applications.indexWhere((app) => app.id == application.id);
    if (index != -1) {
      _applications[index] = application.copyWith(updatedAt: DateTime.now());
      return _applications[index];
    }
    throw Exception('Application not found');
  }

  @override
  Future<bool> deleteApplication(String id) async {
    await Future.delayed(Duration(milliseconds: 400));
    final index = _applications.indexWhere((app) => app.id == id);
    if (index != -1) {
      _applications.removeAt(index);
      return true;
    }
    return false;
  }

  @override
  Future<bool> shortlistApplication(String id) async {
    await Future.delayed(Duration(milliseconds: 500));
    final index = _applications.indexWhere((app) => app.id == id);
    if (index != -1) {
      _applications[index] = _applications[index].copyWith(
        status: ApplicationStatus.shortlisted,
        shortlistedAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      return true;
    }
    return false;
  }

  @override
  Future<bool> rejectApplication(String id, String reason) async {
    await Future.delayed(Duration(milliseconds: 500));
    final index = _applications.indexWhere((app) => app.id == id);
    if (index != -1) {
      _applications[index] = _applications[index].copyWith(
        status: ApplicationStatus.rejected,
        rejectedAt: DateTime.now(),
        rejectionReason: reason,
        updatedAt: DateTime.now(),
      );
      return true;
    }
    return false;
  }

  @override
  Future<bool> moveToNextRound(String id, String roundId) async {
    await Future.delayed(Duration(milliseconds: 500));
    final index = _applications.indexWhere((app) => app.id == id);
    if (index != -1) {
      _applications[index] = _applications[index].copyWith(
        currentRoundId: roundId,
        status: ApplicationStatus.interviewed,
        interviewedAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      return true;
    }
    return false;
  }

  @override
  Future<List<JobApplication>> getShortlistedApplications(String jobId) async {
    await Future.delayed(Duration(milliseconds: 300));
    return _applications
        .where(
          (app) =>
              app.jobId == jobId && app.status == ApplicationStatus.shortlisted,
        )
        .toList();
  }

  @override
  Future<List<JobApplication>> getRejectedApplications(String jobId) async {
    await Future.delayed(Duration(milliseconds: 300));
    return _applications
        .where(
          (app) =>
              app.jobId == jobId && app.status == ApplicationStatus.rejected,
        )
        .toList();
  }

  @override
  Future<ApplicationStats> getApplicationStatistics(String jobId) async {
    await Future.delayed(Duration(milliseconds: 400));
    final jobApplications = _applications
        .where((app) => app.jobId == jobId)
        .toList();

    final totalApplications = jobApplications.length;
    final shortlisted = jobApplications
        .where((app) => app.status == ApplicationStatus.shortlisted)
        .length;
    final interviewed = jobApplications
        .where((app) => app.status == ApplicationStatus.interviewed)
        .length;
    final selected = jobApplications
        .where((app) => app.status == ApplicationStatus.selected)
        .length;
    final rejected = jobApplications
        .where((app) => app.status == ApplicationStatus.rejected)
        .length;

    return ApplicationStats(
      jobId: jobId,
      totalApplications: totalApplications,
      shortlisted: shortlisted,
      interviewed: interviewed,
      selected: selected,
      rejected: rejected,
      pending:
          totalApplications - shortlisted - interviewed - selected - rejected,
      shortlistRate: totalApplications > 0
          ? (shortlisted / totalApplications) * 100
          : 0.0,
      interviewRate: shortlisted > 0 ? (interviewed / shortlisted) * 100 : 0.0,
      selectionRate: interviewed > 0 ? (selected / interviewed) * 100 : 0.0,
      averageScore: jobApplications.isNotEmpty
          ? jobApplications
                    .map((app) => app.score ?? 0.0)
                    .reduce((a, b) => a + b) /
                jobApplications.length
          : 0.0,
      departmentWiseApplications: _getDepartmentWiseStats(jobApplications),
      collegeWiseApplications: _getCollegeWiseStats(jobApplications),
      dailyApplicationTrends: _generateApplicationTrends(jobApplications),
    );
  }

  @override
  Future<List<JobApplication>> searchApplications(
    ApplicationSearchFilters filters,
  ) async {
    await Future.delayed(Duration(milliseconds: 600));

    var filteredApps = List<JobApplication>.from(_applications);

    if (filters.jobId != null) {
      filteredApps = filteredApps
          .where((app) => app.jobId == filters.jobId)
          .toList();
    }

    if (filters.candidateName != null && filters.candidateName!.isNotEmpty) {
      filteredApps = filteredApps
          .where(
            (app) => app.candidateName.toLowerCase().contains(
              filters.candidateName!.toLowerCase(),
            ),
          )
          .toList();
    }

    if (filters.status != null) {
      filteredApps = filteredApps
          .where((app) => app.status == filters.status)
          .toList();
    }

    if (filters.department != null) {
      filteredApps = filteredApps
          .where((app) => app.candidateDepartment == filters.department)
          .toList();
    }

    if (filters.college != null) {
      filteredApps = filteredApps
          .where((app) => app.candidateCollege == filters.college)
          .toList();
    }

    if (filters.minCGPA != null) {
      filteredApps = filteredApps
          .where((app) => app.candidateCGPA >= filters.minCGPA!)
          .toList();
    }

    return filteredApps;
  }

  @override
  Future<bool> bulkUpdateApplicationStatus(
    List<String> applicationIds,
    ApplicationStatus status,
  ) async {
    await Future.delayed(Duration(milliseconds: 1000));

    for (final id in applicationIds) {
      final index = _applications.indexWhere((app) => app.id == id);
      if (index != -1) {
        _applications[index] = _applications[index].copyWith(
          status: status,
          updatedAt: DateTime.now(),
        );
      }
    }
    return true;
  }

  @override
  Future<List<JobApplication>> getApplicationsForRound(
    String jobId,
    String roundId,
  ) async {
    await Future.delayed(Duration(milliseconds: 300));
    return _applications
        .where((app) => app.jobId == jobId && app.currentRoundId == roundId)
        .toList();
  }

  @override
  Future<bool> scheduleInterview(
    String applicationId,
    InterviewSchedule schedule,
  ) async {
    await Future.delayed(Duration(milliseconds: 500));
    final index = _applications.indexWhere((app) => app.id == applicationId);
    if (index != -1) {
      _applications[index] = _applications[index].copyWith(
        interviewSchedule: schedule,
        updatedAt: DateTime.now(),
      );
      return true;
    }
    return false;
  }

  @override
  Future<List<InterviewSchedule>> getInterviewSchedules(String jobId) async {
    await Future.delayed(Duration(milliseconds: 400));
    return _applications
        .where((app) => app.jobId == jobId && app.interviewSchedule != null)
        .map((app) => app.interviewSchedule!)
        .toList();
  }

  Map<String, int> _getDepartmentWiseStats(List<JobApplication> applications) {
    final stats = <String, int>{};
    for (final app in applications) {
      stats[app.candidateDepartment] =
          (stats[app.candidateDepartment] ?? 0) + 1;
    }
    return stats;
  }

  Map<String, int> _getCollegeWiseStats(List<JobApplication> applications) {
    final stats = <String, int>{};
    for (final app in applications) {
      stats[app.candidateCollege] = (stats[app.candidateCollege] ?? 0) + 1;
    }
    return stats;
  }

  List<ApplicationTrendData> _generateApplicationTrends(
    List<JobApplication> applications,
  ) {
    final trends = <ApplicationTrendData>[];
    for (int i = 30; i >= 0; i--) {
      final date = DateTime.now().subtract(Duration(days: i));
      final dailyApps = applications
          .where(
            (app) =>
                app.appliedAt.year == date.year &&
                app.appliedAt.month == date.month &&
                app.appliedAt.day == date.day,
          )
          .length;

      trends.add(ApplicationTrendData(date: date, applications: dailyApps));
    }
    return trends;
  }
}

// Supporting classes
class JobApplication {
  final String id;
  final String jobId;
  final String jobTitle;
  final String candidateId;
  final String candidateName;
  final String candidateEmail;
  final String candidatePhone;
  final String candidateCollege;
  final String candidateDepartment;
  final double candidateCGPA;
  final int candidateGraduationYear;
  final String resumeUrl;
  final String coverLetter;
  final ApplicationStatus status;
  final String? currentRoundId;
  final String? currentRoundName;
  final Map<String, dynamic> applicationData;
  final DateTime appliedAt;
  final DateTime? updatedAt;
  final DateTime? shortlistedAt;
  final DateTime? interviewedAt;
  final DateTime? selectedAt;
  final DateTime? rejectedAt;
  final double? score;
  final String? feedback;
  final String? rejectionReason;
  final List<String> tags;
  final String? notes;
  final InterviewSchedule? interviewSchedule;

  JobApplication({
    required this.id,
    required this.jobId,
    required this.jobTitle,
    required this.candidateId,
    required this.candidateName,
    required this.candidateEmail,
    required this.candidatePhone,
    required this.candidateCollege,
    required this.candidateDepartment,
    required this.candidateCGPA,
    required this.candidateGraduationYear,
    required this.resumeUrl,
    required this.coverLetter,
    required this.status,
    this.currentRoundId,
    this.currentRoundName,
    required this.applicationData,
    required this.appliedAt,
    this.updatedAt,
    this.shortlistedAt,
    this.interviewedAt,
    this.selectedAt,
    this.rejectedAt,
    this.score,
    this.feedback,
    this.rejectionReason,
    required this.tags,
    this.notes,
    this.interviewSchedule,
  });

  JobApplication copyWith({
    String? id,
    String? jobId,
    String? jobTitle,
    String? candidateId,
    String? candidateName,
    String? candidateEmail,
    String? candidatePhone,
    String? candidateCollege,
    String? candidateDepartment,
    double? candidateCGPA,
    int? candidateGraduationYear,
    String? resumeUrl,
    String? coverLetter,
    ApplicationStatus? status,
    String? currentRoundId,
    String? currentRoundName,
    Map<String, dynamic>? applicationData,
    DateTime? appliedAt,
    DateTime? updatedAt,
    DateTime? shortlistedAt,
    DateTime? interviewedAt,
    DateTime? selectedAt,
    DateTime? rejectedAt,
    double? score,
    String? feedback,
    String? rejectionReason,
    List<String>? tags,
    String? notes,
    InterviewSchedule? interviewSchedule,
  }) {
    return JobApplication(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      jobTitle: jobTitle ?? this.jobTitle,
      candidateId: candidateId ?? this.candidateId,
      candidateName: candidateName ?? this.candidateName,
      candidateEmail: candidateEmail ?? this.candidateEmail,
      candidatePhone: candidatePhone ?? this.candidatePhone,
      candidateCollege: candidateCollege ?? this.candidateCollege,
      candidateDepartment: candidateDepartment ?? this.candidateDepartment,
      candidateCGPA: candidateCGPA ?? this.candidateCGPA,
      candidateGraduationYear:
          candidateGraduationYear ?? this.candidateGraduationYear,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      coverLetter: coverLetter ?? this.coverLetter,
      status: status ?? this.status,
      currentRoundId: currentRoundId ?? this.currentRoundId,
      currentRoundName: currentRoundName ?? this.currentRoundName,
      applicationData: applicationData ?? Map.from(this.applicationData),
      appliedAt: appliedAt ?? this.appliedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      shortlistedAt: shortlistedAt ?? this.shortlistedAt,
      interviewedAt: interviewedAt ?? this.interviewedAt,
      selectedAt: selectedAt ?? this.selectedAt,
      rejectedAt: rejectedAt ?? this.rejectedAt,
      score: score ?? this.score,
      feedback: feedback ?? this.feedback,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      tags: tags ?? List.from(this.tags),
      notes: notes ?? this.notes,
      interviewSchedule: interviewSchedule ?? this.interviewSchedule,
    );
  }
}

class InterviewSchedule {
  final String id;
  final String applicationId;
  final String roundId;
  final DateTime scheduledAt;
  final int duration; // in minutes
  final String interviewerName;
  final String interviewerEmail;
  final String meetingLink;
  final String venue;
  final InterviewStatus status;
  final String? notes;

  InterviewSchedule({
    required this.id,
    required this.applicationId,
    required this.roundId,
    required this.scheduledAt,
    required this.duration,
    required this.interviewerName,
    required this.interviewerEmail,
    required this.meetingLink,
    required this.venue,
    required this.status,
    this.notes,
  });
}

class ApplicationSearchFilters {
  final String? jobId;
  final String? candidateName;
  final ApplicationStatus? status;
  final String? department;
  final String? college;
  final double? minCGPA;
  final int? graduationYear;
  final List<String>? tags;

  ApplicationSearchFilters({
    this.jobId,
    this.candidateName,
    this.status,
    this.department,
    this.college,
    this.minCGPA,
    this.graduationYear,
    this.tags,
  });
}

class ApplicationStats {
  final String jobId;
  final int totalApplications;
  final int shortlisted;
  final int interviewed;
  final int selected;
  final int rejected;
  final int pending;
  final double shortlistRate;
  final double interviewRate;
  final double selectionRate;
  final double averageScore;
  final Map<String, int> departmentWiseApplications;
  final Map<String, int> collegeWiseApplications;
  final List<ApplicationTrendData> dailyApplicationTrends;

  ApplicationStats({
    required this.jobId,
    required this.totalApplications,
    required this.shortlisted,
    required this.interviewed,
    required this.selected,
    required this.rejected,
    required this.pending,
    required this.shortlistRate,
    required this.interviewRate,
    required this.selectionRate,
    required this.averageScore,
    required this.departmentWiseApplications,
    required this.collegeWiseApplications,
    required this.dailyApplicationTrends,
  });
}

class ApplicationTrendData {
  final DateTime date;
  final int applications;

  ApplicationTrendData({required this.date, required this.applications});
}

enum ApplicationStatus {
  applied,
  shortlisted,
  interviewed,
  selected,
  rejected,
  withdrawn,
}

enum InterviewStatus { scheduled, completed, cancelled, rescheduled, noShow }

extension ApplicationStatusExtension on ApplicationStatus {
  String get displayName {
    switch (this) {
      case ApplicationStatus.applied:
        return 'Applied';
      case ApplicationStatus.shortlisted:
        return 'Shortlisted';
      case ApplicationStatus.interviewed:
        return 'Interviewed';
      case ApplicationStatus.selected:
        return 'Selected';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.withdrawn:
        return 'Withdrawn';
    }
  }
}
