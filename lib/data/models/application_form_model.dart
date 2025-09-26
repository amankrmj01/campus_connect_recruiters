class ApplicationFormModel {
  final String id;
  final String title;
  final String description;
  final String jobId;
  final String jobTitle;
  final String companyId;
  final String companyName;
  final String createdBy;
  final List<FormSection> sections;
  final FormSettings settings;
  final FormStatus status;
  final int totalResponses;
  final bool isTemplate;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? publishedAt;

  ApplicationFormModel({
    required this.id,
    required this.title,
    required this.description,
    required this.jobId,
    required this.jobTitle,
    required this.companyId,
    required this.companyName,
    required this.createdBy,
    required this.sections,
    required this.settings,
    required this.status,
    required this.totalResponses,
    required this.isTemplate,
    required this.createdAt,
    this.updatedAt,
    this.publishedAt,
  });

  factory ApplicationFormModel.fromJson(Map<String, dynamic> json) {
    return ApplicationFormModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      jobId: json['job_id'] as String,
      jobTitle: json['job_title'] as String,
      companyId: json['company_id'] as String,
      companyName: json['company_name'] as String,
      createdBy: json['created_by'] as String,
      sections: (json['sections'] as List)
          .map((section) => FormSection.fromJson(section))
          .toList(),
      settings: FormSettings.fromJson(json['settings']),
      status: FormStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => FormStatus.draft,
      ),
      totalResponses: json['total_responses'] as int,
      isTemplate: json['is_template'] as bool,
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
      'job_id': jobId,
      'job_title': jobTitle,
      'company_id': companyId,
      'company_name': companyName,
      'created_by': createdBy,
      'sections': sections.map((s) => s.toJson()).toList(),
      'settings': settings.toJson(),
      'status': status.name,
      'total_responses': totalResponses,
      'is_template': isTemplate,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'published_at': publishedAt?.toIso8601String(),
    };
  }

  ApplicationFormModel copyWith({
    String? id,
    String? title,
    String? description,
    String? jobId,
    String? jobTitle,
    String? companyId,
    String? companyName,
    String? createdBy,
    List<FormSection>? sections,
    FormSettings? settings,
    FormStatus? status,
    int? totalResponses,
    bool? isTemplate,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? publishedAt,
  }) {
    return ApplicationFormModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      jobId: jobId ?? this.jobId,
      jobTitle: jobTitle ?? this.jobTitle,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      createdBy: createdBy ?? this.createdBy,
      sections: sections ?? List.from(this.sections),
      settings: settings ?? this.settings,
      status: status ?? this.status,
      totalResponses: totalResponses ?? this.totalResponses,
      isTemplate: isTemplate ?? this.isTemplate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }

  bool get canEdit {
    return status == FormStatus.draft || status == FormStatus.published;
  }

  bool get isPublished {
    return status == FormStatus.published && publishedAt != null;
  }

  int get totalQuestions {
    return sections.fold(
      0,
      (total, section) => total + section.questions.length,
    );
  }

  @override
  String toString() {
    return 'ApplicationFormModel(id: $id, title: $title, jobTitle: $jobTitle, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApplicationFormModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class FormSection {
  final String id;
  final String title;
  final String description;
  final int order;
  final bool isRequired;
  final List<FormQuestion> questions;
  final SectionSettings settings;

  FormSection({
    required this.id,
    required this.title,
    required this.description,
    required this.order,
    required this.isRequired,
    required this.questions,
    required this.settings,
  });

  factory FormSection.fromJson(Map<String, dynamic> json) {
    return FormSection(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      order: json['order'] as int,
      isRequired: json['is_required'] as bool,
      questions: (json['questions'] as List)
          .map((question) => FormQuestion.fromJson(question))
          .toList(),
      settings: SectionSettings.fromJson(json['settings']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'order': order,
      'is_required': isRequired,
      'questions': questions.map((q) => q.toJson()).toList(),
      'settings': settings.toJson(),
    };
  }

  FormSection copyWith({
    String? id,
    String? title,
    String? description,
    int? order,
    bool? isRequired,
    List<FormQuestion>? questions,
    SectionSettings? settings,
  }) {
    return FormSection(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      isRequired: isRequired ?? this.isRequired,
      questions: questions ?? List.from(this.questions),
      settings: settings ?? this.settings,
    );
  }
}

class FormQuestion {
  final String id;
  final String title;
  final String description;
  final QuestionType type;
  final int order;
  final bool isRequired;
  final QuestionValidation validation;
  final List<QuestionOption> options;
  final QuestionSettings settings;
  final Map<String, dynamic> metadata;

  FormQuestion({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.order,
    required this.isRequired,
    required this.validation,
    required this.options,
    required this.settings,
    required this.metadata,
  });

  factory FormQuestion.fromJson(Map<String, dynamic> json) {
    return FormQuestion(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: QuestionType.values.firstWhere(
        (type) => type.name == json['type'],
        orElse: () => QuestionType.text,
      ),
      order: json['order'] as int,
      isRequired: json['is_required'] as bool,
      validation: QuestionValidation.fromJson(json['validation']),
      options: (json['options'] as List)
          .map((option) => QuestionOption.fromJson(option))
          .toList(),
      settings: QuestionSettings.fromJson(json['settings']),
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'order': order,
      'is_required': isRequired,
      'validation': validation.toJson(),
      'options': options.map((o) => o.toJson()).toList(),
      'settings': settings.toJson(),
      'metadata': metadata,
    };
  }

  FormQuestion copyWith({
    String? id,
    String? title,
    String? description,
    QuestionType? type,
    int? order,
    bool? isRequired,
    QuestionValidation? validation,
    List<QuestionOption>? options,
    QuestionSettings? settings,
    Map<String, dynamic>? metadata,
  }) {
    return FormQuestion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      order: order ?? this.order,
      isRequired: isRequired ?? this.isRequired,
      validation: validation ?? this.validation,
      options: options ?? List.from(this.options),
      settings: settings ?? this.settings,
      metadata: metadata ?? Map.from(this.metadata),
    );
  }

  bool get hasOptions {
    return type == QuestionType.multipleChoice ||
        type == QuestionType.checkbox ||
        type == QuestionType.dropdown;
  }
}

