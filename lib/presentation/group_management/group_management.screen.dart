import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/group_management.controller.dart';
import 'views/group_chat_view.dart';
import 'views/group_monitoring_view.dart';

class GroupManagementScreen extends GetView<GroupManagementController> {
  const GroupManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Row(
        children: [
          // Groups Sidebar
          Container(
            width: 320,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                right: BorderSide(color: Colors.grey[200]!, width: 1),
              ),
            ),
            child: _buildGroupsSidebar(),
          ),

          // Main Content Area
          Expanded(
            child: Obx(() {
              if (controller.selectedGroupId.value.isEmpty) {
                return _buildWelcomeScreen();
              }

              return Row(
                children: [
                  // Chat Area
                  Expanded(flex: 3, child: GroupChatView()),

                  // Group Info Panel
                  Container(
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        left: BorderSide(color: Colors.grey[200]!, width: 1),
                      ),
                    ),
                    child: GroupMonitoringView(),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupsSidebar() {
    return Column(
      children: [
        // Header
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey[200]!, width: 1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Team Groups',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 4),
                      Obx(
                        () => Text(
                          '${controller.filteredGroups.length} groups',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Create Group Button
                  IconButton(
                    onPressed: controller.showCreateGroupDialog,
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: Colors.blue[600],
                    ),
                    tooltip: 'Create New Group',
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Search Bar
              TextField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  hintText: 'Search groups...',
                  prefixIcon: Icon(Icons.search_outlined, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),

              SizedBox(height: 12),

              // Filters Row
              Row(
                children: [
                  // Group Type Filter
                  Expanded(
                    child: Obx(
                      () => DropdownButtonFormField<String>(
                        value: controller.selectedGroupType.value,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          isDense: true,
                        ),
                        items: controller.groupTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type, style: TextStyle(fontSize: 12)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedGroupType.value = value;
                            controller.filterGroups();
                          }
                        },
                      ),
                    ),
                  ),

                  SizedBox(width: 8),

                  // Online Filter Toggle
                  Obx(
                    () => Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: () {
                          controller.showOnlineOnly.value =
                              !controller.showOnlineOnly.value;
                          controller.filterGroups();
                        },
                        icon: Icon(
                          controller.showOnlineOnly.value
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: controller.showOnlineOnly.value
                              ? Colors.green
                              : Colors.grey,
                          size: 18,
                        ),
                        tooltip: 'Show online groups only',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Groups List
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            if (controller.filteredGroups.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.group_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 12),
                    Text(
                      'No groups found',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: controller.showCreateGroupDialog,
                      icon: Icon(Icons.add_outlined, size: 16),
                      label: Text('Create Group'),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8),
              itemCount: controller.filteredGroups.length,
              itemBuilder: (context, index) {
                final group = controller.filteredGroups[index];
                return _buildGroupItem(group);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildGroupItem(RecruitmentGroup group) {
    return Obx(
      () => Container(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        decoration: BoxDecoration(
          color: controller.selectedGroupId.value == group.id
              ? Colors.blue[50]
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: controller.selectedGroupId.value == group.id
                ? Colors.blue[200]!
                : Colors.transparent,
          ),
        ),
        child: ListTile(
          onTap: () => controller.selectGroup(group.id),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          leading: Stack(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[200],
                backgroundImage: group.avatar.isNotEmpty
                    ? NetworkImage(group.avatar)
                    : null,
                child: group.avatar.isEmpty
                    ? Text(
                        group.name[0].toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      )
                    : null,
              ),

              // Online indicator
              if (group.onlineCount > 0)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),

          title: Row(
            children: [
              Expanded(
                child: Text(
                  group.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Pinned indicator
              if (group.isPinned)
                Icon(Icons.push_pin, size: 14, color: Colors.orange[600]),

              // Private indicator
              if (group.isPrivate)
                Icon(Icons.lock_outlined, size: 14, color: Colors.grey[500]),
            ],
          ),

          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                group.lastMessage.content,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),

              SizedBox(height: 4),

              Row(
                children: [
                  Icon(
                    Icons.people_outlined,
                    size: 12,
                    color: Colors.grey[500],
                  ),
                  SizedBox(width: 2),
                  Text(
                    '${group.memberCount}',
                    style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                  ),

                  if (group.onlineCount > 0) ...[
                    SizedBox(width: 8),
                    Icon(Icons.circle, size: 6, color: Colors.green),
                    SizedBox(width: 2),
                    Text(
                      '${group.onlineCount}',
                      style: TextStyle(fontSize: 10, color: Colors.green),
                    ),
                  ],

                  Spacer(),

                  Text(
                    _formatMessageTime(group.lastMessage.timestamp),
                    style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                  ),
                ],
              ),
            ],
          ),

          trailing: group.unreadCount > 0
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: BoxConstraints(minWidth: 18),
                  child: Text(
                    group.unreadCount > 99
                        ? '99+'
                        : group.unreadCount.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : null,

          // Context Menu
          onLongPress: () => _showGroupContextMenu(group),
        ),
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.groups_outlined, size: 120, color: Colors.grey[300]),

          SizedBox(height: 24),

          Text(
            'Welcome to Team Groups',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),

          SizedBox(height: 12),

          Text(
            'Select a group to start collaborating with your team',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 32),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: controller.showCreateGroupDialog,
                icon: Icon(Icons.add_outlined),
                label: Text('Create New Group'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),

              SizedBox(width: 16),

              OutlinedButton.icon(
                onPressed: () {
                  // Show help or tutorial
                  Get.snackbar(
                    'Help',
                    'Group management help coming soon!',
                    backgroundColor: Colors.blue,
                    colorText: Colors.white,
                  );
                },
                icon: Icon(Icons.help_outline),
                label: Text('Learn More'),
              ),
            ],
          ),

          SizedBox(height: 40),

          // Quick Stats
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Obx(
              () => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildQuickStat(
                    'Total Groups',
                    '${controller.recruitmentGroups.length}',
                    Icons.group_outlined,
                    Colors.blue,
                  ),

                  SizedBox(width: 32),

                  _buildQuickStat(
                    'Active Members',
                    '${controller.onlineUsers.length}',
                    Icons.person_outlined,
                    Colors.green,
                  ),

                  SizedBox(width: 32),

                  _buildQuickStat(
                    'Unread Messages',
                    '${controller.recruitmentGroups.fold<int>(0, (sum, group) => sum + group.unreadCount)}',
                    Icons.message_outlined,
                    Colors.orange,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),

        SizedBox(height: 8),

        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),

        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  void _showGroupContextMenu(RecruitmentGroup group) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Group Header
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: group.avatar.isNotEmpty
                      ? NetworkImage(group.avatar)
                      : null,
                  child: group.avatar.isEmpty
                      ? Text(group.name[0].toUpperCase())
                      : null,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${group.memberCount} members',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Actions
            Column(
              children: [
                ListTile(
                  leading: Icon(
                    group.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                    color: Colors.orange,
                  ),
                  title: Text(group.isPinned ? 'Unpin Group' : 'Pin Group'),
                  onTap: () {
                    Get.back();
                    controller.togglePinGroup(group.id);
                  },
                ),

                ListTile(
                  leading: Icon(
                    Icons.notifications_off_outlined,
                    color: Colors.grey,
                  ),
                  title: Text('Mute Notifications'),
                  onTap: () {
                    Get.back();
                    controller.toggleMuteGroup(group.id);
                  },
                ),

                ListTile(
                  leading: Icon(Icons.person_add_outlined, color: Colors.blue),
                  title: Text('Add Members'),
                  onTap: () {
                    Get.back();
                    _showAddMembersDialog(group);
                  },
                ),

                ListTile(
                  leading: Icon(Icons.info_outlined, color: Colors.grey),
                  title: Text('Group Info'),
                  onTap: () {
                    Get.back();
                    // Show group info
                  },
                ),

                Divider(),

                ListTile(
                  leading: Icon(Icons.exit_to_app_outlined, color: Colors.red),
                  title: Text(
                    'Leave Group',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Get.back();
                    controller.leaveGroup(group.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddMembersDialog(RecruitmentGroup group) {
    Get.dialog(
      AlertDialog(
        title: Text('Add Members to ${group.name}'),
        content: Container(
          width: 300,
          height: 400,
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search team members...',
                  prefixIcon: Icon(Icons.search_outlined),
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 16),

              Expanded(
                child: ListView.builder(
                  itemCount: controller.groupMembers.length,
                  itemBuilder: (context, index) {
                    final member = controller.groupMembers[index];
                    return CheckboxListTile(
                      value: false,
                      onChanged: (value) {},
                      title: Text(member.name),
                      subtitle: Text(member.role),
                      secondary: CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(member.avatar),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // Add selected members
              controller.addMembersToGroup(group.id, ['user_6', 'user_7']);
            },
            child: Text('Add Members'),
          ),
        ],
      ),
    );
  }

  String _formatMessageTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }
}

// Create Group Dialog
class CreateGroupDialog extends StatefulWidget {
  @override
  _CreateGroupDialogState createState() => _CreateGroupDialogState();
}

class _CreateGroupDialogState extends State<CreateGroupDialog> {
  final controller = Get.find<GroupManagementController>();
  String selectedType = 'Recruitment Team';
  bool isPrivate = false;
  List<String> selectedMembers = [];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 500,
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Create New Group',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close_outlined),
                ),
              ],
            ),

            SizedBox(height: 20),

            TextField(
              controller: controller.groupNameController,
              decoration: InputDecoration(
                labelText: 'Group Name',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 16),

            TextField(
              controller: controller.groupDescriptionController,
              decoration: InputDecoration(
                labelText: 'Description (Optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),

            SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: selectedType,
              decoration: InputDecoration(
                labelText: 'Group Type',
                border: OutlineInputBorder(),
              ),
              items: controller.groupTypes.skip(1).map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                });
              },
            ),

            SizedBox(height: 16),

            CheckboxListTile(
              value: isPrivate,
              onChanged: (value) {
                setState(() {
                  isPrivate = value!;
                });
              },
              title: Text('Private Group'),
              subtitle: Text('Only invited members can join'),
              contentPadding: EdgeInsets.zero,
            ),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
                SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    controller.createGroup(
                      name: controller.groupNameController.text,
                      description: controller.groupDescriptionController.text,
                      type: selectedType,
                      memberIds: selectedMembers,
                      isPrivate: isPrivate,
                    );
                    Get.back();
                  },
                  child: Text('Create Group'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
