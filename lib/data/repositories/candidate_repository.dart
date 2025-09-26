import '../models/candidate_model.dart';
import '../models/job_enums.dart';

abstract class CandidateRepository {
  Future<List<CandidateModel>> getAllCandidates();
  Future<CandidateModel> getCandidateById(String id);
  Future<List<CandidateModel>> searchCandidates(CandidateSearchFilters filters);
  Future<List<CandidateModel>> getCandidatesBySkills(List<String> skills);
  Future<List<CandidateModel>> getCandidatesByCollege(String college);
  Future<List<CandidateModel>> getCandidatesByDepartment(String department);
  Future<List<CandidateModel>> getCandidatesForJob(String jobId);
  Future<CandidateProfile> getCandidateProfile(String candidateId);
  Future<List<CandidateModel>> getTopCandidates(int limit);
  Future<CandidateStats> getCandidateStatistics();
  Future<List<CandidateModel>> getFreshGraduates();
  Future<List<CandidateModel>> getExperiencedCandidates();
  Future<bool> addToWatchlist(String candidateId);
  Future<bool> removeFromWatchlist(String candidateId);
  Future<List<CandidateModel>> getWatchlistedCandidates();
  Future<bool> sendMessage(String candidateId, String message);
  Future<List<CandidateInteraction>> getCandidateInteractions(
    String candidateId,
  );
  Future<CandidateCompatibilityScore> checkJobCompatibility(
    String candidateId,
    String jobId,
  );
}

class CandidateRepositoryImpl implements CandidateRepository {
  List<CandidateModel> _candidates = [];
  List<String> _watchlist = [];
  List<CandidateInteraction> _interactions = [];
  bool _isInitialized = false;

  CandidateRepositoryImpl() {
    _initializeMockData();
  }

