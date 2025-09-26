import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/group_management.controller.dart';

class GroupMonitoringView extends GetView<GroupManagementController> {
  const GroupMonitoringView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedGroup = controller.recruitmentGroups.firstWhereOrNull(
        (g) => g.id == controller.selectedGroupId.value,
      );

      if (selectedGroup == null) {
        return Center(child: Text('No group selected'));
      }

      return SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group Header
            _buildGroupHeader(selectedGroup),

            SizedBox(height: 20),

            // Quick Actions
            _buildQuickActions(selectedGroup),

            SizedBox(height: 20),

            // Group Members
            _buildGroupMembers(),

            SizedBox(height: 20),

            // Group Statistics
            _buildGroupStatistics(selectedGroup),

            SizedBox(height: 20),

            // Recent Activity
            _buildRecentActivity(),

            SizedBox(height: 20),

            // Group Settings
            _buildGroupSettings(selectedGroup),
          ],
        ),
      );
    });
  }

  Widget _buildGroupHeader(RecruitmentGroup group) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[50]!, Colors.blue[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Group Avatar
          Stack(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                backgroundImage: group.avatar.isNotEmpty
                    ? NetworkImage(group.avatar)
                    : null,
                child: group.avatar.isEmpty
                    ? Text(
                        group.name[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[600],
                        ),
                      )
                    : null,
              ),

              // Edit avatar button
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          // Group Name and Type
          Text(
            group.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 4),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getGroupTypeColor(group.type).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              group.type,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _getGroupTypeColor(group.type),
              ),
            ),
          ),

          SizedBox(height: 8),

          // Group Description
          if (group.description.isNotEmpty)
            Text(
              group.description,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

          SizedBox(height: 12),

          // Group Stats Row
          Row(
            children: [
              _buildStatItem(
                Icons.people_outlined,
                '${group.memberCount}',
                'Members',
                Colors.blue,
              ),
              _buildStatItem(
                Icons.circle,
                '${group.onlineCount}',
                'Online',
                Colors.green,
              ),
              _buildStatItem(
                Icons.access_time_outlined,
                _formatDate(group.createdAt),
                'Created',
                Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildQuickActions(RecruitmentGroup group) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),

        SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                Icons.person_add_outlined,
                'Add Member',
                Colors.blue,
                () => _showAddMemberDialog(group),
              ),
            ),

            SizedBox(width: 8),

            Expanded(
              child: _buildActionButton(
                Icons.videocam_outlined,
                'Video Call',
                Colors.green,
                () => _startVideoCall(group),
              ),
            ),
          ],
        ),

        SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                Icons.share_outlined,
                'Share Group',
                Colors.orange,
                () => _shareGroup(group),
              ),
            ),

            SizedBox(width: 8),

            Expanded(
              child: _buildActionButton(
                Icons.settings_outlined,
                'Settings',
                Colors.grey,
                () => _showGroupSettings(group),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupMembers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Members',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),

            TextButton(
              onPressed: () => _showAllMembers(),
              child: Text('View All', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),

        SizedBox(height: 12),

        // Online Members
        Text(
          'Online (${controller.onlineUsers.length})',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.green[600],
          ),
        ),

        SizedBox(height: 8),

        Column(
          children: controller.groupMembers
              .where((member) => member.isOnline)
              .take(5)
              .map((member) => _buildMemberItem(member, true))
              .toList(),
        ),

        SizedBox(height: 12),

        // Offline Members
        Text(
          'Offline',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),

        SizedBox(height: 8),

        Column(
          children: controller.groupMembers
              .where((member) => !member.isOnline)
              .take(3)
              .map((member) => _buildMemberItem(member, false))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildMemberItem(GroupMember member, bool isOnline) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Avatar with online indicator
          Stack(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(member.avatar),
                onBackgroundImageError: (_, __) {},
                child: member.avatar.isEmpty
                    ? Text(
                        member.name[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),

              if (isOnline)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(width: 8),

          // Member info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),

                Text(
                  member.role,
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Last seen or online indicator
          Text(
            isOnline ? 'Online' : _formatLastSeen(member.lastSeen),
            style: TextStyle(
              fontSize: 10,
              color: isOnline ? Colors.green[600] : Colors.grey[500],
            ),
          ),

          // Member actions
          PopupMenuButton<String>(
            onSelected: (action) => _handleMemberAction(action, member),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'message',
                child: Row(
                  children: [
                    Icon(Icons.message_outlined, size: 16),
                    SizedBox(width: 8),
                    Text('Message'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outlined, size: 16),
                    SizedBox(width: 8),
                    Text('View Profile'),
                  ],
                ),
              ),
              if (member.permissions.contains('admin'))
                PopupMenuItem(
                  value: 'admin',
                  child: Row(
                    children: [
                      Icon(Icons.admin_panel_settings_outlined, size: 16),
                      SizedBox(width: 8),
                      Text('Admin Actions'),
                    ],
                  ),
                ),
            ],
            child: Icon(
              Icons.more_vert_outlined,
              size: 16,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupStatistics(RecruitmentGroup group) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Group Statistics',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),

        SizedBox(height: 12),

        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              // Messages today
              _buildStatRow(
                Icons.message_outlined,
                'Messages Today',
                '${controller.groupMessages.where((msg) => _isToday(msg.timestamp)).length}',
                Colors.blue,
              ),

              Divider(height: 20),

              // Most active member
              _buildStatRow(
                Icons.star_outlined,
                'Most Active',
                controller.groupMembers.isNotEmpty
                    ? controller.groupMembers.first.name
                    : 'N/A',
                Colors.orange,
              ),

              Divider(height: 20),

              // Files shared
              _buildStatRow(
                Icons.attach_file_outlined,
                'Files Shared',
                '${controller.groupMessages.where((msg) => msg.type == MessageType.file).length}',
                Colors.green,
              ),

              Divider(height: 20),

              // Group age
              _buildStatRow(
                Icons.calendar_today_outlined,
                'Group Age',
                '${DateTime.now().difference(group.createdAt).inDays} days',
                Colors.purple,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),

        SizedBox(height: 12),

        Container(
          constraints: BoxConstraints(maxHeight: 200),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 5, // Show last 5 activities
            itemBuilder: (context, index) {
              return _buildActivityItem(index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(int index) {
    final activities = [
      {
        'user': 'Sarah Johnson',
        'action': 'sent a message',
        'time': '2 minutes ago',
        'icon': Icons.message_outlined,
      },
      {
        'user': 'Mike Wilson',
        'action': 'joined the group',
        'time': '1 hour ago',
        'icon': Icons.person_add_outlined,
      },
      {
        'user': 'Emily Davis',
        'action': 'shared a file',
        'time': '3 hours ago',
        'icon': Icons.attach_file_outlined,
      },
      {
        'user': 'Alex Chen',
        'action': 'updated group settings',
        'time': '1 day ago',
        'icon': Icons.settings_outlined,
      },
      {
        'user': 'Lisa Brown',
        'action': 'started a video call',
        'time': '2 days ago',
        'icon': Icons.videocam_outlined,
      },
    ];

    final activity = activities[index % activities.length];

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              activity['icon'] as IconData,
              size: 12,
              color: Colors.blue[600],
            ),
          ),

          SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${activity['user']} ${activity['action']}',
                  style: TextStyle(fontSize: 11, color: Colors.grey[800]),
                ),

                Text(
                  activity['time'] as String,
                  style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupSettings(RecruitmentGroup group) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Group Settings',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),

        SizedBox(height: 12),

        // Settings options
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              // Notifications
              SwitchListTile(
                title: Text('Notifications', style: TextStyle(fontSize: 12)),
                subtitle: Text(
                  'Receive group notifications',
                  style: TextStyle(fontSize: 10),
                ),
                value: controller.isNotificationsEnabled.value,
                onChanged: (value) {
                  controller.isNotificationsEnabled.value = value;
                },
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
              ),

              Divider(height: 1),

              // Pin group
              SwitchListTile(
                title: Text('Pin Group', style: TextStyle(fontSize: 12)),
                subtitle: Text(
                  'Keep group at top',
                  style: TextStyle(fontSize: 10),
                ),
                value: group.isPinned,
                onChanged: (value) {
                  controller.togglePinGroup(group.id);
                },
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
              ),

              Divider(height: 1),

              // Media auto-download
              SwitchListTile(
                title: Text(
                  'Auto-download Media',
                  style: TextStyle(fontSize: 12),
                ),
                subtitle: Text(
                  'Download photos and videos',
                  style: TextStyle(fontSize: 10),
                ),
                value: false,
                onChanged: (value) {
                  // Implement auto-download setting
                },
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16),

        // Advanced options
        Column(
          children: [
            _buildSettingOption(
              Icons.link_outlined,
              'Invite Link',
              'Share group invite link',
              () => _generateInviteLink(group),
            ),

            _buildSettingOption(
              Icons.history_outlined,
              'Message History',
              'Export chat history',
              () => _exportChatHistory(group),
            ),

            _buildSettingOption(
              Icons.security_outlined,
              'Privacy Settings',
              'Manage group privacy',
              () => _showPrivacySettings(group),
            ),

            Divider(),

            _buildSettingOption(
              Icons.exit_to_app_outlined,
              'Leave Group',
              'Leave this group',
              () => controller.leaveGroup(group.id),
              isDestructive: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingOption(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        size: 18,
        color: isDestructive ? Colors.red : Colors.grey[600],
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isDestructive ? Colors.red : Colors.grey[800],
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      visualDensity: VisualDensity.compact,
    );
  }

  // Helper methods
  Color _getGroupTypeColor(String type) {
    switch (type) {
      case 'Recruitment Team':
        return Colors.blue;
      case 'Interview Panel':
        return Colors.green;
      case 'Department':
        return Colors.orange;
      case 'Project Team':
        return Colors.purple;
      case 'Training Group':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatLastSeen(DateTime lastSeen) {
    final now = DateTime.now();
    final difference = now.difference(lastSeen);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Action methods
  void _showAddMemberDialog(RecruitmentGroup group) {
    Get.dialog(
      AlertDialog(
        title: Text('Add Member to ${group.name}'),
        content: Container(
          width: 300,
          height: 300,
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search by name or email...',
                  prefixIcon: Icon(Icons.search_outlined),
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 16),

              Expanded(
                child: ListView.builder(
                  itemCount: 5, // Available members to add
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 16,
                        child: Text('U${index + 1}'),
                      ),
                      title: Text(
                        'User ${index + 1}',
                        style: TextStyle(fontSize: 12),
                      ),
                      subtitle: Text(
                        'user${index + 1}@company.com',
                        style: TextStyle(fontSize: 10),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {},
                        child: Text('Add', style: TextStyle(fontSize: 10)),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(50, 30),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Close')),
        ],
      ),
    );
  }

  void _startVideoCall(RecruitmentGroup group) {
    Get.snackbar(
      'Video Call',
      'Starting video call with ${group.name}...',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _shareGroup(RecruitmentGroup group) {
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
            Text(
              'Share Group',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 16),

            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'https://campusconnect.com/group/${group.id}',
                      style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.snackbar('Copied', 'Group link copied to clipboard');
                    },
                    icon: Icon(Icons.copy_outlined, size: 16),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            ElevatedButton(
              onPressed: () => Get.back(),
              child: Text('Share Link'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 40),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGroupSettings(RecruitmentGroup group) {
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
            Text(
              'Group Settings',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            ListTile(
              leading: Icon(Icons.edit_outlined),
              title: Text('Edit Group Info'),
              onTap: () {
                Get.back();
                _showEditGroupDialog(group);
              },
            ),

            ListTile(
              leading: Icon(Icons.people_outlined),
              title: Text('Manage Members'),
              onTap: () {
                Get.back();
                _showManageMembersDialog(group);
              },
            ),

            ListTile(
              leading: Icon(Icons.security_outlined),
              title: Text('Privacy Settings'),
              onTap: () {
                Get.back();
                _showPrivacySettings(group);
              },
            ),

            ListTile(
              leading: Icon(Icons.archive_outlined),
              title: Text('Archive Group'),
              onTap: () {
                Get.back();
                _archiveGroup(group);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAllMembers() {
    Get.dialog(
      Dialog(
        child: Container(
          width: 400,
          height: 500,
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Group Members',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close_outlined),
                  ),
                ],
              ),

              SizedBox(height: 16),

              TextField(
                decoration: InputDecoration(
                  hintText: 'Search members...',
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
                    return _buildMemberItem(member, member.isOnline);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleMemberAction(String action, GroupMember member) {
    switch (action) {
      case 'message':
        Get.snackbar('Message', 'Messaging ${member.name}...');
        break;
      case 'profile':
        Get.snackbar('Profile', 'Viewing ${member.name}\'s profile...');
        break;
      case 'admin':
        Get.snackbar('Admin', 'Admin actions for ${member.name}...');
        break;
    }
  }

  void _generateInviteLink(RecruitmentGroup group) {
    Get.snackbar(
      'Invite Link Generated',
      'Group invite link has been copied to clipboard',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void _exportChatHistory(RecruitmentGroup group) {
    Get.snackbar(
      'Export Started',
      'Chat history export has been started',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void _showPrivacySettings(RecruitmentGroup group) {
    Get.dialog(
      AlertDialog(
        title: Text('Privacy Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: Text('Private Group'),
              subtitle: Text('Only invited members can join'),
              value: group.isPrivate,
              onChanged: (value) {
                // Update privacy setting
              },
            ),
            SwitchListTile(
              title: Text('Allow Members to Add Others'),
              value: true,
              onChanged: (value) {
                // Update member permissions
              },
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(onPressed: () => Get.back(), child: Text('Save')),
        ],
      ),
    );
  }

  void _showEditGroupDialog(RecruitmentGroup group) {
    final nameController = TextEditingController(text: group.name);
    final descController = TextEditingController(text: group.description);

    Get.dialog(
      AlertDialog(
        title: Text('Edit Group'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Group Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: descController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar('Updated', 'Group information updated');
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showManageMembersDialog(RecruitmentGroup group) {
    Get.dialog(
      Dialog(
        child: Container(
          width: 400,
          height: 500,
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'Manage Members',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 16),

              Expanded(
                child: ListView.builder(
                  itemCount: controller.groupMembers.length,
                  itemBuilder: (context, index) {
                    final member = controller.groupMembers[index];
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(member.avatar),
                      ),
                      title: Text(member.name, style: TextStyle(fontSize: 12)),
                      subtitle: Text(
                        member.role,
                        style: TextStyle(fontSize: 10),
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (action) {
                          switch (action) {
                            case 'promote':
                              Get.snackbar(
                                'Promoted',
                                '${member.name} promoted to admin',
                              );
                              break;
                            case 'remove':
                              Get.snackbar(
                                'Removed',
                                '${member.name} removed from group',
                              );
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'promote',
                            child: Text('Make Admin'),
                          ),
                          PopupMenuItem(value: 'remove', child: Text('Remove')),
                        ],
                      ),
                    );
                  },
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Get.back(), child: Text('Close')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _archiveGroup(RecruitmentGroup group) {
    Get.dialog(
      AlertDialog(
        title: Text('Archive Group'),
        content: Text(
          'Are you sure you want to archive "${group.name}"? This will hide the group from your active groups list.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar('Archived', 'Group has been archived');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: Text('Archive'),
          ),
        ],
      ),
    );
  }
}
