import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../analytics/analytics.screen.dart';
import '../auth/auth.screen.dart';
import '../candidate_management/candidate_management.screen.dart';
import '../dashboard/dashboard.screen.dart';
import '../form_builder/form_builder.screen.dart';
import '../group_management/group_management.screen.dart';
import '../job_management/job_management.screen.dart';
import 'controllers/home.controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Row(
        children: [
          // Sidebar Navigation
          _SidebarWidget(),

          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Top Header
                _TopHeaderWidget(),

                // Page Content
                Expanded(child: _PageContentWidget()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Separate sidebar widget to minimize rebuilds
class _SidebarWidget extends GetView<HomeController> {
  const _SidebarWidget();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: controller.isCollapsed.value ? 80 : 280,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(2, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            // Logo/Company Header
            _SidebarHeaderWidget(),

            // Navigation Menu
            Expanded(child: _NavigationMenuWidget()),

            // User Profile Section
            _UserProfileWidget(),
          ],
        ),
      ),
    );
  }
}

// Separate header widget
class _SidebarHeaderWidget extends GetView<HomeController> {
  const _SidebarHeaderWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[600]!, Colors.blue[700]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          // Logo
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.business_center,
              color: Colors.blue[600],
              size: 24,
            ),
          ),

          Obx(() {
            if (controller.isCollapsed.value) return const SizedBox.shrink();

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Campus Connect',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Recruiter Portal',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          }),

          // Collapse Button
          IconButton(
            onPressed: controller.toggleSidebar,
            icon: Obx(
              () => Icon(
                controller.isCollapsed.value ? Icons.menu_open : Icons.menu,
                color: Colors.white,
              ),
            ),
            tooltip: 'Toggle Sidebar',
          ),
        ],
      ),
    );
  }
}

// Separate navigation menu widget
class _NavigationMenuWidget extends GetView<HomeController> {
  const _NavigationMenuWidget();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: controller.navigationItems.length,
      itemBuilder: (context, index) {
        final item = controller.navigationItems[index];
        return _NavigationItemWidget(item: item, index: index);
      },
    );
  }
}

// Individual navigation item widget
class _NavigationItemWidget extends GetView<HomeController> {
  final NavigationItem item;
  final int index;

