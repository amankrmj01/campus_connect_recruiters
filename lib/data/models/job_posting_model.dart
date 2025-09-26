import 'package:campus_connect_recruiter/data/models/job_enums.dart';

class JobPostingModel {
  final String id;
  final String title;
  final String description;
  final String companyId;
  final String companyName;
  final String recruiterId;
  final String recruiterName;
  final JobType jobType;
  final WorkMode workMode;
  final String location;
  final List<String> skills;
  final List<String> departments;
  final JobRequirements requirements;
  final SalaryRange salaryRange;
  final DateTime applicationDeadline;
  final JobStatus status;
  final int totalApplications;
  final int shortlistedCount;
  final int interviewedCount;
  final int selectedCount;
  final List<RecruitmentRound> recruitmentRounds;
  final Map<String, dynamic> customFields;
  final bool isActive;
  final bool isFeatured;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? publishedAt;

  JobPostingModel({
    required this.id,
    required this.title,
    required this.description,
    required this.companyId,
    required this.companyName,
    required this.recruiterId,
    required this.recruiterName,
    required this.jobType,
    required this.workMode,
    required this.location,
    required this.skills,
    required this.departments,
    required this.requirements,
    required this.salaryRange,
    required this.applicationDeadline,
    required this.status,
    required this.totalApplications,
    required this.shortlistedCount,
    required this.interviewedCount,
    required this.selectedCount,
    required this.recruitmentRounds,
    required this.customFields,
    required this.isActive,
    required this.isFeatured,
    required this.createdAt,
    this.updatedAt,
    this.publishedAt,
  });