class QuestionOption {
  final String id;
  final String text;
  final String value;
  final int order;
  final bool isOther;
  final Map<String, dynamic> metadata;

  QuestionOption({
    required this.id,
    required this.text,
    required this.value,
    required this.order,
    required this.isOther,
    required this.metadata,
  });

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      id: json['id'] as String,
      text: json['text'] as String,
      value: json['value'] as String,
      order: json['order'] as int,
      isOther: json['is_other'] as bool,
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'value': value,
      'order': order,
      'is_other': isOther,
      'metadata': metadata,
    };
  }

  QuestionOption copyWith({
    String? id,
    String? text,
    String? value,
    int? order,
    bool? isOther,
    Map<String, dynamic>? metadata,
  }) {
    return QuestionOption(
      id: id ?? this.id,
      text: text ?? this.text,
      value: value ?? this.value,
      order: order ?? this.order,
      isOther: isOther ?? this.isOther,
      metadata: metadata ?? Map.from(this.metadata),
    );
  }
}

class QuestionValidation {
  final bool isRequired;
  final int? minLength;
  final int? maxLength;
  final String? pattern;
  final String? errorMessage;
  final List<String> allowedFileTypes;
  final int? maxFileSize; // in bytes
  final double? minValue;
  final double? maxValue;

  QuestionValidation({
    required this.isRequired,
    this.minLength,
    this.maxLength,
    this.pattern,
    this.errorMessage,
    required this.allowedFileTypes,
    this.maxFileSize,
    this.minValue,
    this.maxValue,
  });