  void _initializeMockData() {
    if (_isInitialized) return;

    _candidates = [
      CandidateModel(
        id: 'candidate_1',
        name: 'Arjun Kumar',
        email: 'arjun.kumar@student.vit.ac.in',
        phone: '+91 9876543210',
        regNumber: 'VIT2021001',
        college: 'VIT Vellore',
        department: 'Computer Science',
        degreeType: 'B.Tech',
        graduationYear: 2025,
        cgpa: 8.5,
        gender: 'Male',
        dateOfBirth: DateTime(2003, 5, 15),
        address: 'Chennai, Tamil Nadu',
        profilePictureUrl: 'https://example.com/profile1.jpg',
        skills: [
          'Java',
          'Spring Boot',
          'React',
          'MySQL',
          'AWS',
          'Docker',
          'Git',
        ],
        experiences: [
          CandidateExperience(
            id: 'exp_1',
            company: 'TechStart Solutions',
            position: 'Software Development Intern',
            location: 'Bangalore',
            startDate: DateTime(2024, 6, 1),
            endDate: DateTime(2024, 8, 31),
            isCurrentJob: false,
            description:
                'Developed REST APIs using Spring Boot and worked on React frontend components.',
            skills: ['Java', 'Spring Boot', 'React', 'PostgreSQL'],
            achievements: [
              'Improved API response time by 30%',
              'Contributed to 5+ features in the main product',
            ],
          ),
        ],
        projects: [
          CandidateProject(
            id: 'proj_1',
            title: 'E-commerce Platform',
            description:
                'Full-stack e-commerce platform with payment integration',
            technologies: [
              'Java',
              'Spring Boot',
              'React',
              'MySQL',
              'Stripe API',
            ],
            githubUrl: 'https://github.com/arjun/ecommerce-platform',
            liveUrl: 'https://arjun-ecommerce.vercel.app',
            startDate: DateTime(2024, 1, 15),
            endDate: DateTime(2024, 4, 30),
            isOngoing: false,
            features: [
              'User authentication and authorization',
              'Product catalog with search and filtering',
              'Shopping cart and wishlist',
              'Payment integration with Stripe',
              'Order management system',
            ],
            projectType: ProjectType.personal,
          ),
          CandidateProject(
            id: 'proj_2',
            title: 'Task Management System',
            description: 'Collaborative task management application for teams',
            technologies: ['React', 'Node.js', 'MongoDB', 'Socket.io'],
            githubUrl: 'https://github.com/arjun/task-manager',
            startDate: DateTime(2023, 9, 1),
            endDate: DateTime(2023, 12, 15),
            isOngoing: false,
            features: [
              'Real-time collaboration',
              'Task assignment and tracking',
              'Team chat functionality',
              'Progress analytics',
            ],
            projectType: ProjectType.academic,
          ),
        ],
        education: [
          CandidateEducation(
            id: 'edu_1',
            institution: 'VIT Vellore',
            degree: 'B.Tech',
            fieldOfStudy: 'Computer Science and Engineering',
            startDate: DateTime(2021, 8, 1),
            endDate: DateTime(2025, 5, 31),
            isCurrentlyStudying: true,
            grade: 8.5,
            gradeType: 'CGPA',
            relevantCourses: [
              'Data Structures and Algorithms',
              'Database Management Systems',
              'Software Engineering',
              'Web Technologies',
              'Machine Learning',
            ],
            achievements: [
              'Dean\'s List for Academic Excellence',
              'Best Project Award - Software Engineering',
              'Coding Club Secretary',
            ],
          ),
        ],
        certifications: [
          CandidateCertification(
            id: 'cert_1',
            name: 'AWS Certified Developer - Associate',
            issuer: 'Amazon Web Services',
            issueDate: DateTime(2024, 3, 15),
            expiryDate: DateTime(2027, 3, 15),
            credentialId: 'AWS-DEV-2024-001',
            credentialUrl: 'https://aws.amazon.com/verification/cert_1',
            isVerified: true,
            skills: ['AWS', 'Cloud Computing', 'Lambda', 'S3', 'DynamoDB'],
          ),
          CandidateCertification(
            id: 'cert_2',
            name: 'Oracle Java SE 11 Developer',
            issuer: 'Oracle',
            issueDate: DateTime(2023, 11, 20),
            credentialId: 'OCP-JAVA-2023-001',
            isVerified: true,
            skills: [
              'Java',
              'Object-Oriented Programming',
              'Collections',
              'Streams',
            ],
          ),
        ],
        languages: ['English', 'Hindi', 'Tamil'],
        preferences: CandidatePreferences(
          preferredLocations: ['Bangalore', 'Chennai', 'Hyderabad'],
          preferredIndustries: ['Technology', 'E-commerce', 'Fintech'],
          expectedSalaryMin: 6.0,
          expectedSalaryMax: 12.0,
          preferredJobTypes: [JobType.fullTime, JobType.internship],
          preferredWorkModes: [WorkMode.hybrid, WorkMode.remote],
          willingToRelocate: true,
          openToRemote: true,
          noticePeriod: 0,
        ),
        status: CandidateStatus.active,
        isProfileComplete: true,
        profileCompletionPercentage: 95,
        lastActiveAt: DateTime.now().subtract(Duration(hours: 2)),
        createdAt: DateTime(2021, 8, 15),
        updatedAt: DateTime.now().subtract(Duration(days: 3)),
      ),

      CandidateModel(
        id: 'candidate_2',
        name: 'Priya Sharma',
        email: 'priya.sharma@student.vit.ac.in',
        phone: '+91 9876543220',
        regNumber: 'VIT2021002',
        college: 'VIT Chennai',
        department: 'Information Technology',
        degreeType: 'B.Tech',
        graduationYear: 2025,
        cgpa: 9.2,
        gender: 'Female',
        dateOfBirth: DateTime(2003, 8, 22),
        address: 'Mumbai, Maharashtra',
        profilePictureUrl: 'https://example.com/profile2.jpg',
        skills: [
          'Python',
          'Django',
          'React',
          'PostgreSQL',
          'Docker',
          'Kubernetes',
          'Machine Learning',
        ],
        experiences: [
          CandidateExperience(
            id: 'exp_2',
            company: 'DataTech Analytics',
            position: 'Machine Learning Intern',
            location: 'Remote',
            startDate: DateTime(2024, 5, 1),
            endDate: DateTime(2024, 7, 31),
            isCurrentJob: false,
            description:
                'Worked on ML models for customer behavior prediction and data analysis.',
            skills: ['Python', 'Scikit-learn', 'Pandas', 'TensorFlow'],
            achievements: [
              'Improved model accuracy by 15%',
              'Deployed ML pipeline to production',
              'Presented findings to senior management',
            ],
          ),
        ],
        projects: [
          CandidateProject(
            id: 'proj_3',
            title: 'Smart Recommendation System',
            description:
                'ML-based recommendation system for e-commerce products',
            technologies: ['Python', 'TensorFlow', 'Flask', 'MongoDB'],
            githubUrl: 'https://github.com/priya/recommendation-system',
            liveUrl: 'https://smart-recommender-priya.herokuapp.com',
            startDate: DateTime(2024, 2, 1),
            endDate: DateTime(2024, 5, 30),
            isOngoing: false,
            features: [
              'Collaborative filtering algorithm',
              'Content-based recommendations',
              'Real-time API endpoints',
              'A/B testing framework',
            ],
            projectType: ProjectType.personal,
          ),
          CandidateProject(
            id: 'proj_4',
            title: 'Health Monitoring Dashboard',
            description:
                'IoT-based health monitoring system with data visualization',
            technologies: [
              'React',
              'Node.js',
              'InfluxDB',
              'Chart.js',
              'Arduino',
            ],
            githubUrl: 'https://github.com/priya/health-monitor',
            startDate: DateTime(2023, 10, 1),
            endDate: DateTime(2024, 1, 15),
            isOngoing: false,
            features: [
              'Real-time sensor data collection',
              'Interactive data visualization',
              'Health alerts and notifications',
              'Historical data analysis',
            ],
            projectType: ProjectType.academic,
          ),
        ],
        education: [
          CandidateEducation(
            id: 'edu_2',
            institution: 'VIT Chennai',
            degree: 'B.Tech',
            fieldOfStudy: 'Information Technology',
            startDate: DateTime(2021, 8, 1),
            endDate: DateTime(2025, 5, 31),
            isCurrentlyStudying: true,
            grade: 9.2,
            gradeType: 'CGPA',
            relevantCourses: [
              'Artificial Intelligence',
              'Machine Learning',
              'Big Data Analytics',
              'Cloud Computing',
              'Software Architecture',
            ],
            achievements: [
              'University Gold Medalist (Expected)',
              'Research Paper Published in IEEE Conference',
              'Technical Society President',
            ],
          ),
        ],
        certifications: [
          CandidateCertification(
            id: 'cert_3',
            name: 'Google Cloud Professional Data Engineer',
            issuer: 'Google Cloud',
            issueDate: DateTime(2024, 6, 10),
            expiryDate: DateTime(2026, 6, 10),
            credentialId: 'GCP-PDE-2024-001',
            credentialUrl:
                'https://cloud.google.com/certification/verify/cert_3',
            isVerified: true,
            skills: [
              'GCP',
              'BigQuery',
              'Data Pipeline',
              'Machine Learning',
              'Data Engineering',
            ],
          ),
          CandidateCertification(
            id: 'cert_4',
            name: 'TensorFlow Developer Certificate',
            issuer: 'TensorFlow',
            issueDate: DateTime(2024, 1, 5),
            credentialId: 'TF-DEV-2024-001',
            isVerified: true,
            skills: [
              'TensorFlow',
              'Deep Learning',
              'Neural Networks',
              'Computer Vision',
            ],
          ),
        ],
        languages: ['English', 'Hindi', 'Marathi'],
        preferences: CandidatePreferences(
          preferredLocations: ['Mumbai', 'Bangalore', 'Pune'],
          preferredIndustries: [
            'Technology',
            'AI/ML',
            'Data Science',
            'Healthcare Tech',
          ],
          expectedSalaryMin: 8.0,
          expectedSalaryMax: 15.0,
          preferredJobTypes: [JobType.fullTime],
          preferredWorkModes: [WorkMode.hybrid, WorkMode.remote],
          willingToRelocate: true,
          openToRemote: true,
          noticePeriod: 0,
        ),
        status: CandidateStatus.active,
        isProfileComplete: true,
        profileCompletionPercentage: 100,
        lastActiveAt: DateTime.now().subtract(Duration(minutes: 30)),
        createdAt: DateTime(2021, 8, 20),
        updatedAt: DateTime.now().subtract(Duration(days: 1)),
      ),

      CandidateModel(
        id: 'candidate_3',
        name: 'Rajesh Patel',
        email: 'rajesh.patel@student.vit.ac.in',
        phone: '+91 9876543230',
        regNumber: 'VIT2021003',
        college: 'VIT Bhopal',
        department: 'Computer Science',
        degreeType: 'B.Tech',
        graduationYear: 2025,
        cgpa: 7.8,
        gender: 'Male',
        dateOfBirth: DateTime(2003, 11, 10),
        address: 'Ahmedabad, Gujarat',
        profilePictureUrl: 'https://example.com/profile3.jpg',
        skills: [
          'JavaScript',
          'Node.js',
          'React',
          'MongoDB',
          'Express.js',
          'HTML',
          'CSS',
        ],
        experiences: [
          CandidateExperience(
            id: 'exp_3',
            company: 'StartupTech',
            position: 'Frontend Developer Intern',
            location: 'Ahmedabad',
            startDate: DateTime(2024, 6, 15),
            endDate: DateTime(2024, 8, 15),
            isCurrentJob: false,
            description:
                'Developed responsive web applications using React and modern frontend technologies.',
            skills: ['React', 'JavaScript', 'CSS', 'Material-UI'],
            achievements: [
              'Developed 3 major frontend components',
              'Improved page load speed by 25%',
              'Received positive feedback from mentor',
            ],
          ),
        ],
        projects: [
          CandidateProject(
            id: 'proj_5',
            title: 'Social Media App',
            description: 'Full-stack social media platform with real-time chat',
            technologies: [
              'Node.js',
              'React',
              'MongoDB',
              'Socket.io',
              'Express.js',
            ],
            githubUrl: 'https://github.com/rajesh/social-media-app',
            startDate: DateTime(2023, 12, 1),
            endDate: DateTime(2024, 3, 31),
            isOngoing: false,
            features: [
              'User profiles and authentication',
              'Post creation and sharing',
              'Real-time chat messaging',
              'Friend connections',
              'News feed algorithm',
            ],
            projectType: ProjectType.personal,
          ),
          CandidateProject(
            id: 'proj_6',
            title: 'Online Learning Platform',
            description:
                'Web platform for online courses and student management',
            technologies: ['React', 'Node.js', 'MongoDB', 'Express.js'],
            githubUrl: 'https://github.com/rajesh/learning-platform',
            startDate: DateTime(2024, 1, 1),
            endDate: DateTime(2024, 4, 30),
            isOngoing: false,
            features: [
              'Course catalog and enrollment',
              'Video streaming integration',
              'Quiz and assessment system',
              'Progress tracking',
            ],
            projectType: ProjectType.academic,
          ),
        ],
        education: [
          CandidateEducation(
            id: 'edu_3',
            institution: 'VIT Bhopal',
            degree: 'B.Tech',
            fieldOfStudy: 'Computer Science and Engineering',
            startDate: DateTime(2021, 8, 1),
            endDate: DateTime(2025, 5, 31),
            isCurrentlyStudying: true,
            grade: 7.8,
            gradeType: 'CGPA',
            relevantCourses: [
              'Web Technologies',
              'Software Engineering',
              'Database Systems',
              'Computer Networks',
              'Mobile App Development',
            ],
            achievements: [
              'Active member of Web Development Club',
              'Participated in 3+ hackathons',
              'Volunteer at college tech events',
            ],
          ),
        ],
        certifications: [
          CandidateCertification(
            id: 'cert_5',
            name: 'Meta Frontend Developer Certificate',
            issuer: 'Meta (Coursera)',
            issueDate: DateTime(2023, 12, 1),
            credentialId: 'META-FE-2023-001',
            isVerified: true,
            skills: ['React', 'JavaScript', 'HTML', 'CSS', 'UI/UX Design'],
          ),
        ],
        languages: ['English', 'Hindi', 'Gujarati'],
        preferences: CandidatePreferences(
          preferredLocations: ['Ahmedabad', 'Mumbai', 'Bangalore'],
          preferredIndustries: ['Technology', 'Startups', 'E-commerce'],
          expectedSalaryMin: 4.5,
          expectedSalaryMax: 8.0,
          preferredJobTypes: [JobType.fullTime, JobType.internship],
          preferredWorkModes: [WorkMode.onsite, WorkMode.hybrid],
          willingToRelocate: true,
          openToRemote: false,
          noticePeriod: 0,
        ),
        status: CandidateStatus.active,
        isProfileComplete: true,
        profileCompletionPercentage: 88,
        lastActiveAt: DateTime.now().subtract(Duration(hours: 6)),
        createdAt: DateTime(2021, 9, 5),
        updatedAt: DateTime.now().subtract(Duration(days: 5)),
      ),

      CandidateModel(
        id: 'candidate_4',
        name: 'Sneha Reddy',
        email: 'sneha.reddy@student.vit.ac.in',
        phone: '+91 9876543240',
        regNumber: 'VIT2022001',
        college: 'VIT Vellore',
        department: 'Information Technology',
        degreeType: 'B.Tech',
        graduationYear: 2026,
        cgpa: 8.9,
        gender: 'Female',
        dateOfBirth: DateTime(2004, 3, 8),
        address: 'Hyderabad, Telangana',
        profilePictureUrl: 'https://example.com/profile4.jpg',
        skills: [
          'React',
          'TypeScript',
          'CSS',
          'HTML',
          'JavaScript',
          'Figma',
          'Adobe XD',
        ],
        experiences: [],
        projects: [
          CandidateProject(
            id: 'proj_7',
            title: 'Weather Dashboard',
            description: 'Interactive weather dashboard with charts and maps',
            technologies: ['React', 'TypeScript', 'Chart.js', 'Mapbox API'],
            githubUrl: 'https://github.com/sneha/weather-dashboard',
            liveUrl: 'https://weather-dash-sneha.vercel.app',
            startDate: DateTime(2024, 5, 1),
            endDate: DateTime(2024, 7, 31),
            isOngoing: false,
            features: [
              'Real-time weather data',
              'Interactive charts and graphs',
              'Map-based weather visualization',
              'Multi-city comparison',
              'Weather forecasting',
            ],
            projectType: ProjectType.personal,
          ),
          CandidateProject(
            id: 'proj_8',
            title: 'E-learning Platform UI',
            description:
                'Modern and responsive UI design for e-learning platform',
            technologies: ['React', 'Material-UI', 'Framer Motion'],
            githubUrl: 'https://github.com/sneha/elearning-ui',
            liveUrl: 'https://elearn-ui-sneha.vercel.app',
            startDate: DateTime(2024, 2, 15),
            endDate: DateTime(2024, 4, 30),
            isOngoing: false,
            features: [
              'Responsive design',
              'Smooth animations',
              'Dark/Light theme toggle',
              'Accessible components',
              'Mobile-first approach',
            ],
            projectType: ProjectType.personal,
          ),
        ],
        education: [
          CandidateEducation(
            id: 'edu_4',
            institution: 'VIT Vellore',
            degree: 'B.Tech',
            fieldOfStudy: 'Information Technology',
            startDate: DateTime(2022, 8, 1),
            endDate: DateTime(2026, 5, 31),
            isCurrentlyStudying: true,
            grade: 8.9,
            gradeType: 'CGPA',
            relevantCourses: [
              'Web Development',
              'Human-Computer Interaction',
              'Software Engineering',
              'Database Management',
              'Computer Graphics',
            ],
            achievements: [
              'UI/UX Design Competition Winner',
              'Frontend Development Workshop Coordinator',
              'Cultural Committee Member',
            ],
          ),
        ],
        certifications: [
          CandidateCertification(
            id: 'cert_6',
            name: 'Google UX Design Certificate',
            issuer: 'Google (Coursera)',
            issueDate: DateTime(2024, 4, 20),
            credentialId: 'GOOGLE-UX-2024-001',
            isVerified: true,
            skills: [
              'UI/UX Design',
              'Prototyping',
              'User Research',
              'Figma',
              'Adobe XD',
            ],
          ),
        ],
        languages: ['English', 'Hindi', 'Telugu'],
        preferences: CandidatePreferences(
          preferredLocations: ['Hyderabad', 'Bangalore', 'Chennai'],
          preferredIndustries: [
            'Technology',
            'Design',
            'E-learning',
            'Healthcare Tech',
          ],
          expectedSalaryMin: 15000,
          expectedSalaryMax: 30000,
          preferredJobTypes: [JobType.internship, JobType.partTime],
          preferredWorkModes: [WorkMode.remote, WorkMode.hybrid],
          willingToRelocate: false,
          openToRemote: true,
          noticePeriod: 0,
        ),
        status: CandidateStatus.active,
        isProfileComplete: true,
        profileCompletionPercentage: 92,
        lastActiveAt: DateTime.now().subtract(Duration(hours: 1)),
        createdAt: DateTime(2022, 8, 25),
        updatedAt: DateTime.now().subtract(Duration(hours: 12)),
      ),

      CandidateModel(
        id: 'candidate_5',
        name: 'Amit Singh',
        email: 'amit.singh@student.vit.ac.in',
        phone: '+91 9876543250',
        regNumber: 'VIT2022002',
        college: 'VIT Chennai',
        department: 'Computer Science',
        degreeType: 'B.Tech',
        graduationYear: 2026,
        cgpa: 7.5,
        gender: 'Male',
        dateOfBirth: DateTime(2004, 7, 18),
        address: 'Delhi, India',
        profilePictureUrl: 'https://example.com/profile5.jpg',
        skills: ['HTML', 'CSS', 'JavaScript', 'Bootstrap', 'PHP', 'MySQL'],
        experiences: [],
        projects: [
          CandidateProject(
            id: 'proj_9',
            title: 'Personal Portfolio Website',
            description:
                'Responsive personal portfolio showcasing projects and skills',
            technologies: ['HTML', 'CSS', 'JavaScript', 'Bootstrap'],
            githubUrl: 'https://github.com/amit/portfolio',
            liveUrl: 'https://amit-portfolio.github.io',
            startDate: DateTime(2023, 11, 1),
            endDate: DateTime(2023, 12, 15),
            isOngoing: false,
            features: [
              'Responsive design',
              'Project showcase',
              'Contact form',
              'Skills visualization',
              'Blog section',
            ],
            projectType: ProjectType.personal,
          ),
        ],
        education: [
          CandidateEducation(
            id: 'edu_5',
            institution: 'VIT Chennai',
            degree: 'B.Tech',
            fieldOfStudy: 'Computer Science and Engineering',
            startDate: DateTime(2022, 8, 1),
            endDate: DateTime(2026, 5, 31),
            isCurrentlyStudying: true,
            grade: 7.5,
            gradeType: 'CGPA',
            relevantCourses: [
              'Programming Fundamentals',
              'Web Technologies',
              'Data Structures',
              'Computer Networks',
              'Software Engineering',
            ],
            achievements: [
              'Active participant in coding competitions',
              'Member of Programming Club',
            ],
          ),
        ],
        certifications: [],
        languages: ['English', 'Hindi'],
        preferences: CandidatePreferences(
          preferredLocations: ['Delhi', 'Gurgaon', 'Noida'],
          preferredIndustries: ['Technology', 'Startups'],
          expectedSalaryMin: 12000,
          expectedSalaryMax: 20000,
          preferredJobTypes: [JobType.internship, JobType.partTime],
          preferredWorkModes: [WorkMode.onsite, WorkMode.hybrid],
          willingToRelocate: false,
          openToRemote: true,
          noticePeriod: 0,
        ),
        status: CandidateStatus.active,
        isProfileComplete: false,
        profileCompletionPercentage: 65,
        lastActiveAt: DateTime.now().subtract(Duration(days: 2)),
        createdAt: DateTime(2022, 9, 10),
        updatedAt: DateTime.now().subtract(Duration(days: 7)),
      ),
    ];

    _watchlist = ['candidate_1', 'candidate_2'];
    _interactions = [
      CandidateInteraction(
        id: 'int_1',
        candidateId: 'candidate_1',
        type: InteractionType.message,
        content:
            'Thank you for your application. We will review and get back to you soon.',
        timestamp: DateTime.now().subtract(Duration(days: 5)),
        recruiterId: 'recruiter_1',
        recruiterName: 'John Recruiter',
      ),
      CandidateInteraction(
        id: 'int_2',
        candidateId: 'candidate_2',
        type: InteractionType.shortlist,
        content: 'Application shortlisted for technical interview round.',
        timestamp: DateTime.now().subtract(Duration(days: 3)),
        recruiterId: 'recruiter_1',
        recruiterName: 'John Recruiter',
      ),
    ];

    _isInitialized = true;
  }

