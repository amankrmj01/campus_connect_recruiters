import 'package:campus_connect_recruiter/data/models/job_enums.dart';

class CandidateModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String regNumber;
  final String college;
  final String department;
  final String degreeType;
  final int graduationYear;
  final double cgpa;
  final String gender;
  final DateTime dateOfBirth;
  final String address;
  final String profilePictureUrl;
  final List<String> skills;
  final List<CandidateExperience> experiences;
  final List<CandidateProject> projects;
  final List<CandidateEducation> education;
  final List<CandidateCertification> certifications;
  final List<String> languages;
  final CandidatePreferences preferences;
  final CandidateStatus status;
  final bool isProfileComplete;
  final int profileCompletionPercentage;
  final DateTime lastActiveAt;
  final DateTime createdAt;
  final DateTime? updatedAt;

  CandidateModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.regNumber,
    required this.college,
    required this.department,
    required this.degreeType,
    required this.graduationYear,
    required this.cgpa,
    required this.gender,
    required this.dateOfBirth,
    required this.address,
    required this.profilePictureUrl,
    required this.skills,
    required this.experiences,
    required this.projects,
    required this.education,
    required this.certifications,
    required this.languages,
    required this.preferences,
    required this.status,
    required this.isProfileComplete,
    required this.profileCompletionPercentage,
    required this.lastActiveAt,
    required this.createdAt,
    this.updatedAt,
  });

  factory CandidateModel.fromJson(Map<String, dynamic> json) {
    return CandidateModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      regNumber: json['reg_number'] as String,
      college: json['college'] as String,
      department: json['department'] as String,
      degreeType: json['degree_type'] as String,
      graduationYear: json['graduation_year'] as int,
      cgpa: (json['cgpa'] as num).toDouble(),
      gender: json['gender'] as String,
      dateOfBirth: DateTime.parse(json['date_of_birth'] as String),
      address: json['address'] as String,
      profilePictureUrl: json['profile_picture_url'] as String,
      skills: List<String>.from(json['skills'] as List),
      experiences: (json['experiences'] as List)
          .map((exp) => CandidateExperience.fromJson(exp))
          .toList(),
      projects: (json['projects'] as List)
          .map((proj) => CandidateProject.fromJson(proj))
          .toList(),
      education: (json['education'] as List)
          .map((edu) => CandidateEducation.fromJson(edu))
          .toList(),
      certifications: (json['certifications'] as List)
          .map((cert) => CandidateCertification.fromJson(cert))
          .toList(),
      languages: List<String>.from(json['languages'] as List),
      preferences: CandidatePreferences.fromJson(json['preferences']),
      status: CandidateStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => CandidateStatus.active,
      ),
      isProfileComplete: json['is_profile_complete'] as bool,
      profileCompletionPercentage: json['profile_completion_percentage'] as int,
      lastActiveAt: DateTime.parse(json['last_active_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'reg_number': regNumber,
      'college': college,
      'department': department,
      'degree_type': degreeType,
      'graduation_year': graduationYear,
      'cgpa': cgpa,
      'gender': gender,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'address': address,
      'profile_picture_url': profilePictureUrl,
      'skills': skills,
      'experiences': experiences.map((e) => e.toJson()).toList(),
      'projects': projects.map((p) => p.toJson()).toList(),
      'education': education.map((e) => e.toJson()).toList(),
      'certifications': certifications.map((c) => c.toJson()).toList(),
      'languages': languages,
      'preferences': preferences.toJson(),
      'status': status.name,
      'is_profile_complete': isProfileComplete,
      'profile_completion_percentage': profileCompletionPercentage,
      'last_active_at': lastActiveAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  CandidateModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? regNumber,
    String? college,
    String? department,
    String? degreeType,
    int? graduationYear,
    double? cgpa,
    String? gender,
    DateTime? dateOfBirth,
    String? address,
    String? profilePictureUrl,
    List<String>? skills,
    List<CandidateExperience>? experiences,
    List<CandidateProject>? projects,
    List<CandidateEducation>? education,
    List<CandidateCertification>? certifications,
    List<String>? languages,
    CandidatePreferences? preferences,
    CandidateStatus? status,
    bool? isProfileComplete,
    int? profileCompletionPercentage,
    DateTime? lastActiveAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CandidateModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      regNumber: regNumber ?? this.regNumber,
      college: college ?? this.college,
      department: department ?? this.department,
      degreeType: degreeType ?? this.degreeType,
      graduationYear: graduationYear ?? this.graduationYear,
      cgpa: cgpa ?? this.cgpa,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      skills: skills ?? List.from(this.skills),
      experiences: experiences ?? List.from(this.experiences),
      projects: projects ?? List.from(this.projects),
      education: education ?? List.from(this.education),
      certifications: certifications ?? List.from(this.certifications),
      languages: languages ?? List.from(this.languages),
      preferences: preferences ?? this.preferences,
      status: status ?? this.status,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      profileCompletionPercentage:
          profileCompletionPercentage ?? this.profileCompletionPercentage,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  int get age {
    return DateTime.now().year - dateOfBirth.year;
  }

  bool get isEligibleForPlacement {
    return isProfileComplete && cgpa >= 6.0 && status == CandidateStatus.active;
  }

  String get fullQualification {
    return '$degreeType in $department - $college ($graduationYear)';
  }

  @override
  String toString() {
    return 'CandidateModel(id: $id, name: $name, regNumber: $regNumber, college: $college)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CandidateModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class CandidateExperience {
  final String id;
  final String company;
  final String position;
  final String location;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCurrentJob;
  final String description;
  final List<String> skills;
  final List<String> achievements;

  CandidateExperience({
    required this.id,
    required this.company,
    required this.position,
    required this.location,
    required this.startDate,
    this.endDate,
    required this.isCurrentJob,
    required this.description,
    required this.skills,
    required this.achievements,
  });

  factory CandidateExperience.fromJson(Map<String, dynamic> json) {
    return CandidateExperience(
      id: json['id'] as String,
      company: json['company'] as String,
      position: json['position'] as String,
      location: json['location'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : null,
      isCurrentJob: json['is_current_job'] as bool,
      description: json['description'] as String,
      skills: List<String>.from(json['skills'] as List),
      achievements: List<String>.from(json['achievements'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company': company,
      'position': position,
      'location': location,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'is_current_job': isCurrentJob,
      'description': description,
      'skills': skills,
      'achievements': achievements,
    };
  }

  CandidateExperience copyWith({
    String? id,
    String? company,
    String? position,
    String? location,
    DateTime? startDate,
    DateTime? endDate,
    bool? isCurrentJob,
    String? description,
    List<String>? skills,
    List<String>? achievements,
  }) {
    return CandidateExperience(
      id: id ?? this.id,
      company: company ?? this.company,
      position: position ?? this.position,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCurrentJob: isCurrentJob ?? this.isCurrentJob,
      description: description ?? this.description,
      skills: skills ?? List.from(this.skills),
      achievements: achievements ?? List.from(this.achievements),
    );
  }

  String get duration {
    final end = endDate ?? DateTime.now();
    final diff = end.difference(startDate);
    final years = diff.inDays ~/ 365;
    final months = (diff.inDays % 365) ~/ 30;

    if (years > 0) {
      return months > 0
          ? '$years year${years > 1 ? 's' : ''} $months month${months > 1 ? 's' : ''}'
          : '$years year${years > 1 ? 's' : ''}';
    } else {
      return '$months month${months > 1 ? 's' : ''}';
    }
  }
}

class CandidateProject {
  final String id;
  final String title;
  final String description;
  final List<String> technologies;
  final String? githubUrl;
  final String? liveUrl;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isOngoing;
  final List<String> features;
  final ProjectType projectType;

  CandidateProject({
    required this.id,
    required this.title,
    required this.description,
    required this.technologies,
    this.githubUrl,
    this.liveUrl,
    required this.startDate,
    this.endDate,
    required this.isOngoing,
    required this.features,
    required this.projectType,
  });

  factory CandidateProject.fromJson(Map<String, dynamic> json) {
    return CandidateProject(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      technologies: List<String>.from(json['technologies'] as List),
      githubUrl: json['github_url'] as String?,
      liveUrl: json['live_url'] as String?,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : null,
      isOngoing: json['is_ongoing'] as bool,
      features: List<String>.from(json['features'] as List),
      projectType: ProjectType.values.firstWhere(
        (type) => type.name == json['project_type'],
        orElse: () => ProjectType.personal,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'technologies': technologies,
      'github_url': githubUrl,
      'live_url': liveUrl,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'is_ongoing': isOngoing,
      'features': features,
      'project_type': projectType.name,
    };
  }

  CandidateProject copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? technologies,
    String? githubUrl,
    String? liveUrl,
    DateTime? startDate,
    DateTime? endDate,
    bool? isOngoing,
    List<String>? features,
    ProjectType? projectType,
  }) {
    return CandidateProject(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      technologies: technologies ?? List.from(this.technologies),
      githubUrl: githubUrl ?? this.githubUrl,
      liveUrl: liveUrl ?? this.liveUrl,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isOngoing: isOngoing ?? this.isOngoing,
      features: features ?? List.from(this.features),
      projectType: projectType ?? this.projectType,
    );
  }
}

class CandidateEducation {
  final String id;
  final String institution;
  final String degree;
  final String fieldOfStudy;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCurrentlyStudying;
  final double? grade;
  final String? gradeType; // CGPA, Percentage, etc.
  final List<String> relevantCourses;
  final List<String> achievements;

  CandidateEducation({
    required this.id,
    required this.institution,
    required this.degree,
    required this.fieldOfStudy,
    required this.startDate,
    this.endDate,
    required this.isCurrentlyStudying,
    this.grade,
    this.gradeType,
    required this.relevantCourses,
    required this.achievements,
  });

  factory CandidateEducation.fromJson(Map<String, dynamic> json) {
    return CandidateEducation(
      id: json['id'] as String,
      institution: json['institution'] as String,
      degree: json['degree'] as String,
      fieldOfStudy: json['field_of_study'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : null,
      isCurrentlyStudying: json['is_currently_studying'] as bool,
      grade: json['grade'] != null ? (json['grade'] as num).toDouble() : null,
      gradeType: json['grade_type'] as String?,
      relevantCourses: List<String>.from(json['relevant_courses'] as List),
      achievements: List<String>.from(json['achievements'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'institution': institution,
      'degree': degree,
      'field_of_study': fieldOfStudy,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'is_currently_studying': isCurrentlyStudying,
      'grade': grade,
      'grade_type': gradeType,
      'relevant_courses': relevantCourses,
      'achievements': achievements,
    };
  }

  CandidateEducation copyWith({
    String? id,
    String? institution,
    String? degree,
    String? fieldOfStudy,
    DateTime? startDate,
    DateTime? endDate,
    bool? isCurrentlyStudying,
    double? grade,
    String? gradeType,
    List<String>? relevantCourses,
    List<String>? achievements,
  }) {
    return CandidateEducation(
      id: id ?? this.id,
      institution: institution ?? this.institution,
      degree: degree ?? this.degree,
      fieldOfStudy: fieldOfStudy ?? this.fieldOfStudy,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCurrentlyStudying: isCurrentlyStudying ?? this.isCurrentlyStudying,
      grade: grade ?? this.grade,
      gradeType: gradeType ?? this.gradeType,
      relevantCourses: relevantCourses ?? List.from(this.relevantCourses),
      achievements: achievements ?? List.from(this.achievements),
    );
  }
}

class CandidateCertification {
  final String id;
  final String name;
  final String issuer;
  final DateTime issueDate;
  final DateTime? expiryDate;
  final String? credentialId;
  final String? credentialUrl;
  final bool isVerified;
  final List<String> skills;

  CandidateCertification({
    required this.id,
    required this.name,
    required this.issuer,
    required this.issueDate,
    this.expiryDate,
    this.credentialId,
    this.credentialUrl,
    required this.isVerified,
    required this.skills,
  });

  factory CandidateCertification.fromJson(Map<String, dynamic> json) {
    return CandidateCertification(
      id: json['id'] as String,
      name: json['name'] as String,
      issuer: json['issuer'] as String,
      issueDate: DateTime.parse(json['issue_date'] as String),
      expiryDate: json['expiry_date'] != null
          ? DateTime.parse(json['expiry_date'] as String)
          : null,
      credentialId: json['credential_id'] as String?,
      credentialUrl: json['credential_url'] as String?,
      isVerified: json['is_verified'] as bool,
      skills: List<String>.from(json['skills'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'issuer': issuer,
      'issue_date': issueDate.toIso8601String(),
      'expiry_date': expiryDate?.toIso8601String(),
      'credential_id': credentialId,
      'credential_url': credentialUrl,
      'is_verified': isVerified,
      'skills': skills,
    };
  }

  CandidateCertification copyWith({
    String? id,
    String? name,
    String? issuer,
    DateTime? issueDate,
    DateTime? expiryDate,
    String? credentialId,
    String? credentialUrl,
    bool? isVerified,
    List<String>? skills,
  }) {
    return CandidateCertification(
      id: id ?? this.id,
      name: name ?? this.name,
      issuer: issuer ?? this.issuer,
      issueDate: issueDate ?? this.issueDate,
      expiryDate: expiryDate ?? this.expiryDate,
      credentialId: credentialId ?? this.credentialId,
      credentialUrl: credentialUrl ?? this.credentialUrl,
      isVerified: isVerified ?? this.isVerified,
      skills: skills ?? List.from(this.skills),
    );
  }

  bool get isExpired {
    return expiryDate != null && DateTime.now().isAfter(expiryDate!);
  }
}

class CandidatePreferences {
  final List<String> preferredLocations;
  final List<String> preferredIndustries;
  final double expectedSalaryMin;
  final double expectedSalaryMax;
  final List<JobType> preferredJobTypes;
  final List<WorkMode> preferredWorkModes;
  final bool willingToRelocate;
  final bool openToRemote;
  final int noticePeriod; // in days

  CandidatePreferences({
    required this.preferredLocations,
    required this.preferredIndustries,
    required this.expectedSalaryMin,
    required this.expectedSalaryMax,
    required this.preferredJobTypes,
    required this.preferredWorkModes,
    required this.willingToRelocate,
    required this.openToRemote,
    required this.noticePeriod,
  });

  factory CandidatePreferences.fromJson(Map<String, dynamic> json) {
    return CandidatePreferences(
      preferredLocations: List<String>.from(
        json['preferred_locations'] as List,
      ),
      preferredIndustries: List<String>.from(
        json['preferred_industries'] as List,
      ),
      expectedSalaryMin: (json['expected_salary_min'] as num).toDouble(),
      expectedSalaryMax: (json['expected_salary_max'] as num).toDouble(),
      preferredJobTypes: (json['preferred_job_types'] as List)
          .map(
            (type) => JobType.values.firstWhere(
              (jt) => jt.name == type,
              orElse: () => JobType.fullTime,
            ),
          )
          .toList(),
      preferredWorkModes: (json['preferred_work_modes'] as List)
          .map(
            (mode) => WorkMode.values.firstWhere(
              (wm) => wm.name == mode,
              orElse: () => WorkMode.onsite,
            ),
          )
          .toList(),
      willingToRelocate: json['willing_to_relocate'] as bool,
      openToRemote: json['open_to_remote'] as bool,
      noticePeriod: json['notice_period'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'preferred_locations': preferredLocations,
      'preferred_industries': preferredIndustries,
      'expected_salary_min': expectedSalaryMin,
      'expected_salary_max': expectedSalaryMax,
      'preferred_job_types': preferredJobTypes.map((jt) => jt.name).toList(),
      'preferred_work_modes': preferredWorkModes.map((wm) => wm.name).toList(),
      'willing_to_relocate': willingToRelocate,
      'open_to_remote': openToRemote,
      'notice_period': noticePeriod,
    };
  }

  CandidatePreferences copyWith({
    List<String>? preferredLocations,
    List<String>? preferredIndustries,
    double? expectedSalaryMin,
    double? expectedSalaryMax,
    List<JobType>? preferredJobTypes,
    List<WorkMode>? preferredWorkModes,
    bool? willingToRelocate,
    bool? openToRemote,
    int? noticePeriod,
  }) {
    return CandidatePreferences(
      preferredLocations:
          preferredLocations ?? List.from(this.preferredLocations),
      preferredIndustries:
          preferredIndustries ?? List.from(this.preferredIndustries),
      expectedSalaryMin: expectedSalaryMin ?? this.expectedSalaryMin,
      expectedSalaryMax: expectedSalaryMax ?? this.expectedSalaryMax,
      preferredJobTypes: preferredJobTypes ?? List.from(this.preferredJobTypes),
      preferredWorkModes:
          preferredWorkModes ?? List.from(this.preferredWorkModes),
      willingToRelocate: willingToRelocate ?? this.willingToRelocate,
      openToRemote: openToRemote ?? this.openToRemote,
      noticePeriod: noticePeriod ?? this.noticePeriod,
    );
  }
}

// Enums
enum CandidateStatus { active, inactive, blacklisted, graduated }

extension CandidateStatusExtension on CandidateStatus {
  String get name {
    switch (this) {
      case CandidateStatus.active:
        return 'active';
      case CandidateStatus.inactive:
        return 'inactive';
      case CandidateStatus.blacklisted:
        return 'blacklisted';
      case CandidateStatus.graduated:
        return 'graduated';
    }
  }

  String get displayName {
    switch (this) {
      case CandidateStatus.active:
        return 'Active';
      case CandidateStatus.inactive:
        return 'Inactive';
      case CandidateStatus.blacklisted:
        return 'Blacklisted';
      case CandidateStatus.graduated:
        return 'Graduated';
    }
  }
}

enum ProjectType { personal, academic, professional, openSource }

extension ProjectTypeExtension on ProjectType {
  String get name {
    switch (this) {
      case ProjectType.personal:
        return 'personal';
      case ProjectType.academic:
        return 'academic';
      case ProjectType.professional:
        return 'professional';
      case ProjectType.openSource:
        return 'open_source';
    }
  }

  String get displayName {
    switch (this) {
      case ProjectType.personal:
        return 'Personal';
      case ProjectType.academic:
        return 'Academic';
      case ProjectType.professional:
        return 'Professional';
      case ProjectType.openSource:
        return 'Open Source';
    }
  }
}