  factory QuestionValidation.fromJson(Map<String, dynamic> json) {
    return QuestionValidation(
      isRequired: json['is_required'] as bool,
      minLength: json['min_length'] as int?,
      maxLength: json['max_length'] as int?,
      pattern: json['pattern'] as String?,
      errorMessage: json['error_message'] as String?,
      allowedFileTypes: List<String>.from(json['allowed_file_types'] as List),
      maxFileSize: json['max_file_size'] as int?,
      minValue: json['min_value'] != null
          ? (json['min_value'] as num).toDouble()
          : null,
      maxValue: json['max_value'] != null
          ? (json['max_value'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_required': isRequired,
      'min_length': minLength,
      'max_length': maxLength,
      'pattern': pattern,
      'error_message': errorMessage,
      'allowed_file_types': allowedFileTypes,
      'max_file_size': maxFileSize,
      'min_value': minValue,
      'max_value': maxValue,
    };
  }

  QuestionValidation copyWith({
    bool? isRequired,
    int? minLength,
    int? maxLength,
    String? pattern,
    String? errorMessage,
    List<String>? allowedFileTypes,
    int? maxFileSize,
    double? minValue,
    double? maxValue,
  }) {
    return QuestionValidation(
      isRequired: isRequired ?? this.isRequired,
      minLength: minLength ?? this.minLength,
      maxLength: maxLength ?? this.maxLength,
      pattern: pattern ?? this.pattern,
      errorMessage: errorMessage ?? this.errorMessage,
      allowedFileTypes: allowedFileTypes ?? List.from(this.allowedFileTypes),
      maxFileSize: maxFileSize ?? this.maxFileSize,
      minValue: minValue ?? this.minValue,
      maxValue: maxValue ?? this.maxValue,
    );
  }
}

class QuestionSettings {
  final bool allowMultipleSelection;
  final bool randomizeOptions;
  final String placeholder;
  final bool allowOtherOption;
  final int? maxSelections;
  final Map<String, dynamic> styling;

  QuestionSettings({
    required this.allowMultipleSelection,
    required this.randomizeOptions,
    required this.placeholder,
    required this.allowOtherOption,
    this.maxSelections,
    required this.styling,
  });

  factory QuestionSettings.fromJson(Map<String, dynamic> json) {
    return QuestionSettings(
      allowMultipleSelection: json['allow_multiple_selection'] as bool,
      randomizeOptions: json['randomize_options'] as bool,
      placeholder: json['placeholder'] as String,
      allowOtherOption: json['allow_other_option'] as bool,
      maxSelections: json['max_selections'] as int?,
      styling: Map<String, dynamic>.from(json['styling']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'allow_multiple_selection': allowMultipleSelection,
      'randomize_options': randomizeOptions,
      'placeholder': placeholder,
      'allow_other_option': allowOtherOption,
      'max_selections': maxSelections,
      'styling': styling,
    };
  }

  QuestionSettings copyWith({
    bool? allowMultipleSelection,
    bool? randomizeOptions,
    String? placeholder,
    bool? allowOtherOption,
    int? maxSelections,
    Map<String, dynamic>? styling,
  }) {
    return QuestionSettings(
      allowMultipleSelection:
          allowMultipleSelection ?? this.allowMultipleSelection,
      randomizeOptions: randomizeOptions ?? this.randomizeOptions,
      placeholder: placeholder ?? this.placeholder,
      allowOtherOption: allowOtherOption ?? this.allowOtherOption,
      maxSelections: maxSelections ?? this.maxSelections,
      styling: styling ?? Map.from(this.styling),
    );
  }
}

class SectionSettings {
  final bool canSkip;
  final String skipCondition;
  final bool randomizeQuestions;
  final Map<String, dynamic> styling;

  SectionSettings({
    required this.canSkip,
    required this.skipCondition,
    required this.randomizeQuestions,
    required this.styling,
  });

  factory SectionSettings.fromJson(Map<String, dynamic> json) {
    return SectionSettings(
      canSkip: json['can_skip'] as bool,
      skipCondition: json['skip_condition'] as String,
      randomizeQuestions: json['randomize_questions'] as bool,
      styling: Map<String, dynamic>.from(json['styling']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'can_skip': canSkip,
      'skip_condition': skipCondition,
      'randomize_questions': randomizeQuestions,
      'styling': styling,
    };
  }

  SectionSettings copyWith({
    bool? canSkip,
    String? skipCondition,
    bool? randomizeQuestions,
    Map<String, dynamic>? styling,
  }) {
    return SectionSettings(
      canSkip: canSkip ?? this.canSkip,
      skipCondition: skipCondition ?? this.skipCondition,
      randomizeQuestions: randomizeQuestions ?? this.randomizeQuestions,
      styling: styling ?? Map.from(this.styling),
    );
  }
}

class FormSettings {
  final bool allowMultipleSubmissions;
  final bool showProgressBar;
  final bool randomizeSections;
  final bool allowSaveAndContinue;
  final int timeLimit; // in minutes, 0 means no limit
  final DateTime? submissionDeadline;
  final String confirmationMessage;
  final String redirectUrl;
  final bool collectEmail;
  final bool requireLogin;
  final Map<String, dynamic> branding;

  FormSettings({
    required this.allowMultipleSubmissions,
    required this.showProgressBar,
    required this.randomizeSections,
    required this.allowSaveAndContinue,
    required this.timeLimit,
    this.submissionDeadline,
    required this.confirmationMessage,
    required this.redirectUrl,
    required this.collectEmail,
    required this.requireLogin,
    required this.branding,
  });

  factory FormSettings.fromJson(Map<String, dynamic> json) {
    return FormSettings(
      allowMultipleSubmissions: json['allow_multiple_submissions'] as bool,
      showProgressBar: json['show_progress_bar'] as bool,
      randomizeSections: json['randomize_sections'] as bool,
      allowSaveAndContinue: json['allow_save_and_continue'] as bool,
      timeLimit: json['time_limit'] as int,
      submissionDeadline: json['submission_deadline'] != null
          ? DateTime.parse(json['submission_deadline'] as String)
          : null,
      confirmationMessage: json['confirmation_message'] as String,
      redirectUrl: json['redirect_url'] as String,
      collectEmail: json['collect_email'] as bool,
      requireLogin: json['require_login'] as bool,
      branding: Map<String, dynamic>.from(json['branding']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'allow_multiple_submissions': allowMultipleSubmissions,
      'show_progress_bar': showProgressBar,
      'randomize_sections': randomizeSections,
      'allow_save_and_continue': allowSaveAndContinue,
      'time_limit': timeLimit,
      'submission_deadline': submissionDeadline?.toIso8601String(),
      'confirmation_message': confirmationMessage,
      'redirect_url': redirectUrl,
      'collect_email': collectEmail,
      'require_login': requireLogin,
      'branding': branding,
    };
  }

  FormSettings copyWith({
    bool? allowMultipleSubmissions,
    bool? showProgressBar,
    bool? randomizeSections,
    bool? allowSaveAndContinue,
    int? timeLimit,
    DateTime? submissionDeadline,
    String? confirmationMessage,
    String? redirectUrl,
    bool? collectEmail,
    bool? requireLogin,
    Map<String, dynamic>? branding,
  }) {
    return FormSettings(
      allowMultipleSubmissions:
          allowMultipleSubmissions ?? this.allowMultipleSubmissions,
      showProgressBar: showProgressBar ?? this.showProgressBar,
      randomizeSections: randomizeSections ?? this.randomizeSections,
      allowSaveAndContinue: allowSaveAndContinue ?? this.allowSaveAndContinue,
      timeLimit: timeLimit ?? this.timeLimit,
      submissionDeadline: submissionDeadline ?? this.submissionDeadline,
      confirmationMessage: confirmationMessage ?? this.confirmationMessage,
      redirectUrl: redirectUrl ?? this.redirectUrl,
      collectEmail: collectEmail ?? this.collectEmail,
      requireLogin: requireLogin ?? this.requireLogin,
      branding: branding ?? Map.from(this.branding),
    );
  }
}

class ApplicationFormResponse {
  final String id;
  final String formId;
  final String candidateId;
  final String candidateName;
  final String candidateEmail;
  final Map<String, dynamic> responses;
  final ResponseStatus status;
  final int completionPercentage;
  final DateTime startedAt;
  final DateTime? submittedAt;
  final DateTime? lastModifiedAt;
  final int timeSpent; // in seconds
  final String? ipAddress;
  final String? userAgent;

  ApplicationFormResponse({
    required this.id,
    required this.formId,
    required this.candidateId,
    required this.candidateName,
    required this.candidateEmail,
    required this.responses,
    required this.status,
    required this.completionPercentage,
    required this.startedAt,
    this.submittedAt,
    this.lastModifiedAt,
    required this.timeSpent,
    this.ipAddress,
    this.userAgent,
  });

  factory ApplicationFormResponse.fromJson(Map<String, dynamic> json) {
    return ApplicationFormResponse(
      id: json['id'] as String,
      formId: json['form_id'] as String,
      candidateId: json['candidate_id'] as String,
      candidateName: json['candidate_name'] as String,
      candidateEmail: json['candidate_email'] as String,
      responses: Map<String, dynamic>.from(json['responses']),
      status: ResponseStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => ResponseStatus.draft,
      ),
      completionPercentage: json['completion_percentage'] as int,
      startedAt: DateTime.parse(json['started_at'] as String),
      submittedAt: json['submitted_at'] != null
          ? DateTime.parse(json['submitted_at'] as String)
          : null,
      lastModifiedAt: json['last_modified_at'] != null
          ? DateTime.parse(json['last_modified_at'] as String)
          : null,
      timeSpent: json['time_spent'] as int,
      ipAddress: json['ip_address'] as String?,
      userAgent: json['user_agent'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'form_id': formId,
      'candidate_id': candidateId,
      'candidate_name': candidateName,
      'candidate_email': candidateEmail,
      'responses': responses,
      'status': status.name,
      'completion_percentage': completionPercentage,
      'started_at': startedAt.toIso8601String(),
      'submitted_at': submittedAt?.toIso8601String(),
      'last_modified_at': lastModifiedAt?.toIso8601String(),
      'time_spent': timeSpent,
      'ip_address': ipAddress,
      'user_agent': userAgent,
    };
  }

  ApplicationFormResponse copyWith({
    String? id,
    String? formId,
    String? candidateId,
    String? candidateName,
    String? candidateEmail,
    Map<String, dynamic>? responses,
    ResponseStatus? status,
    int? completionPercentage,
    DateTime? startedAt,
    DateTime? submittedAt,
    DateTime? lastModifiedAt,
    int? timeSpent,
    String? ipAddress,
    String? userAgent,
  }) {
    return ApplicationFormResponse(
      id: id ?? this.id,
      formId: formId ?? this.formId,
      candidateId: candidateId ?? this.candidateId,
      candidateName: candidateName ?? this.candidateName,
      candidateEmail: candidateEmail ?? this.candidateEmail,
      responses: responses ?? Map.from(this.responses),
      status: status ?? this.status,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      startedAt: startedAt ?? this.startedAt,
      submittedAt: submittedAt ?? this.submittedAt,
      lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
      timeSpent: timeSpent ?? this.timeSpent,
      ipAddress: ipAddress ?? this.ipAddress,
      userAgent: userAgent ?? this.userAgent,
    );
  }

  bool get isCompleted {
    return status == ResponseStatus.submitted;
  }

  String get timeSpentFormatted {
    final hours = timeSpent ~/ 3600;
    final minutes = (timeSpent % 3600) ~/ 60;
    final seconds = timeSpent % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
}

// Enums
enum FormStatus { draft, published, paused, closed, archived }

extension FormStatusExtension on FormStatus {
  String get name {
    switch (this) {
      case FormStatus.draft:
        return 'draft';
      case FormStatus.published:
        return 'published';
      case FormStatus.paused:
        return 'paused';
      case FormStatus.closed:
        return 'closed';
      case FormStatus.archived:
        return 'archived';
    }
  }

  String get displayName {
    switch (this) {
      case FormStatus.draft:
        return 'Draft';
      case FormStatus.published:
        return 'Published';
      case FormStatus.paused:
        return 'Paused';
      case FormStatus.closed:
        return 'Closed';
      case FormStatus.archived:
        return 'Archived';
    }
  }
}

enum QuestionType {
  text,
  textarea,
  email,
  phone,
  number,
  date,
  time,
  url,
  multipleChoice,
  checkbox,
  dropdown,
  fileUpload,
  rating,
  slider,
  matrix,
  section,
}

extension QuestionTypeExtension on QuestionType {
  String get name {
    switch (this) {
      case QuestionType.text:
        return 'text';
      case QuestionType.textarea:
        return 'textarea';
      case QuestionType.email:
        return 'email';
      case QuestionType.phone:
        return 'phone';
      case QuestionType.number:
        return 'number';
      case QuestionType.date:
        return 'date';
      case QuestionType.time:
        return 'time';
      case QuestionType.url:
        return 'url';
      case QuestionType.multipleChoice:
        return 'multiple_choice';
      case QuestionType.checkbox:
        return 'checkbox';
      case QuestionType.dropdown:
        return 'dropdown';
      case QuestionType.fileUpload:
        return 'file_upload';
      case QuestionType.rating:
        return 'rating';
      case QuestionType.slider:
        return 'slider';
      case QuestionType.matrix:
        return 'matrix';
      case QuestionType.section:
        return 'section';
    }
  }

  String get displayName {
    switch (this) {
      case QuestionType.text:
        return 'Text';
      case QuestionType.textarea:
        return 'Long Text';
      case QuestionType.email:
        return 'Email';
      case QuestionType.phone:
        return 'Phone';
      case QuestionType.number:
        return 'Number';
      case QuestionType.date:
        return 'Date';
      case QuestionType.time:
        return 'Time';
      case QuestionType.url:
        return 'URL';
      case QuestionType.multipleChoice:
        return 'Multiple Choice';
      case QuestionType.checkbox:
        return 'Checkbox';
      case QuestionType.dropdown:
        return 'Dropdown';
      case QuestionType.fileUpload:
        return 'File Upload';
      case QuestionType.rating:
        return 'Rating';
      case QuestionType.slider:
        return 'Slider';
      case QuestionType.matrix:
        return 'Matrix';
      case QuestionType.section:
        return 'Section Break';
    }
  }
}

enum ResponseStatus { draft, submitted, reviewed, accepted, rejected }

extension ResponseStatusExtension on ResponseStatus {
  String get name {
    switch (this) {
      case ResponseStatus.draft:
        return 'draft';
      case ResponseStatus.submitted:
        return 'submitted';
      case ResponseStatus.reviewed:
        return 'reviewed';
      case ResponseStatus.accepted:
        return 'accepted';
      case ResponseStatus.rejected:
        return 'rejected';
    }
  }

  String get displayName {
    switch (this) {
      case ResponseStatus.draft:
        return 'Draft';
      case ResponseStatus.submitted:
        return 'Submitted';
      case ResponseStatus.reviewed:
        return 'Reviewed';
      case ResponseStatus.accepted:
        return 'Accepted';
      case ResponseStatus.rejected:
        return 'Rejected';
    }
  }
}