  @override
  Future<List<CandidateModel>> getAllCandidates() async {
    await Future.delayed(Duration(milliseconds: 500));
    return List.from(_candidates);
  }

  @override
  Future<CandidateModel> getCandidateById(String id) async {
    await Future.delayed(Duration(milliseconds: 300));
    return _candidates.firstWhere(
      (candidate) => candidate.id == id,
      orElse: () => throw Exception('Candidate not found'),
    );
  }

  @override
  Future<List<CandidateModel>> searchCandidates(
    CandidateSearchFilters filters,
  ) async {
    await Future.delayed(Duration(milliseconds: 600));

    var filteredCandidates = List<CandidateModel>.from(_candidates);

    if (filters.name != null && filters.name!.isNotEmpty) {
      filteredCandidates = filteredCandidates
          .where(
            (candidate) => candidate.name.toLowerCase().contains(
              filters.name!.toLowerCase(),
            ),
          )
          .toList();
    }

    if (filters.skills != null && filters.skills!.isNotEmpty) {
      filteredCandidates = filteredCandidates
          .where(
            (candidate) => filters.skills!.any(
              (skill) => candidate.skills.any(
                (candidateSkill) =>
                    candidateSkill.toLowerCase().contains(skill.toLowerCase()),
              ),
            ),
          )
          .toList();
    }

    if (filters.college != null && filters.college!.isNotEmpty) {
      filteredCandidates = filteredCandidates
          .where(
            (candidate) => candidate.college.toLowerCase().contains(
              filters.college!.toLowerCase(),
            ),
          )
          .toList();
    }

    if (filters.department != null && filters.department!.isNotEmpty) {
      filteredCandidates = filteredCandidates
          .where(
            (candidate) => candidate.department.toLowerCase().contains(
              filters.department!.toLowerCase(),
            ),
          )
          .toList();
    }

    if (filters.minCGPA != null) {
      filteredCandidates = filteredCandidates
          .where((candidate) => candidate.cgpa >= filters.minCGPA!)
          .toList();
    }

    if (filters.maxCGPA != null) {
      filteredCandidates = filteredCandidates
          .where((candidate) => candidate.cgpa <= filters.maxCGPA!)
          .toList();
    }

    if (filters.graduationYear != null) {
      filteredCandidates = filteredCandidates
          .where(
            (candidate) => candidate.graduationYear == filters.graduationYear,
          )
          .toList();
    }

    if (filters.location != null && filters.location!.isNotEmpty) {
      filteredCandidates = filteredCandidates
          .where(
            (candidate) => candidate.preferences.preferredLocations.any(
              (location) => location.toLowerCase().contains(
                filters.location!.toLowerCase(),
              ),
            ),
          )
          .toList();
    }

    return filteredCandidates;
  }

