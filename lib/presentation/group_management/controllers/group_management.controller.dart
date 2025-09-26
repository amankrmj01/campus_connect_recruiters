import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupManagementController extends GetxController {
  // Reactive variables
  var isLoading = false.obs;
  var selectedTab = 0.obs;
  var selectedGroupId = ''.obs;
  var isCreateGroupMode = false.obs;
  var searchQuery = ''.obs;

  // Group data
  var recruitmentGroups = <RecruitmentGroup>[].obs;
  var filteredGroups = <RecruitmentGroup>[].obs;
  var groupMembers = <GroupMember>[].obs;
  var groupMessages = <GroupMessage>[].obs;
  var groupActivities = <GroupActivity>[].obs;

  // Chat data
  var isTyping = false.obs;
  var typingUsers = <String>[].obs;
  var onlineUsers = <String>[].obs;
  var unreadCounts = <String, int>{}.obs;

  // Form controllers
  final searchController = TextEditingController();
  final messageController = TextEditingController();
  final groupNameController = TextEditingController();
  final groupDescriptionController = TextEditingController();

  // Filters and settings
  var selectedGroupType = 'All'.obs;
  var selectedRole = 'All'.obs;
  var showOnlineOnly = false.obs;
  var isNotificationsEnabled = true.obs;

  final groupTypes = [
    'All',
    'Recruitment Team',
    'Interview Panel',
    'Department',
    'Project Team',
    'Training Group',
  ];
  final roles = [
    'All',
    'Admin',
    'Recruiter',
    'HR Manager',
    'Team Lead',
    'Member',
  ];

  @override
  void onInit() {
    super.onInit();
    loadGroupData();
    searchController.addListener(_onSearchChanged);

    // Simulate real-time updates
    _startRealTimeUpdates();
  }

  @override
  void onClose() {
    searchController.dispose();
    messageController.dispose();
    groupNameController.dispose();
    groupDescriptionController.dispose();
    super.onClose();
  }

  void loadGroupData() {
    isLoading.value = true;

    Future.delayed(Duration(seconds: 1), () {
      _loadMockData();
      filterGroups();
      isLoading.value = false;
    });
  }

  void _loadMockData() {
    // Mock recruitment groups
    recruitmentGroups.value = [
      RecruitmentGroup(
        id: 'group_1',
        name: 'Software Engineering Team',
        description: 'Recruitment team for software engineering positions',
        type: 'Recruitment Team',
        avatar: 'https://example.com/avatar1.jpg',
        memberCount: 8,
        onlineCount: 5,
        lastMessage: GroupMessage(
          id: 'msg_1',
          senderId: 'user_2',
          senderName: 'Sarah Johnson',
          content: 'Great candidates in today\'s interviews!',
          timestamp: DateTime.now().subtract(Duration(minutes: 15)),
          type: MessageType.text,
        ),
        createdBy: 'user_1',
        createdAt: DateTime.now().subtract(Duration(days: 30)),
        isPrivate: false,
        unreadCount: 3,
        isPinned: true,
        status: GroupStatus.active,
      ),

      RecruitmentGroup(
        id: 'group_2',
        name: 'Interview Panel - Tech Roles',
        description: 'Coordination group for technical interviews',
        type: 'Interview Panel',
        avatar: 'https://example.com/avatar2.jpg',
        memberCount: 6,
        onlineCount: 2,
        lastMessage: GroupMessage(
          id: 'msg_2',
          senderId: 'user_3',
          senderName: 'Mike Wilson',
          content: 'Interview scheduled for tomorrow at 2 PM',
          timestamp: DateTime.now().subtract(Duration(hours: 2)),
          type: MessageType.text,
        ),
        createdBy: 'user_2',
        createdAt: DateTime.now().subtract(Duration(days: 15)),
        isPrivate: true,
        unreadCount: 1,
        isPinned: false,
        status: GroupStatus.active,
      ),

      RecruitmentGroup(
        id: 'group_3',
        name: 'HR Department',
        description: 'General HR team communications',
        type: 'Department',
        avatar: 'https://example.com/avatar3.jpg',
        memberCount: 12,
        onlineCount: 7,
        lastMessage: GroupMessage(
          id: 'msg_3',
          senderId: 'user_4',
          senderName: 'Emily Davis',
          content: 'New policy updates shared in the files',
          timestamp: DateTime.now().subtract(Duration(minutes: 45)),
          type: MessageType.file,
        ),
        createdBy: 'user_1',
        createdAt: DateTime.now().subtract(Duration(days: 60)),
        isPrivate: false,
        unreadCount: 0,
        isPinned: true,
        status: GroupStatus.active,
      ),

      RecruitmentGroup(
        id: 'group_4',
        name: 'Campus Recruitment 2025',
        description: 'Planning and coordination for campus recruitment drive',
        type: 'Project Team',
        avatar: 'https://example.com/avatar4.jpg',
        memberCount: 15,
        onlineCount: 9,
        lastMessage: GroupMessage(
          id: 'msg_4',
          senderId: 'user_5',
          senderName: 'Alex Chen',
          content: 'College visit schedule updated',
          timestamp: DateTime.now().subtract(Duration(minutes: 5)),
          type: MessageType.text,
        ),
        createdBy: 'user_2',
        createdAt: DateTime.now().subtract(Duration(days: 10)),
        isPrivate: false,
        unreadCount: 7,
        isPinned: false,
        status: GroupStatus.active,
      ),

      RecruitmentGroup(
        id: 'group_5',
        name: 'Recruiting Training',
        description: 'Training group for new recruiters',
        type: 'Training Group',
        avatar: 'https://example.com/avatar5.jpg',
        memberCount: 10,
        onlineCount: 3,
        lastMessage: GroupMessage(
          id: 'msg_5',
          senderId: 'user_6',
          senderName: 'Lisa Brown',
          content: 'Training materials uploaded',
          timestamp: DateTime.now().subtract(Duration(hours: 4)),
          type: MessageType.file,
        ),
        createdBy: 'user_3',
        createdAt: DateTime.now().subtract(Duration(days: 5)),
        isPrivate: false,
        unreadCount: 2,
        isPinned: false,
        status: GroupStatus.active,
      ),
    ];

    // Mock group members
    groupMembers.value = [
      GroupMember(
        id: 'user_1',
        name: 'John Smith',
        email: 'john.smith@company.com',
        role: 'HR Manager',
        avatar: 'https://example.com/user1.jpg',
        isOnline: true,
        lastSeen: DateTime.now(),
        joinedAt: DateTime.now().subtract(Duration(days: 90)),
        permissions: [
          'admin',
          'send_message',
          'add_members',
          'delete_messages',
        ],
      ),
      GroupMember(
        id: 'user_2',
        name: 'Sarah Johnson',
        email: 'sarah.johnson@company.com',
        role: 'Senior Recruiter',
        avatar: 'https://example.com/user2.jpg',
        isOnline: true,
        lastSeen: DateTime.now(),
        joinedAt: DateTime.now().subtract(Duration(days: 60)),
        permissions: ['send_message', 'add_members'],
      ),
      GroupMember(
        id: 'user_3',
        name: 'Mike Wilson',
        email: 'mike.wilson@company.com',
        role: 'Technical Recruiter',
        avatar: 'https://example.com/user3.jpg',
        isOnline: false,
        lastSeen: DateTime.now().subtract(Duration(hours: 2)),
        joinedAt: DateTime.now().subtract(Duration(days: 45)),
        permissions: ['send_message'],
      ),
      GroupMember(
        id: 'user_4',
        name: 'Emily Davis',
        email: 'emily.davis@company.com',
        role: 'HR Coordinator',
        avatar: 'https://example.com/user4.jpg',
        isOnline: true,
        lastSeen: DateTime.now(),
        joinedAt: DateTime.now().subtract(Duration(days: 30)),
        permissions: ['send_message'],
      ),
      GroupMember(
        id: 'user_5',
        name: 'Alex Chen',
        email: 'alex.chen@company.com',
        role: 'Campus Recruiter',
        avatar: 'https://example.com/user5.jpg',
        isOnline: true,
        lastSeen: DateTime.now(),
        joinedAt: DateTime.now().subtract(Duration(days: 20)),
        permissions: ['send_message', 'add_members'],
      ),
    ];

    // Mock online users
    onlineUsers.value = groupMembers
        .where((m) => m.isOnline)
        .map((m) => m.id)
        .toList();
  }

  void _onSearchChanged() {
    searchQuery.value = searchController.text;
    filterGroups();
  }

  void filterGroups() {
    var filtered = List<RecruitmentGroup>.from(recruitmentGroups);

    // Search filter
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered
          .where(
            (group) =>
                group.name.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ||
                group.description.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ),
          )
          .toList();
    }

    // Type filter
    if (selectedGroupType.value != 'All') {
      filtered = filtered
          .where((group) => group.type == selectedGroupType.value)
          .toList();
    }

    // Online only filter
    if (showOnlineOnly.value) {
      filtered = filtered.where((group) => group.onlineCount > 0).toList();
    }

    // Sort by priority (pinned first, then by last message)
    filtered.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.lastMessage.timestamp.compareTo(a.lastMessage.timestamp);
    });

    filteredGroups.value = filtered;
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }

  void selectGroup(String groupId) {
    selectedGroupId.value = groupId;
    loadGroupMessages(groupId);
    loadGroupMembers(groupId);
    markMessagesAsRead(groupId);
  }

  void loadGroupMessages(String groupId) {
    // Mock loading group messages
    groupMessages.value = List.generate(10, (index) {
      final senders = groupMembers.take(3).toList();
      final sender = senders[index % senders.length];

      return GroupMessage(
        id: 'msg_${index + 10}',
        senderId: sender.id,
        senderName: sender.name,
        content: _getMockMessageContent(index),
        timestamp: DateTime.now().subtract(Duration(minutes: index * 15)),
        type: index % 5 == 0 ? MessageType.file : MessageType.text,
        reactions: index % 3 == 0
            ? {
                '👍': ['user_1', 'user_2'],
                '❤️': ['user_3'],
              }
            : {},
        replyTo: index % 4 == 0 ? 'msg_${index + 5}' : null,
      );
    }).reversed.toList();
  }

  void loadGroupMembers(String groupId) {
    // Filter members based on selected group (mock implementation)
    final group = recruitmentGroups.firstWhere((g) => g.id == groupId);
    // For now, show all members (in real implementation, filter by group membership)
  }

  void markMessagesAsRead(String groupId) {
    // Mark messages as read and reset unread count
    final groupIndex = recruitmentGroups.indexWhere((g) => g.id == groupId);
    if (groupIndex != -1) {
      recruitmentGroups[groupIndex] = recruitmentGroups[groupIndex].copyWith(
        unreadCount: 0,
      );
      filteredGroups.value = List.from(recruitmentGroups);
      filterGroups();
    }
  }

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty || selectedGroupId.value.isEmpty) return;

    final message = GroupMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'current_user',
      senderName: 'You',
      content: content,
      timestamp: DateTime.now(),
      type: MessageType.text,
    );

    groupMessages.add(message);
    messageController.clear();

    // Update group's last message
    final groupIndex = recruitmentGroups.indexWhere(
      (g) => g.id == selectedGroupId.value,
    );
    if (groupIndex != -1) {
      recruitmentGroups[groupIndex] = recruitmentGroups[groupIndex].copyWith(
        lastMessage: message,
      );
      filterGroups();
    }

    // Simulate message sending
    await Future.delayed(Duration(milliseconds: 500));
  }

  Future<void> createGroup({
    required String name,
    required String description,
    required String type,
    required List<String> memberIds,
    required bool isPrivate,
  }) async {
    if (name.trim().isEmpty) {
      Get.snackbar('Error', 'Group name is required');
      return;
    }

    isLoading.value = true;

    try {
      await Future.delayed(Duration(seconds: 1));

      final newGroup = RecruitmentGroup(
        id: 'group_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        description: description,
        type: type,
        avatar: 'https://example.com/default_avatar.jpg',
        memberCount: memberIds.length + 1,
        // +1 for creator
        onlineCount: 1,
        lastMessage: GroupMessage(
          id: 'welcome_msg',
          senderId: 'system',
          senderName: 'System',
          content: 'Group created successfully!',
          timestamp: DateTime.now(),
          type: MessageType.system,
        ),
        createdBy: 'current_user',
        createdAt: DateTime.now(),
        isPrivate: isPrivate,
        unreadCount: 0,
        isPinned: false,
        status: GroupStatus.active,
      );

      recruitmentGroups.insert(0, newGroup);
      filterGroups();

      // Clear form
      groupNameController.clear();
      groupDescriptionController.clear();
      isCreateGroupMode.value = false;

      Get.snackbar(
        'Success',
        'Group "$name" created successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to create group. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addMembersToGroup(String groupId, List<String> memberIds) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));

      final groupIndex = recruitmentGroups.indexWhere((g) => g.id == groupId);
      if (groupIndex != -1) {
        final currentGroup = recruitmentGroups[groupIndex];
        recruitmentGroups[groupIndex] = currentGroup.copyWith(
          memberCount: currentGroup.memberCount + memberIds.length,
        );

        // Add system message
        final systemMessage = GroupMessage(
          id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
          senderId: 'system',
          senderName: 'System',
          content: '${memberIds.length} member(s) added to the group',
          timestamp: DateTime.now(),
          type: MessageType.system,
        );

        groupMessages.add(systemMessage);
        filterGroups();
      }

      Get.snackbar(
        'Success',
        '${memberIds.length} member(s) added to group',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to add members');
    }
  }

  Future<void> leaveGroup(String groupId) async {
    Get.dialog(
      AlertDialog(
        title: Text('Leave Group'),
        content: Text('Are you sure you want to leave this group?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Get.back();

              try {
                await Future.delayed(Duration(milliseconds: 500));
                recruitmentGroups.removeWhere((g) => g.id == groupId);
                filterGroups();

                if (selectedGroupId.value == groupId) {
                  selectedGroupId.value = '';
                }

                Get.snackbar(
                  'Left Group',
                  'You have left the group',
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                );
              } catch (e) {
                Get.snackbar('Error', 'Failed to leave group');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Leave'),
          ),
        ],
      ),
    );
  }

  void togglePinGroup(String groupId) {
    final groupIndex = recruitmentGroups.indexWhere((g) => g.id == groupId);
    if (groupIndex != -1) {
      final currentGroup = recruitmentGroups[groupIndex];
      recruitmentGroups[groupIndex] = currentGroup.copyWith(
        isPinned: !currentGroup.isPinned,
      );
      filterGroups();
    }
  }

  void toggleMuteGroup(String groupId) {
    // Toggle mute functionality
    Get.snackbar(
      'Group Muted',
      'You will no longer receive notifications from this group',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  void deleteMessage(String messageId) {
    groupMessages.removeWhere((msg) => msg.id == messageId);
    Get.snackbar('Message Deleted', 'Message has been deleted');
  }

  void addReaction(String messageId, String emoji) {
    final messageIndex = groupMessages.indexWhere((msg) => msg.id == messageId);
    if (messageIndex != -1) {
      final message = groupMessages[messageIndex];
      final reactions = Map<String, List<String>>.from(message.reactions);

      if (reactions.containsKey(emoji)) {
        if (reactions[emoji]!.contains('current_user')) {
          reactions[emoji]!.remove('current_user');
          if (reactions[emoji]!.isEmpty) {
            reactions.remove(emoji);
          }
        } else {
          reactions[emoji]!.add('current_user');
        }
      } else {
        reactions[emoji] = ['current_user'];
      }

      groupMessages[messageIndex] = message.copyWith(reactions: reactions);
    }
  }

  void startTyping() {
    if (!isTyping.value) {
      isTyping.value = true;
      // Simulate typing indicator timeout
      Future.delayed(Duration(seconds: 3), () {
        isTyping.value = false;
      });
    }
  }

  void _startRealTimeUpdates() {
    // Simulate real-time updates every 30 seconds
    Timer.periodic(Duration(seconds: 30), (timer) {
      if (recruitmentGroups.isNotEmpty) {
        // Simulate new message in random group
        final randomGroup =
            recruitmentGroups[DateTime.now().millisecond %
                recruitmentGroups.length];
        final randomMember =
            groupMembers[DateTime.now().millisecond % groupMembers.length];

        final newMessage = GroupMessage(
          id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
          senderId: randomMember.id,
          senderName: randomMember.name,
          content: _getRandomMessage(),
          timestamp: DateTime.now(),
          type: MessageType.text,
        );

        // Update group's last message and unread count
        final groupIndex = recruitmentGroups.indexWhere(
          (g) => g.id == randomGroup.id,
        );
        if (groupIndex != -1) {
          recruitmentGroups[groupIndex] = recruitmentGroups[groupIndex]
              .copyWith(
                lastMessage: newMessage,
                unreadCount: randomGroup.id != selectedGroupId.value
                    ? randomGroup.unreadCount + 1
                    : 0,
              );
          filterGroups();
        }

        // If this is the selected group, add to messages
        if (randomGroup.id == selectedGroupId.value) {
          groupMessages.add(newMessage);
        }
      }
    });
  }

  String _getMockMessageContent(int index) {
    final messages = [
      'Great work on the recent interviews!',
      'Can we schedule a quick sync meeting?',
      'I\'ve shared the candidate profiles in the files section',
      'The new job posting is now live',
      'Interview feedback has been submitted',
      'Let\'s discuss the recruitment strategy for next quarter',
      'Campus visit was very successful',
      'Need help with candidate evaluation',
      'Training session scheduled for tomorrow',
      'Policy updates have been shared',
    ];
    return messages[index % messages.length];
  }

  String _getRandomMessage() {
    final messages = [
      'Quick update on today\'s interviews',
      'New candidates added to the pipeline',
      'Meeting room is booked for the panel discussion',
      'Interview scores have been updated',
      'Great turnout at the career fair!',
    ];
    return messages[DateTime.now().millisecond % messages.length];
  }

  void showCreateGroupDialog() {
    isCreateGroupMode.value = true;
  }

  void hideCreateGroupDialog() {
    isCreateGroupMode.value = false;
    groupNameController.clear();
    groupDescriptionController.clear();
  }
}

// Model Classes and Enums
enum MessageType { text, image, file, voice, video, system }

enum GroupStatus { active, archived, suspended }

class RecruitmentGroup {
  final String id;
  final String name;
  final String description;
  final String type;
  final String avatar;
  final int memberCount;
  final int onlineCount;
  final GroupMessage lastMessage;
  final String createdBy;
  final DateTime createdAt;
  final bool isPrivate;
  final int unreadCount;
  final bool isPinned;
  final GroupStatus status;

  RecruitmentGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.avatar,
    required this.memberCount,
    required this.onlineCount,
    required this.lastMessage,
    required this.createdBy,
    required this.createdAt,
    required this.isPrivate,
    required this.unreadCount,
    required this.isPinned,
    required this.status,
  });

  RecruitmentGroup copyWith({
    String? id,
    String? name,
    String? description,
    String? type,
    String? avatar,
    int? memberCount,
    int? onlineCount,
    GroupMessage? lastMessage,
    String? createdBy,
    DateTime? createdAt,
    bool? isPrivate,
    int? unreadCount,
    bool? isPinned,
    GroupStatus? status,
  }) {
    return RecruitmentGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      avatar: avatar ?? this.avatar,
      memberCount: memberCount ?? this.memberCount,
      onlineCount: onlineCount ?? this.onlineCount,
      lastMessage: lastMessage ?? this.lastMessage,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      isPrivate: isPrivate ?? this.isPrivate,
      unreadCount: unreadCount ?? this.unreadCount,
      isPinned: isPinned ?? this.isPinned,
      status: status ?? this.status,
    );
  }
}

