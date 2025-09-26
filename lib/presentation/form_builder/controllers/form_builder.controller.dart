import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormBuilderController extends GetxController {
  // Reactive variables
  var isLoading = false.obs;
  var selectedTab = 0.obs;
  var currentFormId = ''.obs;
  var isPreviewMode = false.obs;
  var isDragging = false.obs;

  // Form Data
  var formTitle = ''.obs;
  var formDescription = ''.obs;
  var selectedJobId = ''.obs;
  var formSections = <FormSectionData>[].obs;
  var formSettings = FormSettingsData().obs;

  // Form Builder State
  var selectedSectionIndex = (-1).obs;
  var selectedQuestionIndex = (-1).obs;
  var draggedQuestionIndex = (-1).obs;

  // Available Templates
  var formTemplates = <FormTemplate>[].obs;
  var savedForms = <SavedForm>[].obs;
  var publishedForms = <PublishedForm>[].obs;

  // Form Controllers
  final formTitleController = TextEditingController();
  final formDescriptionController = TextEditingController();
  final questionTitleController = TextEditingController();
  final questionDescriptionController = TextEditingController();
  final optionController = TextEditingController();

  // Available Question Types
  final questionTypes = [
    {'type': 'text', 'label': 'Short Text', 'icon': Icons.text_fields_outlined},
    {'type': 'textarea', 'label': 'Long Text', 'icon': Icons.notes_outlined},
    {'type': 'email', 'label': 'Email', 'icon': Icons.email_outlined},
    {'type': 'phone', 'label': 'Phone', 'icon': Icons.phone_outlined},
    {'type': 'number', 'label': 'Number', 'icon': Icons.numbers_outlined},
    {'type': 'date', 'label': 'Date', 'icon': Icons.calendar_today_outlined},
    {
      'type': 'multiple_choice',
      'label': 'Multiple Choice',
      'icon': Icons.radio_button_checked_outlined,
    },
    {
      'type': 'checkbox',
      'label': 'Checkboxes',
      'icon': Icons.check_box_outlined,
    },
    {
      'type': 'dropdown',
      'label': 'Dropdown',
      'icon': Icons.arrow_drop_down_outlined,
    },
    {
      'type': 'file_upload',
      'label': 'File Upload',
      'icon': Icons.upload_file_outlined,
    },
    {'type': 'rating', 'label': 'Rating', 'icon': Icons.star_outline},
    {
      'type': 'section',
      'label': 'Section Break',
      'icon': Icons.horizontal_rule_outlined,
    },
  ];

  @override
  void onInit() {
    super.onInit();
    loadFormBuilderData();
    _initializeNewForm();
  }

  @override
  void onClose() {
    formTitleController.dispose();
    formDescriptionController.dispose();
    questionTitleController.dispose();
    questionDescriptionController.dispose();
    optionController.dispose();
    super.onClose();
  }

  void loadFormBuilderData() {
    isLoading.value = true;

    Future.delayed(Duration(seconds: 1), () {
      _loadMockData();
      isLoading.value = false;
    });
  }

  void _loadMockData() {
    // Form Templates
    formTemplates.value = [
      FormTemplate(
        id: 'template_1',
        name: 'Software Engineer Application',
        description:
            'Complete application form for software engineering positions',
        category: 'Engineering',
        sectionsCount: 4,
        questionsCount: 15,
        thumbnail: 'assets/templates/software_engineer.png',
      ),
      FormTemplate(
        id: 'template_2',
        name: 'Internship Application',
        description: 'Simplified form for internship applications',
        category: 'Internship',
        sectionsCount: 3,
        questionsCount: 10,
        thumbnail: 'assets/templates/internship.png',
      ),
      FormTemplate(
        id: 'template_3',
        name: 'Graduate Trainee Program',
        description: 'Comprehensive form for graduate trainee positions',
        category: 'Graduate',
        sectionsCount: 5,
        questionsCount: 20,
        thumbnail: 'assets/templates/graduate.png',
      ),
      FormTemplate(
        id: 'template_4',
        name: 'Basic Application Form',
        description: 'Simple application form with essential fields',
        category: 'General',
        sectionsCount: 2,
        questionsCount: 8,
        thumbnail: 'assets/templates/basic.png',
      ),
    ];

    // Saved Forms
    savedForms.value = [
      SavedForm(
        id: 'form_1',
        title: 'Senior Developer Application',
        jobTitle: 'Senior Software Developer',
        status: 'Draft',
        lastModified: DateTime.now().subtract(Duration(hours: 2)),
        questionsCount: 12,
        responsesCount: 0,
      ),
      SavedForm(
        id: 'form_2',
        title: 'Product Manager Application',
        jobTitle: 'Product Manager',
        status: 'Published',
        lastModified: DateTime.now().subtract(Duration(days: 1)),
        questionsCount: 18,
        responsesCount: 45,
      ),
      SavedForm(
        id: 'form_3',
        title: 'Data Scientist Application',
        jobTitle: 'Data Scientist',
        status: 'Draft',
        lastModified: DateTime.now().subtract(Duration(days: 3)),
        questionsCount: 15,
        responsesCount: 0,
      ),
    ];

    // Published Forms
    publishedForms.value = [
      PublishedForm(
        id: 'pub_1',
        title: 'Frontend Developer Application',
        jobTitle: 'Frontend Developer',
        publishedDate: DateTime.now().subtract(Duration(days: 5)),
        responses: 67,
        views: 234,
        completionRate: 78.5,
        avgCompletionTime: 8.5,
      ),
      PublishedForm(
        id: 'pub_2',
        title: 'UX Designer Application',
        jobTitle: 'UX Designer',
        publishedDate: DateTime.now().subtract(Duration(days: 12)),
        responses: 89,
        views: 456,
        completionRate: 82.1,
        avgCompletionTime: 12.3,
      ),
    ];
  }

  void _initializeNewForm() {
    formTitle.value = '';
    formDescription.value = '';
    formSections.clear();

    // Add default section
    addSection();
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }

  void setFormTitle(String title) {
    formTitle.value = title;
    formTitleController.text = title;
  }

  void setFormDescription(String description) {
    formDescription.value = description;
    formDescriptionController.text = description;
  }

  void addSection() {
    final section = FormSectionData(
      id: 'section_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Section ${formSections.length + 1}',
      description: '',
      order: formSections.length,
      questions: [],
    );
    formSections.add(section);
    selectedSectionIndex.value = formSections.length - 1;
  }

  void updateSection(int index, String title, String description) {
    if (index >= 0 && index < formSections.length) {
      formSections[index] = formSections[index].copyWith(
        title: title,
        description: description,
      );
      formSections.refresh();
    }
  }

  void removeSection(int index) {
    if (index >= 0 && index < formSections.length && formSections.length > 1) {
      formSections.removeAt(index);
      if (selectedSectionIndex.value >= formSections.length) {
        selectedSectionIndex.value = formSections.length - 1;
      }
    }
  }

  void selectSection(int index) {
    selectedSectionIndex.value = index;
    selectedQuestionIndex.value = -1;
  }

  void addQuestion(String questionType) {
    if (selectedSectionIndex.value < 0) {
      addSection();
    }

    final sectionIndex = selectedSectionIndex.value;
    final section = formSections[sectionIndex];

    final question = FormQuestionData(
      id: 'question_${DateTime.now().millisecondsSinceEpoch}',
      type: questionType,
      title: _getDefaultQuestionTitle(questionType),
      description: '',
      isRequired: false,
      order: section.questions.length,
      options: _getDefaultOptions(questionType),
      validation: FormValidationData(),
      settings: QuestionSettingsData(),
    );

    section.questions.add(question);
    formSections[sectionIndex] = section;
    formSections.refresh();

    selectedQuestionIndex.value = section.questions.length - 1;
  }

  void updateQuestion(
    int sectionIndex,
    int questionIndex,
    FormQuestionData question,
  ) {
    if (sectionIndex >= 0 && sectionIndex < formSections.length) {
      final section = formSections[sectionIndex];
      if (questionIndex >= 0 && questionIndex < section.questions.length) {
        section.questions[questionIndex] = question;
        formSections[sectionIndex] = section;
        formSections.refresh();
      }
    }
  }

  void removeQuestion(int sectionIndex, int questionIndex) {
    if (sectionIndex >= 0 && sectionIndex < formSections.length) {
      final section = formSections[sectionIndex];
      if (questionIndex >= 0 && questionIndex < section.questions.length) {
        section.questions.removeAt(questionIndex);
        formSections[sectionIndex] = section;
        formSections.refresh();

        if (selectedQuestionIndex.value >= section.questions.length) {
          selectedQuestionIndex.value = section.questions.length - 1;
        }
      }
    }
  }

  void selectQuestion(int sectionIndex, int questionIndex) {
    selectedSectionIndex.value = sectionIndex;
    selectedQuestionIndex.value = questionIndex;
  }

  void duplicateQuestion(int sectionIndex, int questionIndex) {
    if (sectionIndex >= 0 && sectionIndex < formSections.length) {
      final section = formSections[sectionIndex];
      if (questionIndex >= 0 && questionIndex < section.questions.length) {
        final originalQuestion = section.questions[questionIndex];
        final duplicatedQuestion = originalQuestion.copyWith(
          id: 'question_${DateTime.now().millisecondsSinceEpoch}',
          title: '${originalQuestion.title} (Copy)',
          order: section.questions.length,
        );

        section.questions.add(duplicatedQuestion);
        formSections[sectionIndex] = section;
        formSections.refresh();
      }
    }
  }

  void moveQuestion(
    int fromSection,
    int fromIndex,
    int toSection,
    int toIndex,
  ) {
    if (fromSection >= 0 &&
        fromSection < formSections.length &&
        toSection >= 0 &&
        toSection < formSections.length) {
      final fromSectionData = formSections[fromSection];
      final toSectionData = formSections[toSection];

      if (fromIndex >= 0 && fromIndex < fromSectionData.questions.length) {
        final question = fromSectionData.questions.removeAt(fromIndex);

        final insertIndex = toIndex.clamp(0, toSectionData.questions.length);
        toSectionData.questions.insert(insertIndex, question);

        formSections[fromSection] = fromSectionData;
        formSections[toSection] = toSectionData;
        formSections.refresh();
      }
    }
  }

  void togglePreviewMode() {
    isPreviewMode.value = !isPreviewMode.value;
  }

  Future<void> saveForm() async {
    if (formTitle.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a form title',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      final savedForm = SavedForm(
        id: currentFormId.value.isEmpty
            ? 'form_${DateTime.now().millisecondsSinceEpoch}'
            : currentFormId.value,
        title: formTitle.value,
        jobTitle: selectedJobId.value,
        status: 'Draft',
        lastModified: DateTime.now(),
        questionsCount: _getTotalQuestions(),
        responsesCount: 0,
      );

      // Add or update in saved forms
      final existingIndex = savedForms.indexWhere((f) => f.id == savedForm.id);
      if (existingIndex >= 0) {
        savedForms[existingIndex] = savedForm;
      } else {
        savedForms.add(savedForm);
      }

      currentFormId.value = savedForm.id;

      Get.snackbar(
        'Success',
        'Form saved successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save form. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> publishForm() async {
    if (formTitle.value.isEmpty || formSections.isEmpty) {
      Get.snackbar(
        'Error',
        'Please complete the form before publishing',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Get.dialog(
      AlertDialog(
        title: Text('Publish Form'),
        content: Text(
          'Are you sure you want to publish this form? Once published, candidates will be able to access and submit applications.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Get.back();

              isLoading.value = true;

              try {
                await Future.delayed(Duration(seconds: 2));

                final publishedForm = PublishedForm(
                  id: 'pub_${DateTime.now().millisecondsSinceEpoch}',
                  title: formTitle.value,
                  jobTitle: selectedJobId.value,
                  publishedDate: DateTime.now(),
                  responses: 0,
                  views: 0,
                  completionRate: 0.0,
                  avgCompletionTime: 0.0,
                );

                publishedForms.add(publishedForm);

                // Update saved form status
                final savedFormIndex = savedForms.indexWhere(
                  (f) => f.id == currentFormId.value,
                );
                if (savedFormIndex >= 0) {
                  savedForms[savedFormIndex] = savedForms[savedFormIndex]
                      .copyWith(status: 'Published');
                }

                Get.snackbar(
                  'Success',
                  'Form published successfully',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } catch (e) {
                Get.snackbar(
                  'Error',
                  'Failed to publish form. Please try again.',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } finally {
                isLoading.value = false;
              }
            },
            child: Text('Publish'),
          ),
        ],
      ),
    );
  }

  void loadTemplate(String templateId) {
    final template = formTemplates.firstWhereOrNull((t) => t.id == templateId);
    if (template != null) {
      // Load template data (mock implementation)
      formTitle.value = template.name;
      formDescription.value = template.description;
      formTitleController.text = template.name;
      formDescriptionController.text = template.description;

      // Create mock sections based on template
      formSections.clear();
      for (int i = 0; i < template.sectionsCount; i++) {
        addSection();
        updateSection(i, 'Section ${i + 1}', 'Template section ${i + 1}');

        // Add some mock questions
        for (
          int j = 0;
          j < (template.questionsCount / template.sectionsCount).ceil();
          j++
        ) {
          final questionTypes = [
            'text',
            'email',
            'textarea',
            'multiple_choice',
          ];
          addQuestion(questionTypes[j % questionTypes.length]);
        }
      }

      Get.snackbar(
        'Template Loaded',
        'Template "${template.name}" loaded successfully',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    }
  }

  void loadSavedForm(String formId) {
    final savedForm = savedForms.firstWhereOrNull((f) => f.id == formId);
    if (savedForm != null) {
      currentFormId.value = formId;
      formTitle.value = savedForm.title;
      formTitleController.text = savedForm.title;

      // Mock load form data
      Get.snackbar(
        'Form Loaded',
        'Form "${savedForm.title}" loaded successfully',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    }
  }

  void deleteForm(String formId) {
    Get.dialog(
      AlertDialog(
        title: Text('Delete Form'),
        content: Text(
          'Are you sure you want to delete this form? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              savedForms.removeWhere((f) => f.id == formId);
              publishedForms.removeWhere((f) => f.id == formId);

              Get.snackbar(
                'Form Deleted',
                'Form deleted successfully',
                backgroundColor: Colors.orange,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void createNewForm() {
    _initializeNewForm();
    selectedTab.value = 1; // Switch to builder tab
  }

  String _getDefaultQuestionTitle(String type) {
    switch (type) {
      case 'text':
        return 'Short Text Question';
      case 'textarea':
        return 'Long Text Question';
      case 'email':
        return 'Email Address';
      case 'phone':
        return 'Phone Number';
      case 'number':
        return 'Number Question';
      case 'date':
        return 'Date Question';
      case 'multiple_choice':
        return 'Multiple Choice Question';
      case 'checkbox':
        return 'Checkbox Question';
      case 'dropdown':
        return 'Dropdown Question';
      case 'file_upload':
        return 'File Upload';
      case 'rating':
        return 'Rating Question';
      case 'section':
        return 'Section Break';
      default:
        return 'New Question';
    }
  }

  List<String> _getDefaultOptions(String type) {
    switch (type) {
      case 'multiple_choice':
      case 'checkbox':
      case 'dropdown':
        return ['Option 1', 'Option 2', 'Option 3'];
      default:
        return [];
    }
  }

  int _getTotalQuestions() {
    return formSections.fold(
      0,
      (total, section) => total + section.questions.length,
    );
  }
}

// Data Models
class FormSectionData {
  final String id;
  final String title;
  final String description;
  final int order;
  final List<FormQuestionData> questions;

  FormSectionData({
    required this.id,
    required this.title,
    required this.description,
    required this.order,
    required this.questions,
  });

  FormSectionData copyWith({
    String? id,
    String? title,
    String? description,
    int? order,
    List<FormQuestionData>? questions,
  }) {
    return FormSectionData(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      questions: questions ?? this.questions,
    );
  }
}

class FormQuestionData {
  final String id;
  final String type;
  final String title;
  final String description;
  final bool isRequired;
  final int order;
  final List<String> options;
  final FormValidationData validation;
  final QuestionSettingsData settings;

  FormQuestionData({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.isRequired,
    required this.order,
    required this.options,
    required this.validation,
    required this.settings,
  });

  FormQuestionData copyWith({
    String? id,
    String? type,
    String? title,
    String? description,
    bool? isRequired,
    int? order,
    List<String>? options,
    FormValidationData? validation,
    QuestionSettingsData? settings,
  }) {
    return FormQuestionData(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      isRequired: isRequired ?? this.isRequired,
      order: order ?? this.order,
      options: options ?? List.from(this.options),
      validation: validation ?? this.validation,
      settings: settings ?? this.settings,
    );
  }
}

class FormValidationData {
  final int? minLength;
  final int? maxLength;
  final String? pattern;
  final String? errorMessage;
  final List<String> allowedFileTypes;
  final int? maxFileSize;

  FormValidationData({
    this.minLength,
    this.maxLength,
    this.pattern,
    this.errorMessage,
    this.allowedFileTypes = const [],
    this.maxFileSize,
  });
}

class QuestionSettingsData {
  final bool allowMultipleSelection;
  final bool randomizeOptions;
  final String placeholder;
  final bool allowOtherOption;

  QuestionSettingsData({
    this.allowMultipleSelection = false,
    this.randomizeOptions = false,
    this.placeholder = '',
    this.allowOtherOption = false,
  });
}

class FormSettingsData {
  final bool allowMultipleSubmissions;
  final bool showProgressBar;
  final bool allowSaveAndContinue;
  final int timeLimit;
  final String confirmationMessage;
  final String redirectUrl;

  FormSettingsData({
    this.allowMultipleSubmissions = false,
    this.showProgressBar = true,
    this.allowSaveAndContinue = true,
    this.timeLimit = 0,
    this.confirmationMessage = 'Thank you for your submission!',
    this.redirectUrl = '',
  });
}

class FormTemplate {
  final String id;
  final String name;
  final String description;
  final String category;
  final int sectionsCount;
  final int questionsCount;
  final String thumbnail;

  FormTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.sectionsCount,
    required this.questionsCount,
    required this.thumbnail,
  });
}

class SavedForm {
  final String id;
  final String title;
  final String jobTitle;
  final String status;
  final DateTime lastModified;
  final int questionsCount;
  final int responsesCount;

  SavedForm({
    required this.id,
    required this.title,
    required this.jobTitle,
    required this.status,
    required this.lastModified,
    required this.questionsCount,
    required this.responsesCount,
  });

  SavedForm copyWith({
    String? id,
    String? title,
    String? jobTitle,
    String? status,
    DateTime? lastModified,
    int? questionsCount,
    int? responsesCount,
  }) {
    return SavedForm(
      id: id ?? this.id,
      title: title ?? this.title,
      jobTitle: jobTitle ?? this.jobTitle,
      status: status ?? this.status,
      lastModified: lastModified ?? this.lastModified,
      questionsCount: questionsCount ?? this.questionsCount,
      responsesCount: responsesCount ?? this.responsesCount,
    );
  }
}

class PublishedForm {
  final String id;
  final String title;
  final String jobTitle;
  final DateTime publishedDate;
  final int responses;
  final int views;
  final double completionRate;
  final double avgCompletionTime;

  PublishedForm({
    required this.id,
    required this.title,
    required this.jobTitle,
    required this.publishedDate,
    required this.responses,
    required this.views,
    required this.completionRate,
    required this.avgCompletionTime,
  });
}