  @override
  Future<List<CandidateModel>> getCandidatesBySkills(
    List<String> skills,
  ) async {
    await Future.delayed(Duration(milliseconds: 400));
    return _candidates
        .where(
          (candidate) => skills.any(
            (skill) => candidate.skills.any(
              (candidateSkill) =>
                  candidateSkill.toLowerCase() == skill.toLowerCase(),
            ),
          ),
        )
        .toList();
  }

  @override
  Future<List<CandidateModel>> getCandidatesByCollege(String college) async {
    await Future.delayed(Duration(milliseconds: 300));
    return _candidates
        .where(
          (candidate) =>
              candidate.college.toLowerCase().contains(college.toLowerCase()),
        )
        .toList();
  }

  @override
  Future<List<CandidateModel>> getCandidatesByDepartment(
    String department,
  ) async {
    await Future.delayed(Duration(milliseconds: 300));
    return _candidates
        .where(
          (candidate) => candidate.department.toLowerCase().contains(
            department.toLowerCase(),
          ),
        )
        .toList();
  }

  @override
  Future<List<CandidateModel>> getCandidatesForJob(String jobId) async {
    await Future.delayed(Duration(milliseconds: 500));
    // Mock logic for job compatibility
    // In real implementation, this would match job requirements with candidate profiles
    return _candidates
        .where(
          (candidate) =>
              candidate.isProfileComplete &&
              candidate.status == CandidateStatus.active,
        )
        .toList();
  }

