import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // Reactive variables
  var selectedMenuIndex = 0.obs;
  var isCollapsed = false.obs;
  var currentPageTitle = 'Dashboard'.obs;
  var isLoading = false.obs;

  // User data
  var userName = 'Sarah Johnson'.obs;
  var userRole = 'Senior Recruiter'.obs;
  var userAvatar = ''.obs;
  var companyName = 'TechCorp Solutions'.obs;

  // Navigation items
  final List<NavigationItem> navigationItems = [
    NavigationItem(
      id: 'dashboard',
      title: 'Dashboard',
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      route: '/dashboard',
    ),
    NavigationItem(
      id: 'candidate_management',
      title: 'Candidate Management',
      icon: Icons.people_outlined,
      selectedIcon: Icons.people,
      route: '/candidate-management',
    ),
    NavigationItem(
      id: 'job_management',
      title: 'Job Management',
      icon: Icons.work_outlined,
      selectedIcon: Icons.work,
      route: '/job-management',
    ),
    NavigationItem(
      id: 'interview_scheduling',
      title: 'Interview Scheduling',
      icon: Icons.schedule_outlined,
      selectedIcon: Icons.schedule,
      route: '/interview-scheduling',
    ),
    NavigationItem(
      id: 'recruitment_pipeline',
      title: 'Recruitment Pipeline',
      icon: Icons.timeline_outlined,
      selectedIcon: Icons.timeline,
      route: '/recruitment-pipeline',
    ),
    NavigationItem(
      id: 'group_management',
      title: 'Team Groups',
      icon: Icons.groups_outlined,
      selectedIcon: Icons.groups,
      route: '/group-management',
    ),
    // NavigationItem(
    //   id: 'form_builder',
    //   title: 'Form Builder',
    //   icon: Icons.build_outlined,
    //   selectedIcon: Icons.build,
    //   route: '/form-builder',
    // ),
    NavigationItem(
      id: 'analytics',
      title: 'Analytics & Reports',
      icon: Icons.analytics_outlined,
      selectedIcon: Icons.analytics,
      route: '/analytics',
    ),
  ];

  // Quick access items
  final List<QuickAccessItem> quickAccessItems = [
    QuickAccessItem(
      title: 'Post New Job',
      icon: Icons.add_circle_outline,
      color: Colors.blue,
      action: 'post_job',
    ),
    QuickAccessItem(
      title: 'Review Applications',
      icon: Icons.assignment_outlined,
      color: Colors.green,
      action: 'review_applications',
    ),
    QuickAccessItem(
      title: 'Schedule Interview',
      icon: Icons.calendar_today_outlined,
      color: Colors.orange,
      action: 'schedule_interview',
    ),
    QuickAccessItem(
      title: 'Send Messages',
      icon: Icons.message_outlined,
      color: Colors.purple,
      action: 'send_messages',
    ),
  ];

  // Notifications
  var notifications = <NotificationItem>[].obs;
  var unreadNotifications = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    _loadNotifications();
  }

  void _loadUserData() {
    // Mock user data - in real app, load from storage/API
    userName.value = 'Sarah Johnson';
    userRole.value = 'Senior Recruiter';
    userAvatar.value =
        ''; // Empty string to show alphabet initial instead of broken URL
    companyName.value = 'TechCorp Solutions';
  }

  void _loadNotifications() {
    // Mock notifications
    notifications.value = [
      NotificationItem(
        id: '1',
        title: 'New Application Received',
        message: 'John Doe applied for Software Engineer position',
        timestamp: DateTime.now().subtract(Duration(minutes: 15)),
        type: NotificationType.application,
        isRead: false,
      ),
      NotificationItem(
        id: '2',
        title: 'Interview Reminder',
        message: 'Interview with Jane Smith in 30 minutes',
        timestamp: DateTime.now().subtract(Duration(hours: 1)),
        type: NotificationType.interview,
        isRead: false,
      ),
      NotificationItem(
        id: '3',
        title: 'Application Deadline',
        message: 'Senior Developer position closes tomorrow',
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        type: NotificationType.deadline,
        isRead: true,
      ),
    ];

    unreadNotifications.value = notifications.where((n) => !n.isRead).length;
  }

  void selectMenuItem(int index) {
    if (index != selectedMenuIndex.value) {
      selectedMenuIndex.value = index;
      currentPageTitle.value = navigationItems[index].title;

      // Don't use Get.offNamed - just update the index to switch widgets directly
      // This prevents Scaffold context issues
    }
  }

  void toggleSidebar() {
    isCollapsed.value = !isCollapsed.value;
  }

  void handleQuickAction(String action) {
    switch (action) {
      case 'post_job':
        selectedMenuIndex.value = 2; // Job Management
        currentPageTitle.value = 'Job Management';
        // Removed Get.offNamed to prevent Scaffold context issues
        break;
      case 'review_applications':
        selectedMenuIndex.value = 1; // Candidate Management
        currentPageTitle.value = 'Candidate Management';
        // Removed Get.offNamed to prevent Scaffold context issues
        break;
      case 'schedule_interview':
        selectedMenuIndex.value = 3; // Interview Scheduling
        currentPageTitle.value = 'Interview Scheduling';
        // Removed Get.offNamed to prevent Scaffold context issues
        break;
      case 'send_messages':
        selectedMenuIndex.value = 5; // Group Management
        currentPageTitle.value = 'Team Groups';
        // Removed Get.offNamed to prevent Scaffold context issues
        break;
    }
  }

  void markNotificationAsRead(String notificationId) {
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1 && !notifications[index].isRead) {
      notifications[index] = notifications[index].copyWith(isRead: true);
      unreadNotifications.value = notifications.where((n) => !n.isRead).length;
    }
  }

  void clearAllNotifications() {
    for (int i = 0; i < notifications.length; i++) {
      notifications[i] = notifications[i].copyWith(isRead: true);
    }
    unreadNotifications.value = 0;
  }

  void showProfile() {
    Get.dialog(
      AlertDialog(
        title: Text('User Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue[100],
              child: Text(
                userName.value[0].toUpperCase(),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            Text(
              userName.value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              userRole.value,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            Text(
              companyName.value,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Close')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // Navigate to profile settings
            },
            child: Text('Edit Profile'),
          ),
        ],
      ),
    );
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // Clear user session and navigate to login
              Get.offAllNamed('/login');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  // Method to update current page based on route
  void updateCurrentPage(String route) {
    final item = navigationItems.firstWhereOrNull(
      (item) => item.route == route,
    );
    if (item != null) {
      final index = navigationItems.indexOf(item);
      selectedMenuIndex.value = index;
      currentPageTitle.value = item.title;
    }
  }
}

// Data Models
class NavigationItem {
  final String id;
  final String title;
  final IconData icon;
  final IconData selectedIcon;
  final String route;
  final int? badgeCount;

  NavigationItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.selectedIcon,
    required this.route,
    this.badgeCount,
  });
}

class QuickAccessItem {
  final String title;
  final IconData icon;
  final Color color;
  final String action;

  QuickAccessItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.action,
  });
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    required this.isRead,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    NotificationType? type,
    bool? isRead,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
    );
  }
}

enum NotificationType { application, interview, deadline, message, system }