class GroupMember {
  final String id;
  final String name;
  final String email;
  final String role;
  final String avatar;
  final bool isOnline;
  final DateTime lastSeen;
  final DateTime joinedAt;
  final List<String> permissions;

  GroupMember({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.avatar,
    required this.isOnline,
    required this.lastSeen,
    required this.joinedAt,
    required this.permissions,
  });

  GroupMember copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? avatar,
    bool? isOnline,
    DateTime? lastSeen,
    DateTime? joinedAt,
    List<String>? permissions,
  }) {
    return GroupMember(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      avatar: avatar ?? this.avatar,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      joinedAt: joinedAt ?? this.joinedAt,
      permissions: permissions ?? this.permissions,
    );
  }
}

class GroupMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime timestamp;
  final MessageType type;
  final Map<String, List<String>> reactions;
  final String? replyTo;
  final List<String>? attachments;

  GroupMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.timestamp,
    required this.type,
    this.reactions = const {},
    this.replyTo,
    this.attachments,
  });

  GroupMessage copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? content,
    DateTime? timestamp,
    MessageType? type,
    Map<String, List<String>>? reactions,
    String? replyTo,
    List<String>? attachments,
  }) {
    return GroupMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      reactions: reactions ?? this.reactions,
      replyTo: replyTo ?? this.replyTo,
      attachments: attachments ?? this.attachments,
    );
  }
}

class GroupActivity {
  final String id;
  final String type;
  final String description;
  final String userId;
  final String userName;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  GroupActivity({
    required this.id,
    required this.type,
    required this.description,
    required this.userId,
    required this.userName,
    required this.timestamp,
    this.metadata,
  });

  GroupActivity copyWith({
    String? id,
    String? type,
    String? description,
    String? userId,
    String? userName,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
  }) {
    return GroupActivity(
      id: id ?? this.id,
      type: type ?? this.type,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
    );
  }
}