  @override
  Future<CandidateProfile> getCandidateProfile(String candidateId) async {
    await Future.delayed(Duration(milliseconds: 400));
    final candidate = await getCandidateById(candidateId);

    return CandidateProfile(
      candidate: candidate,
      applicationHistory: [
        ApplicationHistory(
          jobId: 'job_1',
          jobTitle: 'Software Development Engineer',
          companyName: 'TechCorp Solutions',
          appliedAt: DateTime.now().subtract(Duration(days: 12)),
          status: 'Shortlisted',
          currentRound: 'Technical Interview',
        ),
        ApplicationHistory(
          jobId: 'job_2',
          jobTitle: 'Frontend Developer Intern',
          companyName: 'TechCorp Solutions',
          appliedAt: DateTime.now().subtract(Duration(days: 20)),
          status: 'Selected',
          currentRound: 'Completed',
        ),
      ],
      skillRating: {
        'Java': 8.5,
        'React': 8.0,
        'Spring Boot': 8.2,
        'AWS': 7.5,
        'MySQL': 7.8,
      },
      performanceMetrics: CandidatePerformanceMetrics(
        averageScore: 87.5,
        totalApplications: 5,
        interviewSuccessRate: 75.0,
        responseTime: 2.5, // hours
        profileViews: 45,
        lastUpdated: DateTime.now().subtract(Duration(days: 3)),
      ),
    );
  }

