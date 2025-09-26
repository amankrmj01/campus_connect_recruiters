import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CandidateManagementController extends GetxController {
  // Reactive variables
  var isLoading = false.obs;
  var selectedTabIndex = 0.obs;
  var selectedCandidates = <String>[].obs;
  var searchQuery = ''.obs;
  var selectedFilters = <String, dynamic>{}.obs;
  var isSelectionMode = false.obs;

  // Current candidate details
  var selectedCandidate = Rxn<CandidateModel>();
  var candidateApplications = <ApplicationModel>[].obs;
  var candidateInteractions = <InteractionModel>[].obs;

  // Lists
  var allCandidates = <CandidateModel>[].obs;
  var filteredCandidates = <CandidateModel>[].obs;
  var shortlistedCandidates = <CandidateModel>[].obs;
  var rejectedCandidates = <CandidateModel>[].obs;
  var watchlistedCandidates = <CandidateModel>[].obs;

  // Form controllers
  final searchController = TextEditingController();
  final messageController = TextEditingController();
  final notesController = TextEditingController();

  // Filter options
  final departments = [
    'All',
    'Computer Science',
    'Information Technology',
    'Electronics',
    'Mechanical',
    'Civil',
  ];
  final colleges = [
    'All',
    'VIT Vellore',
    'VIT Chennai',
    'VIT Bhopal',
    'VIT AP',
  ];
  final graduationYears = ['All', '2024', '2025', '2026', '2027'];
  final skillCategories = [
    'Programming',
    'Web Development',
    'Data Science',
    'Mobile Development',
    'Cloud Computing',
  ];

  var selectedDepartment = 'All'.obs;
  var selectedCollege = 'All'.obs;
  var selectedGraduationYear = 'All'.obs;
  var selectedSkills = <String>[].obs;
  var minCGPA = 0.0.obs;
  var maxCGPA = 10.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadCandidatesData();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void onClose() {
    searchController.dispose();
    messageController.dispose();
    notesController.dispose();
    super.onClose();
  }

  void _onSearchChanged() {
    searchQuery.value = searchController.text;
    filterCandidates();
  }

  void loadCandidatesData() {
    isLoading.value = true;

    // Simulate API call
    Future.delayed(Duration(seconds: 1), () {
      // Mock candidate data
      allCandidates.value = [
        CandidateModel(
          id: '1',
          name: 'Arjun Kumar',
          email: 'arjun.kumar@student.vit.ac.in',
          phone: '+91 9876543210',
          college: 'VIT Vellore',
          department: 'Computer Science',
          graduationYear: 2025,
          cgpa: 8.5,
          skills: ['Java', 'Spring Boot', 'React', 'MySQL', 'AWS'],
          profilePicture: 'https://example.com/profile1.jpg',
          location: 'Chennai, Tamil Nadu',
          experience: '6 months internship',
          status: CandidateStatus.active,
          isShortlisted: true,
          isWatchlisted: true,
          appliedJobs: 3,
          responseRate: 92.5,
          lastActive: DateTime.now().subtract(Duration(hours: 2)),
        ),

        CandidateModel(
          id: '2',
          name: 'Priya Sharma',
          email: 'priya.sharma@student.vit.ac.in',
          phone: '+91 9876543220',
          college: 'VIT Chennai',
          department: 'Information Technology',
          graduationYear: 2025,
          cgpa: 9.2,
          skills: ['Python', 'Django', 'React', 'PostgreSQL', 'Docker'],
          profilePicture: 'https://example.com/profile2.jpg',
          location: 'Mumbai, Maharashtra',
          experience: '3 months internship',
          status: CandidateStatus.active,
          isShortlisted: true,
          isWatchlisted: false,
          appliedJobs: 5,
          responseRate: 88.0,
          lastActive: DateTime.now().subtract(Duration(minutes: 30)),
        ),

        CandidateModel(
          id: '3',
          name: 'Rajesh Patel',
          email: 'rajesh.patel@student.vit.ac.in',
          phone: '+91 9876543230',
          college: 'VIT Bhopal',
          department: 'Computer Science',
          graduationYear: 2025,
          cgpa: 7.8,
          skills: ['JavaScript', 'Node.js', 'React', 'MongoDB'],
          profilePicture: 'https://example.com/profile3.jpg',
          location: 'Ahmedabad, Gujarat',
          experience: 'Fresher',
          status: CandidateStatus.active,
          isShortlisted: false,
          isWatchlisted: false,
          appliedJobs: 2,
          responseRate: 75.0,
          lastActive: DateTime.now().subtract(Duration(hours: 6)),
        ),

        CandidateModel(
          id: '4',
          name: 'Sneha Reddy',
          email: 'sneha.reddy@student.vit.ac.in',
          phone: '+91 9876543240',
          college: 'VIT Vellore',
          department: 'Information Technology',
          graduationYear: 2026,
          cgpa: 8.9,
          skills: ['React', 'TypeScript', 'CSS', 'Figma', 'UI/UX'],
          profilePicture: 'https://example.com/profile4.jpg',
          location: 'Hyderabad, Telangana',
          experience: 'Design Intern',
          status: CandidateStatus.active,
          isShortlisted: true,
          isWatchlisted: true,
          appliedJobs: 4,
          responseRate: 95.0,
          lastActive: DateTime.now().subtract(Duration(hours: 1)),
        ),

        CandidateModel(
          id: '5',
          name: 'Amit Singh',
          email: 'amit.singh@student.vit.ac.in',
          phone: '+91 9876543250',
          college: 'VIT Chennai',
          department: 'Electronics',
          graduationYear: 2026,
          cgpa: 7.5,
          skills: ['C++', 'Python', 'Machine Learning', 'IoT'],
          profilePicture: 'https://example.com/profile5.jpg',
          location: 'Delhi, India',
          experience: 'Fresher',
          status: CandidateStatus.inactive,
          isShortlisted: false,
          isWatchlisted: false,
          appliedJobs: 1,
          responseRate: 60.0,
          lastActive: DateTime.now().subtract(Duration(days: 2)),
        ),
      ];

      updateFilteredLists();
      isLoading.value = false;
    });
  }

  void updateFilteredLists() {
    filteredCandidates.value = List.from(allCandidates);
    shortlistedCandidates.value = allCandidates
        .where((c) => c.isShortlisted)
        .toList();
    rejectedCandidates.value = allCandidates
        .where((c) => c.status == CandidateStatus.rejected)
        .toList();
    watchlistedCandidates.value = allCandidates
        .where((c) => c.isWatchlisted)
        .toList();
    filterCandidates();
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
    clearSelection();
  }

  void filterCandidates() {
    var candidates = List<CandidateModel>.from(allCandidates);

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      candidates = candidates
          .where(
            (candidate) =>
                candidate.name.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ||
                candidate.email.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ||
                candidate.college.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ||
                candidate.department.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ||
                candidate.skills.any(
                  (skill) => skill.toLowerCase().contains(
                    searchQuery.value.toLowerCase(),
                  ),
                ),
          )
          .toList();
    }

    // Apply department filter
    if (selectedDepartment.value != 'All') {
      candidates = candidates
          .where((c) => c.department == selectedDepartment.value)
          .toList();
    }

    // Apply college filter
    if (selectedCollege.value != 'All') {
      candidates = candidates
          .where((c) => c.college == selectedCollege.value)
          .toList();
    }

    // Apply graduation year filter
    if (selectedGraduationYear.value != 'All') {
      candidates = candidates
          .where(
            (c) => c.graduationYear.toString() == selectedGraduationYear.value,
          )
          .toList();
    }

    // Apply CGPA range filter
    candidates = candidates
        .where((c) => c.cgpa >= minCGPA.value && c.cgpa <= maxCGPA.value)
        .toList();

    // Apply skills filter
    if (selectedSkills.isNotEmpty) {
      candidates = candidates
          .where(
            (candidate) => selectedSkills.any(
              (skill) => candidate.skills.any(
                (candidateSkill) =>
                    candidateSkill.toLowerCase().contains(skill.toLowerCase()),
              ),
            ),
          )
          .toList();
    }

    // Apply tab-specific filters
    switch (selectedTabIndex.value) {
      case 1:
        candidates = candidates.where((c) => c.isShortlisted).toList();
        break;
      case 2:
        candidates = candidates
            .where((c) => c.status == CandidateStatus.rejected)
            .toList();
        break;
      case 3:
        candidates = candidates.where((c) => c.isWatchlisted).toList();
        break;
    }

    filteredCandidates.value = candidates;
  }

  void selectCandidate(String candidateId) {
    if (selectedCandidates.contains(candidateId)) {
      selectedCandidates.remove(candidateId);
    } else {
      selectedCandidates.add(candidateId);
    }

    isSelectionMode.value = selectedCandidates.isNotEmpty;
  }

  void selectAllCandidates() {
    if (selectedCandidates.length == filteredCandidates.length) {
      clearSelection();
    } else {
      selectedCandidates.value = filteredCandidates.map((c) => c.id).toList();
      isSelectionMode.value = true;
    }
  }

  void clearSelection() {
    selectedCandidates.clear();
    isSelectionMode.value = false;
  }

  void viewCandidateProfile(CandidateModel candidate) {
    selectedCandidate.value = candidate;
    loadCandidateDetails(candidate.id);
  }

  void loadCandidateDetails(String candidateId) {
    // Mock candidate applications
    candidateApplications.value = [
      ApplicationModel(
        id: '1',
        jobTitle: 'Software Development Engineer',
        company: 'TechCorp Solutions',
        status: 'Shortlisted',
        appliedDate: DateTime.now().subtract(Duration(days: 5)),
        currentRound: 'Technical Interview',
      ),
      ApplicationModel(
        id: '2',
        jobTitle: 'Frontend Developer Intern',
        company: 'InnovateTech',
        status: 'Under Review',
        appliedDate: DateTime.now().subtract(Duration(days: 12)),
        currentRound: 'Application Review',
      ),
    ];

    // Mock interactions
    candidateInteractions.value = [
      InteractionModel(
        id: '1',
        type: 'Email',
        message:
            'Thank you for your application. We will review and get back to you.',
        timestamp: DateTime.now().subtract(Duration(days: 3)),
        recruiter: 'John Recruiter',
      ),
      InteractionModel(
        id: '2',
        type: 'Note',
        message: 'Strong technical background, good communication skills.',
        timestamp: DateTime.now().subtract(Duration(days: 7)),
        recruiter: 'Sarah Manager',
      ),
    ];
  }

  Future<void> shortlistCandidates() async {
    if (selectedCandidates.isEmpty) return;

    isLoading.value = true;

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 1));

      for (String candidateId in selectedCandidates) {
        final index = allCandidates.indexWhere((c) => c.id == candidateId);
        if (index != -1) {
          allCandidates[index] = allCandidates[index].copyWith(
            isShortlisted: true,
          );
        }
      }

      updateFilteredLists();
      clearSelection();

      Get.snackbar(
        'Success',
        '${selectedCandidates.length} candidate(s) shortlisted successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to shortlist candidates',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> rejectCandidates() async {
    if (selectedCandidates.isEmpty) return;

    Get.dialog(
      AlertDialog(
        title: Text('Reject Candidates'),
        content: Text(
          'Are you sure you want to reject ${selectedCandidates.length} candidate(s)?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Get.back();

              isLoading.value = true;

              try {
                await Future.delayed(Duration(seconds: 1));

                for (String candidateId in selectedCandidates) {
                  final index = allCandidates.indexWhere(
                    (c) => c.id == candidateId,
                  );
                  if (index != -1) {
                    allCandidates[index] = allCandidates[index].copyWith(
                      status: CandidateStatus.rejected,
                    );
                  }
                }

                updateFilteredLists();
                clearSelection();

                Get.snackbar(
                  'Success',
                  '${selectedCandidates.length} candidate(s) rejected',
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                );
              } catch (e) {
                Get.snackbar(
                  'Error',
                  'Failed to reject candidates',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } finally {
                isLoading.value = false;
              }
            },
            child: Text('Reject'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  Future<void> addToWatchlist(String candidateId) async {
    try {
      final index = allCandidates.indexWhere((c) => c.id == candidateId);
      if (index != -1) {
        final candidate = allCandidates[index];
        allCandidates[index] = candidate.copyWith(
          isWatchlisted: !candidate.isWatchlisted,
        );
        updateFilteredLists();

        Get.snackbar(
          candidate.isWatchlisted
              ? 'Removed from Watchlist'
              : 'Added to Watchlist',
          candidate.isWatchlisted
              ? '${candidate.name} removed from watchlist'
              : '${candidate.name} added to watchlist',
          backgroundColor: candidate.isWatchlisted
              ? Colors.orange
              : Colors.blue,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update watchlist',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> sendMessage(String candidateId, String message) async {
    if (message.isEmpty) return;

    try {
      // Simulate API call
      await Future.delayed(Duration(milliseconds: 500));

      candidateInteractions.add(
        InteractionModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: 'Message',
          message: message,
          timestamp: DateTime.now(),
          recruiter: 'Current User',
        ),
      );

      messageController.clear();

      Get.snackbar(
        'Message Sent',
        'Your message has been sent to the candidate',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send message',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> addNote(String candidateId, String note) async {
    if (note.isEmpty) return;

    try {
      await Future.delayed(Duration(milliseconds: 500));

      candidateInteractions.add(
        InteractionModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: 'Note',
          message: note,
          timestamp: DateTime.now(),
          recruiter: 'Current User',
        ),
      );

      notesController.clear();

      Get.snackbar(
        'Note Added',
        'Note has been added to candidate profile',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add note',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void exportCandidates() {
    Get.snackbar(
      'Export Started',
      'Candidate data is being exported...',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );

    Future.delayed(Duration(seconds: 2), () {
      Get.snackbar(
        'Export Complete',
        'Candidate data has been exported successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    });
  }

  void clearFilters() {
    selectedDepartment.value = 'All';
    selectedCollege.value = 'All';
    selectedGraduationYear.value = 'All';
    selectedSkills.clear();
    minCGPA.value = 0.0;
    maxCGPA.value = 10.0;
    searchController.clear();
    filterCandidates();
  }

  void refreshData() {
    loadCandidatesData();
  }
}

// Data Models
class CandidateModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String college;
  final String department;
  final int graduationYear;
  final double cgpa;
  final List<String> skills;
  final String profilePicture;
  final String location;
  final String experience;
  final CandidateStatus status;
  final bool isShortlisted;
  final bool isWatchlisted;
  final int appliedJobs;
  final double responseRate;
  final DateTime lastActive;

  CandidateModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.college,
    required this.department,
    required this.graduationYear,
    required this.cgpa,
    required this.skills,
    required this.profilePicture,
    required this.location,
    required this.experience,
    required this.status,
    required this.isShortlisted,
    required this.isWatchlisted,
    required this.appliedJobs,
    required this.responseRate,
    required this.lastActive,
  });

  CandidateModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? college,
    String? department,
    int? graduationYear,
    double? cgpa,
    List<String>? skills,
    String? profilePicture,
    String? location,
    String? experience,
    CandidateStatus? status,
    bool? isShortlisted,
    bool? isWatchlisted,
    int? appliedJobs,
    double? responseRate,
    DateTime? lastActive,
  }) {
    return CandidateModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      college: college ?? this.college,
      department: department ?? this.department,
      graduationYear: graduationYear ?? this.graduationYear,
      cgpa: cgpa ?? this.cgpa,
      skills: skills ?? this.skills,
      profilePicture: profilePicture ?? this.profilePicture,
      location: location ?? this.location,
      experience: experience ?? this.experience,
      status: status ?? this.status,
      isShortlisted: isShortlisted ?? this.isShortlisted,
      isWatchlisted: isWatchlisted ?? this.isWatchlisted,
      appliedJobs: appliedJobs ?? this.appliedJobs,
      responseRate: responseRate ?? this.responseRate,
      lastActive: lastActive ?? this.lastActive,
    );
  }
}

class ApplicationModel {
  final String id;
  final String jobTitle;
  final String company;
  final String status;
  final DateTime appliedDate;
  final String currentRound;

  ApplicationModel({
    required this.id,
    required this.jobTitle,
    required this.company,
    required this.status,
    required this.appliedDate,
    required this.currentRound,
  });
}

class InteractionModel {
  final String id;
  final String type;
  final String message;
  final DateTime timestamp;
  final String recruiter;

  InteractionModel({
    required this.id,
    required this.type,
    required this.message,
    required this.timestamp,
    required this.recruiter,
  });
}

enum CandidateStatus { active, inactive, rejected, hired }