  factory JobPostingModel.fromJson(Map<String, dynamic> json) {
    return JobPostingModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      companyId: json['company_id'] as String,
      companyName: json['company_name'] as String,
      recruiterId: json['recruiter_id'] as String,
      recruiterName: json['recruiter_name'] as String,
      jobType: JobType.values.firstWhere(
        (type) => type.name == json['job_type'],
        orElse: () => JobType.fullTime,
      ),
      workMode: WorkMode.values.firstWhere(
        (mode) => mode.name == json['work_mode'],
        orElse: () => WorkMode.onsite,
      ),
      location: json['location'] as String,
      skills: List<String>.from(json['skills'] as List),
      departments: List<String>.from(json['departments'] as List),
      requirements: JobRequirements.fromJson(json['requirements']),
      salaryRange: SalaryRange.fromJson(json['salary_range']),
      applicationDeadline: DateTime.parse(
        json['application_deadline'] as String,
      ),
      status: JobStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => JobStatus.draft,
      ),
      totalApplications: json['total_applications'] as int,
      shortlistedCount: json['shortlisted_count'] as int,
      interviewedCount: json['interviewed_count'] as int,
      selectedCount: json['selected_count'] as int,
      recruitmentRounds: (json['recruitment_rounds'] as List)
          .map((round) => RecruitmentRound.fromJson(round))
          .toList(),
      customFields: Map<String, dynamic>.from(json['custom_fields']),
      isActive: json['is_active'] as bool,
      isFeatured: json['is_featured'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'company_id': companyId,
      'company_name': companyName,
      'recruiter_id': recruiterId,
      'recruiter_name': recruiterName,
      'job_type': jobType.name,
      'work_mode': workMode.name,
      'location': location,
      'skills': skills,
      'departments': departments,
      'requirements': requirements.toJson(),
      'salary_range': salaryRange.toJson(),
      'application_deadline': applicationDeadline.toIso8601String(),
      'status': status.name,
      'total_applications': totalApplications,
      'shortlisted_count': shortlistedCount,
      'interviewed_count': interviewedCount,
      'selected_count': selectedCount,
      'recruitment_rounds': recruitmentRounds.map((r) => r.toJson()).toList(),
      'custom_fields': customFields,
      'is_active': isActive,
      'is_featured': isFeatured,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'published_at': publishedAt?.toIso8601String(),
    };
  }

  JobPostingModel copyWith({
    String? id,
    String? title,
    String? description,
    String? companyId,
    String? companyName,
    String? recruiterId,
    String? recruiterName,
    JobType? jobType,
    WorkMode? workMode,
    String? location,
    List<String>? skills,
    List<String>? departments,
    JobRequirements? requirements,
    SalaryRange? salaryRange,
    DateTime? applicationDeadline,
    JobStatus? status,
    int? totalApplications,
    int? shortlistedCount,
    int? interviewedCount,
    int? selectedCount,
    List<RecruitmentRound>? recruitmentRounds,
    Map<String, dynamic>? customFields,
    bool? isActive,
    bool? isFeatured,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? publishedAt,
  }) {
    return JobPostingModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      recruiterId: recruiterId ?? this.recruiterId,
      recruiterName: recruiterName ?? this.recruiterName,
      jobType: jobType ?? this.jobType,
      workMode: workMode ?? this.workMode,
      location: location ?? this.location,
      skills: skills ?? List.from(this.skills),
      departments: departments ?? List.from(this.departments),
      requirements: requirements ?? this.requirements,
      salaryRange: salaryRange ?? this.salaryRange,
      applicationDeadline: applicationDeadline ?? this.applicationDeadline,
      status: status ?? this.status,
      totalApplications: totalApplications ?? this.totalApplications,
      shortlistedCount: shortlistedCount ?? this.shortlistedCount,
      interviewedCount: interviewedCount ?? this.interviewedCount,
      selectedCount: selectedCount ?? this.selectedCount,
      recruitmentRounds: recruitmentRounds ?? List.from(this.recruitmentRounds),
      customFields: customFields ?? Map.from(this.customFields),
      isActive: isActive ?? this.isActive,
      isFeatured: isFeatured ?? this.isFeatured,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }

  bool get canReceiveApplications {
    return isActive &&
        status == JobStatus.published &&
        DateTime.now().isBefore(applicationDeadline);
  }

  double get applicationToShortlistRate {
    return totalApplications > 0
        ? (shortlistedCount / totalApplications) * 100
        : 0.0;
  }

  double get interviewToSelectionRate {
    return interviewedCount > 0
        ? (selectedCount / interviewedCount) * 100
        : 0.0;
  }

  @override
  String toString() {
    return 'JobPostingModel(id: $id, title: $title, companyName: $companyName, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JobPostingModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class JobRequirements {
  final String minimumEducation;
  final double minimumCGPA;
  final int minimumExperience;
  final int maximumExperience;
  final List<String> mandatorySkills;
  final List<String> preferredSkills;
  final List<String> certifications;
  final bool allowBacklogs;
  final int maxBacklogs;
  final List<String> eligibleBranches;
  final Map<String, dynamic> additionalCriteria;

  JobRequirements({
    required this.minimumEducation,
    required this.minimumCGPA,
    required this.minimumExperience,
    required this.maximumExperience,
    required this.mandatorySkills,
    required this.preferredSkills,
    required this.certifications,
    required this.allowBacklogs,
    required this.maxBacklogs,
    required this.eligibleBranches,
    required this.additionalCriteria,
  });

  factory JobRequirements.fromJson(Map<String, dynamic> json) {
    return JobRequirements(
      minimumEducation: json['minimum_education'] as String,
      minimumCGPA: (json['minimum_cgpa'] as num).toDouble(),
      minimumExperience: json['minimum_experience'] as int,
      maximumExperience: json['maximum_experience'] as int,
      mandatorySkills: List<String>.from(json['mandatory_skills'] as List),
      preferredSkills: List<String>.from(json['preferred_skills'] as List),
      certifications: List<String>.from(json['certifications'] as List),
      allowBacklogs: json['allow_backlogs'] as bool,
      maxBacklogs: json['max_backlogs'] as int,
      eligibleBranches: List<String>.from(json['eligible_branches'] as List),
      additionalCriteria: Map<String, dynamic>.from(
        json['additional_criteria'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minimum_education': minimumEducation,
      'minimum_cgpa': minimumCGPA,
      'minimum_experience': minimumExperience,
      'maximum_experience': maximumExperience,
      'mandatory_skills': mandatorySkills,
      'preferred_skills': preferredSkills,
      'certifications': certifications,
      'allow_backlogs': allowBacklogs,
      'max_backlogs': maxBacklogs,
      'eligible_branches': eligibleBranches,
      'additional_criteria': additionalCriteria,
    };
  }

  JobRequirements copyWith({
    String? minimumEducation,
    double? minimumCGPA,
    int? minimumExperience,
    int? maximumExperience,
    List<String>? mandatorySkills,
    List<String>? preferredSkills,
    List<String>? certifications,
    bool? allowBacklogs,
    int? maxBacklogs,
    List<String>? eligibleBranches,
    Map<String, dynamic>? additionalCriteria,
  }) {
    return JobRequirements(
      minimumEducation: minimumEducation ?? this.minimumEducation,
      minimumCGPA: minimumCGPA ?? this.minimumCGPA,
      minimumExperience: minimumExperience ?? this.minimumExperience,
      maximumExperience: maximumExperience ?? this.maximumExperience,
      mandatorySkills: mandatorySkills ?? List.from(this.mandatorySkills),
      preferredSkills: preferredSkills ?? List.from(this.preferredSkills),
      certifications: certifications ?? List.from(this.certifications),
      allowBacklogs: allowBacklogs ?? this.allowBacklogs,
      maxBacklogs: maxBacklogs ?? this.maxBacklogs,
      eligibleBranches: eligibleBranches ?? List.from(this.eligibleBranches),
      additionalCriteria:
          additionalCriteria ?? Map.from(this.additionalCriteria),
    );
  }
}

class SalaryRange {
  final double minimumSalary;
  final double maximumSalary;
  final String currency;
  final SalaryType salaryType;
  final List<String> benefits;
  final Map<String, dynamic> additionalCompensation;

  SalaryRange({
    required this.minimumSalary,
    required this.maximumSalary,
    required this.currency,
    required this.salaryType,
    required this.benefits,
    required this.additionalCompensation,
  });

  factory SalaryRange.fromJson(Map<String, dynamic> json) {
    return SalaryRange(
      minimumSalary: (json['minimum_salary'] as num).toDouble(),
      maximumSalary: (json['maximum_salary'] as num).toDouble(),
      currency: json['currency'] as String,
      salaryType: SalaryType.values.firstWhere(
        (type) => type.name == json['salary_type'],
        orElse: () => SalaryType.annual,
      ),
      benefits: List<String>.from(json['benefits'] as List),
      additionalCompensation: Map<String, dynamic>.from(
        json['additional_compensation'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minimum_salary': minimumSalary,
      'maximum_salary': maximumSalary,
      'currency': currency,
      'salary_type': salaryType.name,
      'benefits': benefits,
      'additional_compensation': additionalCompensation,
    };
  }

  SalaryRange copyWith({
    double? minimumSalary,
    double? maximumSalary,
    String? currency,
    SalaryType? salaryType,
    List<String>? benefits,
    Map<String, dynamic>? additionalCompensation,
  }) {
    return SalaryRange(
      minimumSalary: minimumSalary ?? this.minimumSalary,
      maximumSalary: maximumSalary ?? this.maximumSalary,
      currency: currency ?? this.currency,
      salaryType: salaryType ?? this.salaryType,
      benefits: benefits ?? List.from(this.benefits),
      additionalCompensation:
          additionalCompensation ?? Map.from(this.additionalCompensation),
    );
  }

  String get displayRange {
    return '${currency} ${minimumSalary.toStringAsFixed(1)} - ${maximumSalary.toStringAsFixed(1)} ${salaryType.displayName}';
  }
}

class RecruitmentRound {
  final String id;
  final String name;
  final RoundType roundType;
  final int order;
  final String description;
  final DateTime? scheduledDate;
  final String venue;
  final int duration; // in minutes
  final RoundStatus status;
  final List<String> eligibleCandidates;
  final List<String> selectedCandidates;
  final Map<String, dynamic> settings;

  RecruitmentRound({
    required this.id,
    required this.name,
    required this.roundType,
    required this.order,
    required this.description,
    this.scheduledDate,
    required this.venue,
    required this.duration,
    required this.status,
    required this.eligibleCandidates,
    required this.selectedCandidates,
    required this.settings,
  });

  factory RecruitmentRound.fromJson(Map<String, dynamic> json) {
    return RecruitmentRound(
      id: json['id'] as String,
      name: json['name'] as String,
      roundType: RoundType.values.firstWhere(
        (type) => type.name == json['round_type'],
        orElse: () => RoundType.onlineTest,
      ),
      order: json['order'] as int,
      description: json['description'] as String,
      scheduledDate: json['scheduled_date'] != null
          ? DateTime.parse(json['scheduled_date'] as String)
          : null,
      venue: json['venue'] as String,
      duration: json['duration'] as int,
      status: RoundStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => RoundStatus.planned,
      ),
      eligibleCandidates: List<String>.from(
        json['eligible_candidates'] as List,
      ),
      selectedCandidates: List<String>.from(
        json['selected_candidates'] as List,
      ),
      settings: Map<String, dynamic>.from(json['settings']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'round_type': roundType.name,
      'order': order,
      'description': description,
      'scheduled_date': scheduledDate?.toIso8601String(),
      'venue': venue,
      'duration': duration,
      'status': status.name,
      'eligible_candidates': eligibleCandidates,
      'selected_candidates': selectedCandidates,
      'settings': settings,
    };
  }

  RecruitmentRound copyWith({
    String? id,
    String? name,
    RoundType? roundType,
    int? order,
    String? description,
    DateTime? scheduledDate,
    String? venue,
    int? duration,
    RoundStatus? status,
    List<String>? eligibleCandidates,
    List<String>? selectedCandidates,
    Map<String, dynamic>? settings,
  }) {
    return RecruitmentRound(
      id: id ?? this.id,
      name: name ?? this.name,
      roundType: roundType ?? this.roundType,
      order: order ?? this.order,
      description: description ?? this.description,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      venue: venue ?? this.venue,
      duration: duration ?? this.duration,
      status: status ?? this.status,
      eligibleCandidates:
          eligibleCandidates ?? List.from(this.eligibleCandidates),
      selectedCandidates:
          selectedCandidates ?? List.from(this.selectedCandidates),
      settings: settings ?? Map.from(this.settings),
    );
  }

  double get selectionRate {
    return eligibleCandidates.isNotEmpty
        ? (selectedCandidates.length / eligibleCandidates.length) * 100
        : 0.0;
  }
}

// Enums
enum JobStatus { draft, published, paused, closed, expired }

extension JobStatusExtension on JobStatus {
  String get name {
    switch (this) {
      case JobStatus.draft:
        return 'draft';
      case JobStatus.published:
        return 'published';
      case JobStatus.paused:
        return 'paused';
      case JobStatus.closed:
        return 'closed';
      case JobStatus.expired:
        return 'expired';
    }
  }

  String get displayName {
    switch (this) {
      case JobStatus.draft:
        return 'Draft';
      case JobStatus.published:
        return 'Published';
      case JobStatus.paused:
        return 'Paused';
      case JobStatus.closed:
        return 'Closed';
      case JobStatus.expired:
        return 'Expired';
    }
  }
}

enum SalaryType { annual, monthly, hourly }

extension SalaryTypeExtension on SalaryType {
  String get name {
    switch (this) {
      case SalaryType.annual:
        return 'annual';
      case SalaryType.monthly:
        return 'monthly';
      case SalaryType.hourly:
        return 'hourly';
    }
  }

  String get displayName {
    switch (this) {
      case SalaryType.annual:
        return 'LPA';
      case SalaryType.monthly:
        return 'per month';
      case SalaryType.hourly:
        return 'per hour';
    }
  }
}

enum RoundType {
  onlineTest,
  technicalInterview,
  hrInterview,
  groupDiscussion,
  caseStudy,
  presentation,
  codingRound,
  finalInterview,
}

extension RoundTypeExtension on RoundType {
  String get name {
    switch (this) {
      case RoundType.onlineTest:
        return 'online_test';
      case RoundType.technicalInterview:
        return 'technical_interview';
      case RoundType.hrInterview:
        return 'hr_interview';
      case RoundType.groupDiscussion:
        return 'group_discussion';
      case RoundType.caseStudy:
        return 'case_study';
      case RoundType.presentation:
        return 'presentation';
      case RoundType.codingRound:
        return 'coding_round';
      case RoundType.finalInterview:
        return 'final_interview';
    }
  }

  String get displayName {
    switch (this) {
      case RoundType.onlineTest:
        return 'Online Test';
      case RoundType.technicalInterview:
        return 'Technical Interview';
      case RoundType.hrInterview:
        return 'HR Interview';
      case RoundType.groupDiscussion:
        return 'Group Discussion';
      case RoundType.caseStudy:
        return 'Case Study';
      case RoundType.presentation:
        return 'Presentation';
      case RoundType.codingRound:
        return 'Coding Round';
      case RoundType.finalInterview:
        return 'Final Interview';
    }
  }
}

enum RoundStatus { planned, scheduled, inProgress, completed, cancelled }

extension RoundStatusExtension on RoundStatus {
  String get name {
    switch (this) {
      case RoundStatus.planned:
        return 'planned';
      case RoundStatus.scheduled:
        return 'scheduled';
      case RoundStatus.inProgress:
        return 'in_progress';
      case RoundStatus.completed:
        return 'completed';
      case RoundStatus.cancelled:
        return 'cancelled';
    }
  }

  String get displayName {
    switch (this) {
      case RoundStatus.planned:
        return 'Planned';
      case RoundStatus.scheduled:
        return 'Scheduled';
      case RoundStatus.inProgress:
        return 'In Progress';
      case RoundStatus.completed:
        return 'Completed';
      case RoundStatus.cancelled:
        return 'Cancelled';
    }
  }
}