  @override
  Future<List<CandidateModel>> getTopCandidates(int limit) async {
    await Future.delayed(Duration(milliseconds: 400));
    final sortedCandidates = List<CandidateModel>.from(_candidates);

    // Sort by CGPA, profile completion, and activity
    sortedCandidates.sort((a, b) {
      final scoreA =
          a.cgpa * 0.4 +
          (a.profileCompletionPercentage / 100) * 0.3 +
          (a.experiences.length * 0.2) +
          (a.projects.length * 0.1);
      final scoreB =
          b.cgpa * 0.4 +
          (b.profileCompletionPercentage / 100) * 0.3 +
          (b.experiences.length * 0.2) +
          (b.projects.length * 0.1);
      return scoreB.compareTo(scoreA);
    });

    return sortedCandidates.take(limit).toList();
  }

  @override
  Future<CandidateStats> getCandidateStatistics() async {
    await Future.delayed(Duration(milliseconds: 500));

    final totalCandidates = _candidates.length;
    final activeCandidates = _candidates
        .where((c) => c.status == CandidateStatus.active)
        .length;
    final completedProfiles = _candidates
        .where((c) => c.isProfileComplete)
        .length;
    final freshGraduates = _candidates
        .where((c) => c.graduationYear >= DateTime.now().year)
        .length;
    final experiencedCandidates = _candidates
        .where((c) => c.experiences.isNotEmpty)
        .length;

    // Department wise distribution
    final departmentStats = <String, int>{};
    for (final candidate in _candidates) {
      departmentStats[candidate.department] =
          (departmentStats[candidate.department] ?? 0) + 1;
    }

    // College wise distribution
    final collegeStats = <String, int>{};
    for (final candidate in _candidates) {
      collegeStats[candidate.college] =
          (collegeStats[candidate.college] ?? 0) + 1;
    }

    // Skill distribution (top 10)
    final skillStats = <String, int>{};
    for (final candidate in _candidates) {
      for (final skill in candidate.skills) {
        skillStats[skill] = (skillStats[skill] ?? 0) + 1;
      }
    }
    final topSkills = skillStats.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return CandidateStats(
      totalCandidates: totalCandidates,
      activeCandidates: activeCandidates,
      completedProfiles: completedProfiles,
      freshGraduates: freshGraduates,
      experiencedCandidates: experiencedCandidates,
      averageCGPA:
          _candidates.map((c) => c.cgpa).reduce((a, b) => a + b) /
          totalCandidates,
      departmentWiseDistribution: departmentStats,
      collegeWiseDistribution: collegeStats,
      topSkills: Map.fromEntries(topSkills.take(10)),
      profileCompletionRate: (completedProfiles / totalCandidates) * 100,
    );
  }