  const _NavigationItemWidget({required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.selectMenuItem(index),
          borderRadius: BorderRadius.circular(8),
          child: Obx(() {
            final isSelected = controller.selectedMenuIndex.value == index;
            final isCollapsed = controller.isCollapsed.value;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue[50] : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: isSelected
                    ? Border.all(color: Colors.blue[200]!)
                    : null,
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected ? item.selectedIcon : item.icon,
                    color: isSelected ? Colors.blue[600] : Colors.grey[600],
                    size: 20,
                  ),

                  if (!isCollapsed) ...[
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        item.title,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.blue[700]
                              : Colors.grey[700],
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    // Badge for notifications
                    if (item.badgeCount != null && item.badgeCount! > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${item.badgeCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

// User profile widget
class _UserProfileWidget extends GetView<HomeController> {
  const _UserProfileWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Row(
        children: [
          // User Avatar
          Obx(
            () => CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blue[100],
              backgroundImage: controller.userAvatar.value.isNotEmpty
                  ? NetworkImage(controller.userAvatar.value)
                  : null,
              child: controller.userAvatar.value.isEmpty
                  ? Text(
                      controller.userName.value.isNotEmpty
                          ? controller.userName.value[0].toUpperCase()
                          : 'U',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[600],
                      ),
                    )
                  : null,
            ),
          ),

          Obx(() {
            if (controller.isCollapsed.value) {
              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: InkWell(
                  onTap: controller.showProfile,
                  child: Icon(
                    Icons.person_outlined,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                ),
              );
            }

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.userName.value,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            controller.userRole.value,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Profile Menu
                    PopupMenuButton<String>(
                      onSelected: _handleProfileAction,
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'profile',
                          child: Row(
                            children: [
                              Icon(Icons.person_outlined, size: 16),
                              SizedBox(width: 8),
                              Text('Profile'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'settings',
                          child: Row(
                            children: [
                              Icon(Icons.settings_outlined, size: 16),
                              SizedBox(width: 8),
                              Text('Settings'),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(),
                        const PopupMenuItem(
                          value: 'logout',
                          child: Row(
                            children: [
                              Icon(
                                Icons.logout_outlined,
                                size: 16,
                                color: Colors.red,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Logout',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                      child: Icon(
                        Icons.more_vert_outlined,
                        color: Colors.grey[600],
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _handleProfileAction(String action) {
    switch (action) {
      case 'profile':
        controller.showProfile();
        break;
      case 'settings':
        Get.snackbar('Settings', 'Settings page coming soon!');
        break;
      case 'logout':
        controller.logout();
        break;
    }
  }
}

// Top header widget
class _TopHeaderWidget extends GetView<HomeController> {
  const _TopHeaderWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Page Title
          Obx(
            () => Text(
              controller.currentPageTitle.value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),

          const Spacer(),

          // Quick Actions
          const _QuickActionsWidget(),

          const SizedBox(width: 16),

          // Notifications
          const _NotificationButtonWidget(),

          const SizedBox(width: 16),

          // Search Button
          IconButton(
            onPressed: _showGlobalSearch,
            icon: const Icon(Icons.search_outlined),
            tooltip: 'Global Search',
          ),
        ],
      ),
    );
  }

  void _showGlobalSearch() {
    Get.dialog(
      AlertDialog(
        title: const Text('Global Search'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              decoration: InputDecoration(
                hintText: 'Search candidates, jobs, or anything...',
                prefixIcon: Icon(Icons.search_outlined),
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            Text(
              'Search across all modules including candidates, jobs, interviews, and more.',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Get.back(),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }
}

// Quick actions widget
class _QuickActionsWidget extends GetView<HomeController> {
  const _QuickActionsWidget();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: controller.quickAccessItems.map((item) {
        return Container(
          margin: const EdgeInsets.only(right: 8),
          child: Tooltip(
            message: item.title,
            child: InkWell(
              onTap: () => controller.handleQuickAction(item.action),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(item.icon, size: 20, color: item.color),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// Notification button widget
class _NotificationButtonWidget extends GetView<HomeController> {
  const _NotificationButtonWidget();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          onPressed: _showNotifications,
          icon: const Icon(Icons.notifications_outlined),
          tooltip: 'Notifications',
        ),

        Obx(() {
          if (controller.unreadNotifications.value <= 0)
            return const SizedBox.shrink();

          return Positioned(
            right: 8,
            top: 8,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  controller.unreadNotifications.value > 9
                      ? '9+'
                      : '${controller.unreadNotifications.value}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  void _showNotifications() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Notifications',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: controller.clearAllNotifications,
                  child: const Text('Mark all as read'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Expanded(
              child: Obx(
                () => ListView.separated(
                  itemCount: controller.notifications.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final notification = controller.notifications[index];
                    return _NotificationItemWidget(notification: notification);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}

// Individual notification item
class _NotificationItemWidget extends StatelessWidget {
  final NotificationItem notification;

  const _NotificationItemWidget({required this.notification});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _getNotificationColor(notification.type).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          _getNotificationIcon(notification.type),
          color: _getNotificationColor(notification.type),
          size: 20,
        ),
      ),
      title: Text(
        notification.title,
        style: TextStyle(
          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(notification.message),
          const SizedBox(height: 4),
          Text(
            _formatNotificationTime(notification.timestamp),
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
        ],
      ),
      trailing: !notification.isRead
          ? Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.blue[600],
                shape: BoxShape.circle,
              ),
            )
          : null,
      onTap: () =>
          Get.find<HomeController>().markNotificationAsRead(notification.id),
    );
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.application:
        return Colors.green;
      case NotificationType.interview:
        return Colors.blue;
      case NotificationType.deadline:
        return Colors.orange;
      case NotificationType.message:
        return Colors.purple;
      case NotificationType.system:
        return Colors.grey;
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.application:
        return Icons.assignment_outlined;
      case NotificationType.interview:
        return Icons.schedule_outlined;
      case NotificationType.deadline:
        return Icons.warning_outlined;
      case NotificationType.message:
        return Icons.message_outlined;
      case NotificationType.system:
        return Icons.info_outlined;
    }
  }

  String _formatNotificationTime(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }
}

// Page content widget with smooth transitions
class _PageContentWidget extends GetView<HomeController> {
  const _PageContentWidget();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0.1, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                  ),
              child: child,
            ),
          );
        },
        child: _getScreenForIndex(controller.selectedMenuIndex.value),
      );
    });
  }

  Widget _getScreenForIndex(int index) {
    Widget screen;
    switch (index) {
      case 0:
        screen = const DashboardScreen();
        break;
      case 1:
        screen = const CandidateManagementScreen();
        break;
      case 2:
        screen = const JobManagementScreen();
        break;
      case 3:
        screen = const GroupManagementScreen();
        break;
      case 4:
        screen = const FormBuilderScreen();
        break;
      case 5:
        screen = const AnalyticsScreen();
        break;
      case 6:
        screen = const AuthScreen();
        break;
      default:
        screen = const DashboardScreen();
    }

    // Add unique key to ensure proper transitions
    return Container(key: ValueKey('screen_$index'), child: screen);
  }
}
