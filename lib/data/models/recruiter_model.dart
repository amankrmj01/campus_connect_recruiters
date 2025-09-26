class RecruiterModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String designation;
  final String department;
  final String companyId;
  final String companyName;
  final bool isPrimary;
  final bool isActive;
  final DateTime? lastLogin;
  final String? profileImageUrl;
  final List<String> permissions;
  final RecruiterPreferences preferences;
  final DateTime createdAt;
  final DateTime? updatedAt;

  RecruiterModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.designation,
    required this.department,
    required this.companyId,
    required this.companyName,
    required this.isPrimary,
    required this.isActive,
    this.lastLogin,
    this.profileImageUrl,
    required this.permissions,
    required this.preferences,
    required this.createdAt,
    this.updatedAt,
  });

  factory RecruiterModel.fromJson(Map<String, dynamic> json) {
    return RecruiterModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      designation: json['designation'] as String,
      department: json['department'] as String,
      companyId: json['company_id'] as String,
      companyName: json['company_name'] as String,
      isPrimary: json['is_primary'] as bool,
      isActive: json['is_active'] as bool,
      lastLogin: json['last_login'] != null
          ? DateTime.parse(json['last_login'] as String)
          : null,
      profileImageUrl: json['profile_image_url'] as String?,
      permissions: List<String>.from(json['permissions'] as List),
      preferences: RecruiterPreferences.fromJson(json['preferences']),
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
      'designation': designation,
      'department': department,
      'company_id': companyId,
      'company_name': companyName,
      'is_primary': isPrimary,
      'is_active': isActive,
      'last_login': lastLogin?.toIso8601String(),
      'profile_image_url': profileImageUrl,
      'permissions': permissions,
      'preferences': preferences.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  RecruiterModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? designation,
    String? department,
    String? companyId,
    String? companyName,
    bool? isPrimary,
    bool? isActive,
    DateTime? lastLogin,
    String? profileImageUrl,
    List<String>? permissions,
    RecruiterPreferences? preferences,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RecruiterModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      designation: designation ?? this.designation,
      department: department ?? this.department,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      isPrimary: isPrimary ?? this.isPrimary,
      isActive: isActive ?? this.isActive,
      lastLogin: lastLogin ?? this.lastLogin,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      permissions: permissions ?? List.from(this.permissions),
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool hasPermission(String permission) {
    return permissions.contains(permission);
  }

  @override
  String toString() {
    return 'RecruiterModel(id: $id, name: $name, email: $email, companyName: $companyName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RecruiterModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class RecruiterPreferences {
  final String theme;
  final String language;
  final bool emailNotifications;
  final bool smsNotifications;
  final bool browserNotifications;
  final Map<String, bool> notificationSettings;
  final String defaultSortBy;
  final int itemsPerPage;

  RecruiterPreferences({
    required this.theme,
    required this.language,
    required this.emailNotifications,
    required this.smsNotifications,
    required this.browserNotifications,
    required this.notificationSettings,
    required this.defaultSortBy,
    required this.itemsPerPage,
  });

  factory RecruiterPreferences.fromJson(Map<String, dynamic> json) {
    return RecruiterPreferences(
      theme: json['theme'] as String,
      language: json['language'] as String,
      emailNotifications: json['email_notifications'] as bool,
      smsNotifications: json['sms_notifications'] as bool,
      browserNotifications: json['browser_notifications'] as bool,
      notificationSettings: Map<String, bool>.from(
        json['notification_settings'],
      ),
      defaultSortBy: json['default_sort_by'] as String,
      itemsPerPage: json['items_per_page'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'theme': theme,
      'language': language,
      'email_notifications': emailNotifications,
      'sms_notifications': smsNotifications,
      'browser_notifications': browserNotifications,
      'notification_settings': notificationSettings,
      'default_sort_by': defaultSortBy,
      'items_per_page': itemsPerPage,
    };
  }

  RecruiterPreferences copyWith({
    String? theme,
    String? language,
    bool? emailNotifications,
    bool? smsNotifications,
    bool? browserNotifications,
    Map<String, bool>? notificationSettings,
    String? defaultSortBy,
    int? itemsPerPage,
  }) {
    return RecruiterPreferences(
      theme: theme ?? this.theme,
      language: language ?? this.language,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      browserNotifications: browserNotifications ?? this.browserNotifications,
      notificationSettings:
          notificationSettings ?? Map.from(this.notificationSettings),
      defaultSortBy: defaultSortBy ?? this.defaultSortBy,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
    );
  }
}

class CompanyProfileModel {
  final String id;
  final String name;
  final String description;
  final String industry;
  final String website;
  final String email;
  final String phone;
  final String address;
  final String logoUrl;
  final CompanySize size;
  final bool isVerified;
  final DateTime? verifiedAt;
  final List<String> services;
  final List<String> technologies;
  final Map<String, dynamic> socialLinks;
  final CompanyStats stats;
  final DateTime createdAt;
  final DateTime? updatedAt;

  CompanyProfileModel({
    required this.id,
    required this.name,
    required this.description,
    required this.industry,
    required this.website,
    required this.email,
    required this.phone,
    required this.address,
    required this.logoUrl,
    required this.size,
    required this.isVerified,
    this.verifiedAt,
    required this.services,
    required this.technologies,
    required this.socialLinks,
    required this.stats,
    required this.createdAt,
    this.updatedAt,
  });

  factory CompanyProfileModel.fromJson(Map<String, dynamic> json) {
    return CompanyProfileModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      industry: json['industry'] as String,
      website: json['website'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      logoUrl: json['logo_url'] as String,
      size: CompanySize.values.firstWhere(
        (size) => size.name == json['size'],
        orElse: () => CompanySize.medium,
      ),
      isVerified: json['is_verified'] as bool,
      verifiedAt: json['verified_at'] != null
          ? DateTime.parse(json['verified_at'] as String)
          : null,
      services: List<String>.from(json['services'] as List),
      technologies: List<String>.from(json['technologies'] as List),
      socialLinks: Map<String, dynamic>.from(json['social_links']),
      stats: CompanyStats.fromJson(json['stats']),
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
      'description': description,
      'industry': industry,
      'website': website,
      'email': email,
      'phone': phone,
      'address': address,
      'logo_url': logoUrl,
      'size': size.name,
      'is_verified': isVerified,
      'verified_at': verifiedAt?.toIso8601String(),
      'services': services,
      'technologies': technologies,
      'social_links': socialLinks,
      'stats': stats.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  CompanyProfileModel copyWith({
    String? id,
    String? name,
    String? description,
    String? industry,
    String? website,
    String? email,
    String? phone,
    String? address,
    String? logoUrl,
    CompanySize? size,
    bool? isVerified,
    DateTime? verifiedAt,
    List<String>? services,
    List<String>? technologies,
    Map<String, dynamic>? socialLinks,
    CompanyStats? stats,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CompanyProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      industry: industry ?? this.industry,
      website: website ?? this.website,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      logoUrl: logoUrl ?? this.logoUrl,
      size: size ?? this.size,
      isVerified: isVerified ?? this.isVerified,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      services: services ?? List.from(this.services),
      technologies: technologies ?? List.from(this.technologies),
      socialLinks: socialLinks ?? Map.from(this.socialLinks),
      stats: stats ?? this.stats,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CompanyStats {
  final int totalJobs;
  final int activeJobs;
  final int totalApplications;
  final int totalHires;
  final int totalInterviews;
  final double averageResponseTime;
  final double hireRate;

  CompanyStats({
    required this.totalJobs,
    required this.activeJobs,
    required this.totalApplications,
    required this.totalHires,
    required this.totalInterviews,
    required this.averageResponseTime,
    required this.hireRate,
  });

  factory CompanyStats.fromJson(Map<String, dynamic> json) {
    return CompanyStats(
      totalJobs: json['total_jobs'] as int,
      activeJobs: json['active_jobs'] as int,
      totalApplications: json['total_applications'] as int,
      totalHires: json['total_hires'] as int,
      totalInterviews: json['total_interviews'] as int,
      averageResponseTime: (json['average_response_time'] as num).toDouble(),
      hireRate: (json['hire_rate'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_jobs': totalJobs,
      'active_jobs': activeJobs,
      'total_applications': totalApplications,
      'total_hires': totalHires,
      'total_interviews': totalInterviews,
      'average_response_time': averageResponseTime,
      'hire_rate': hireRate,
    };
  }

  CompanyStats copyWith({
    int? totalJobs,
    int? activeJobs,
    int? totalApplications,
    int? totalHires,
    int? totalInterviews,
    double? averageResponseTime,
    double? hireRate,
  }) {
    return CompanyStats(
      totalJobs: totalJobs ?? this.totalJobs,
      activeJobs: activeJobs ?? this.activeJobs,
      totalApplications: totalApplications ?? this.totalApplications,
      totalHires: totalHires ?? this.totalHires,
      totalInterviews: totalInterviews ?? this.totalInterviews,
      averageResponseTime: averageResponseTime ?? this.averageResponseTime,
      hireRate: hireRate ?? this.hireRate,
    );
  }
}

enum CompanySize { startup, small, medium, large, enterprise }

extension CompanySizeExtension on CompanySize {
  String get name {
    switch (this) {
      case CompanySize.startup:
        return 'startup';
      case CompanySize.small:
        return 'small';
      case CompanySize.medium:
        return 'medium';
      case CompanySize.large:
        return 'large';
      case CompanySize.enterprise:
        return 'enterprise';
    }
  }

  String get displayName {
    switch (this) {
      case CompanySize.startup:
        return 'Startup (1-50)';
      case CompanySize.small:
        return 'Small (51-200)';
      case CompanySize.medium:
        return 'Medium (201-1000)';
      case CompanySize.large:
        return 'Large (1001-5000)';
      case CompanySize.enterprise:
        return 'Enterprise (5000+)';
    }
  }
}

// Predefined permissions for recruiters
class RecruiterPermissions {
  static const String postJobs = 'post_jobs';
  static const String editJobs = 'edit_jobs';
  static const String viewApplications = 'view_applications';
  static const String shortlistCandidates = 'shortlist_candidates';
  static const String scheduleInterviews = 'schedule_interviews';
  static const String sendMessages = 'send_messages';
  static const String viewAnalytics = 'view_analytics';
  static const String manageTeam = 'manage_team';
  static const String exportData = 'export_data';
  static const String createForms = 'create_forms';

  static List<String> getDefaultPermissions(bool isPrimary) {
    if (isPrimary) {
      return [
        postJobs,
        editJobs,
        viewApplications,
        shortlistCandidates,
        scheduleInterviews,
        sendMessages,
        viewAnalytics,
        manageTeam,
        exportData,
        createForms,
      ];
    } else {
      return [
        viewApplications,
        shortlistCandidates,
        scheduleInterviews,
        sendMessages,
      ];
    }
  }
}