  @override
  Future<List<CandidateModel>> getFreshGraduates() async {
    await Future.delayed(Duration(milliseconds: 300));
    return _candidates
        .where(
          (candidate) =>
              candidate.graduationYear >= DateTime.now().year &&
              candidate.experiences.isEmpty,
        )
        .toList();
  }

  @override
  Future<List<CandidateModel>> getExperiencedCandidates() async {
    await Future.delayed(Duration(milliseconds: 300));
    return _candidates
        .where((candidate) => candidate.experiences.isNotEmpty)
        .toList();
  }

  @override
  Future<bool> addToWatchlist(String candidateId) async {
    await Future.delayed(Duration(milliseconds: 200));
    if (!_watchlist.contains(candidateId)) {
      _watchlist.add(candidateId);
    }
    return true;
  }

  @override
  Future<bool> removeFromWatchlist(String candidateId) async {
    await Future.delayed(Duration(milliseconds: 200));
    _watchlist.remove(candidateId);
    return true;
  }

  @override
  Future<List<CandidateModel>> getWatchlistedCandidates() async {
    await Future.delayed(Duration(milliseconds: 300));
    return _candidates
        .where((candidate) => _watchlist.contains(candidate.id))
        .toList();
  }

  @override
  Future<bool> sendMessage(String candidateId, String message) async {
    await Future.delayed(Duration(milliseconds: 500));

    _interactions.add(
      CandidateInteraction(
        id: 'int_${DateTime.now().millisecondsSinceEpoch}',
        candidateId: candidateId,
        type: InteractionType.message,
        content: message,
        timestamp: DateTime.now(),
        recruiterId: 'recruiter_1',
        recruiterName: 'Current Recruiter',
      ),
    );

    return true;
  }

  @override
  Future<List<CandidateInteraction>> getCandidateInteractions(
    String candidateId,
  ) async {
    await Future.delayed(Duration(milliseconds: 300));
    return _interactions
        .where((interaction) => interaction.candidateId == candidateId)
        .toList();
  }

  @override
  Future<CandidateCompatibilityScore> checkJobCompatibility(
    String candidateId,
    String jobId,
  ) async {
    await Future.delayed(Duration(milliseconds: 400));

    final candidate = await getCandidateById(candidateId);

    // Mock compatibility scoring
    double skillMatch = 85.0; // Based on skill matching
    double educationMatch = 90.0; // Based on education requirements
    double experienceMatch = 70.0; // Based on experience requirements
    double locationMatch = 95.0; // Based on location preferences

    double overallScore =
        (skillMatch + educationMatch + experienceMatch + locationMatch) / 4;

    return CandidateCompatibilityScore(
      candidateId: candidateId,
      jobId: jobId,
      overallScore: overallScore,
      skillMatch: skillMatch,
      educationMatch: educationMatch,
      experienceMatch: experienceMatch,
      locationMatch: locationMatch,
      matchingSkills: ['Java', 'Spring Boot', 'React'],
      missingSkills: ['AWS', 'Docker'],
      recommendations: [
        'Strong technical background matches job requirements',
        'Consider additional AWS certification',
        'Good cultural fit based on past experience',
      ],
    );
  }
}

// Supporting classes
class CandidateSearchFilters {
  final String? name;
  final List<String>? skills;
  final String? college;
  final String? department;
  final double? minCGPA;
  final double? maxCGPA;
  final int? graduationYear;
  final String? location;
  final bool? hasExperience;
  final bool? isProfileComplete;

  CandidateSearchFilters({
    this.name,
    this.skills,
    this.college,
    this.department,
    this.minCGPA,
    this.maxCGPA,
    this.graduationYear,
    this.location,
    this.hasExperience,
    this.isProfileComplete,
  });
}

class CandidateProfile {
  final CandidateModel candidate;
  final List<ApplicationHistory> applicationHistory;
  final Map<String, double> skillRating;
  final CandidatePerformanceMetrics performanceMetrics;

  CandidateProfile({
    required this.candidate,
    required this.applicationHistory,
    required this.skillRating,
    required this.performanceMetrics,
  });
}

class ApplicationHistory {
  final String jobId;
  final String jobTitle;
  final String companyName;
  final DateTime appliedAt;
  final String status;
  final String currentRound;

  ApplicationHistory({
    required this.jobId,
    required this.jobTitle,
    required this.companyName,
    required this.appliedAt,
    required this.status,
    required this.currentRound,
  });
}

class CandidatePerformanceMetrics {
  final double averageScore;
  final int totalApplications;
  final double interviewSuccessRate;
  final double responseTime;
  final int profileViews;
  final DateTime lastUpdated;

  CandidatePerformanceMetrics({
    required this.averageScore,
    required this.totalApplications,
    required this.interviewSuccessRate,
    required this.responseTime,
    required this.profileViews,
    required this.lastUpdated,
  });
}

class CandidateStats {
  final int totalCandidates;
  final int activeCandidates;
  final int completedProfiles;
  final int freshGraduates;
  final int experiencedCandidates;
  final double averageCGPA;
  final Map<String, int> departmentWiseDistribution;
  final Map<String, int> collegeWiseDistribution;
  final Map<String, int> topSkills;
  final double profileCompletionRate;

  CandidateStats({
    required this.totalCandidates,
    required this.activeCandidates,
    required this.completedProfiles,
    required this.freshGraduates,
    required this.experiencedCandidates,
    required this.averageCGPA,
    required this.departmentWiseDistribution,
    required this.collegeWiseDistribution,
    required this.topSkills,
    required this.profileCompletionRate,
  });
}

class CandidateInteraction {
  final String id;
  final String candidateId;
  final InteractionType type;
  final String content;
  final DateTime timestamp;
  final String recruiterId;
  final String recruiterName;

  CandidateInteraction({
    required this.id,
    required this.candidateId,
    required this.type,
    required this.content,
    required this.timestamp,
    required this.recruiterId,
    required this.recruiterName,
  });
}

class CandidateCompatibilityScore {
  final String candidateId;
  final String jobId;
  final double overallScore;
  final double skillMatch;
  final double educationMatch;
  final double experienceMatch;
  final double locationMatch;
  final List<String> matchingSkills;
  final List<String> missingSkills;
  final List<String> recommendations;

  CandidateCompatibilityScore({
    required this.candidateId,
    required this.jobId,
    required this.overallScore,
    required this.skillMatch,
    required this.educationMatch,
    required this.experienceMatch,
    required this.locationMatch,
    required this.matchingSkills,
    required this.missingSkills,
    required this.recommendations,
  });
}

enum InteractionType {
  message,
  shortlist,
  interview,
  selection,
  rejection,
  note,
}

extension InteractionTypeExtension on InteractionType {
  String get displayName {
    switch (this) {
      case InteractionType.message:
        return 'Message';
      case InteractionType.shortlist:
        return 'Shortlisted';
      case InteractionType.interview:
        return 'Interview';
      case InteractionType.selection:
        return 'Selected';
      case InteractionType.rejection:
        return 'Rejected';
      case InteractionType.note:
        return 'Note';
    }
  }
}
