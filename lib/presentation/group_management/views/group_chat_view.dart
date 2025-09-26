import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/group_management.controller.dart';

class GroupChatView extends GetView<GroupManagementController> {
  const GroupChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedGroup = controller.recruitmentGroups.firstWhereOrNull(
        (g) => g.id == controller.selectedGroupId.value,
      );

      if (selectedGroup == null) {
        return Center(child: Text('Group not found'));
      }

      return Column(
        children: [
          // Chat Header
          _buildChatHeader(selectedGroup),

          // Messages Area
          Expanded(child: _buildMessagesArea()),

          // Message Input
          _buildMessageInput(),
        ],
      );
    });
  }

  Widget _buildChatHeader(RecruitmentGroup group) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Row(
        children: [
          // Group Avatar
          Stack(
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

          SizedBox(width: 12),

          // Group Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      group.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(width: 8),
                    if (group.isPrivate)
                      Icon(
                        Icons.lock_outlined,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                    if (group.isPinned)
                      Icon(Icons.push_pin, size: 14, color: Colors.orange[600]),
                  ],
                ),

                Text(
                  '${group.memberCount} members • ${group.onlineCount} online',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Header Actions
          Row(
            children: [
              IconButton(
                onPressed: () => _startVideoCall(group),
                icon: Icon(Icons.video_call_outlined),
                tooltip: 'Start Video Call',
              ),

              IconButton(
                onPressed: () => _startVoiceCall(group),
                icon: Icon(Icons.call_outlined),
                tooltip: 'Start Voice Call',
              ),

              IconButton(
                onPressed: () => _showChatSettings(group),
                icon: Icon(Icons.more_vert_outlined),
                tooltip: 'Chat Settings',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesArea() {
    return Container(
      color: Colors.grey[50],
      child: Obx(() {
        if (controller.groupMessages.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 64,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16),
                Text(
                  'No messages yet',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                Text(
                  'Start the conversation!',
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: controller.groupMessages.length,
          itemBuilder: (context, index) {
            final message = controller.groupMessages[index];
            final isCurrentUser = message.senderId == 'current_user';
            final showAvatar =
                index == 0 ||
                controller.groupMessages[index - 1].senderId !=
                    message.senderId;

            return _buildMessageBubble(message, isCurrentUser, showAvatar);
          },
        );
      }),
    );
  }

  Widget _buildMessageBubble(
    GroupMessage message,
    bool isCurrentUser,
    bool showAvatar,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isCurrentUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          // Avatar (for other users)
          if (!isCurrentUser) ...[
            if (showAvatar)
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey[300],
                child: Text(
                  message.senderName[0].toUpperCase(),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              )
            else
              SizedBox(width: 32),
            SizedBox(width: 8),
          ],

          // Message Content
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: 300),
              child: Column(
                crossAxisAlignment: isCurrentUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  // Sender name (for other users)
                  if (!isCurrentUser && showAvatar) ...[
                    Text(
                      message.senderName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 2),
                  ],

                  // Message bubble
                  GestureDetector(
                    onLongPress: () => _showMessageOptions(message),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _getMessageBubbleColor(message, isCurrentUser),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Reply indicator
                          if (message.replyTo != null) ...[
                            Container(
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Replying to previous message',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontStyle: FontStyle.italic,
                                  color: isCurrentUser
                                      ? Colors.white70
                                      : Colors.grey[600],
                                ),
                              ),
                            ),
                          ],

                          // Message content
                          _buildMessageContent(message, isCurrentUser),

                          // Timestamp
                          Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              _formatMessageTime(message.timestamp),
                              style: TextStyle(
                                fontSize: 10,
                                color: isCurrentUser
                                    ? Colors.white70
                                    : Colors.grey[500],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Reactions
                  if (message.reactions.isNotEmpty) ...[
                    SizedBox(height: 4),
                    _buildReactionsRow(message),
                  ],
                ],
              ),
            ),
          ),

          // Avatar (for current user)
          if (isCurrentUser) ...[
            SizedBox(width: 8),
            if (showAvatar)
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.blue[100],
                child: Text(
                  'You'[0].toUpperCase(),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              )
            else
              SizedBox(width: 32),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageContent(GroupMessage message, bool isCurrentUser) {
    switch (message.type) {
      case MessageType.text:
        return Text(
          message.content,
          style: TextStyle(
            fontSize: 14,
            color: isCurrentUser ? Colors.white : Colors.grey[800],
          ),
        );

      case MessageType.file:
        return Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.attach_file_outlined,
                size: 16,
                color: isCurrentUser ? Colors.white70 : Colors.grey[600],
              ),
              SizedBox(width: 4),
              Text(
                message.content,
                // Using content instead of fileName since fileName property doesn't exist
                style: TextStyle(
                  fontSize: 12,
                  color: isCurrentUser ? Colors.white70 : Colors.grey[600],
                ),
              ),
            ],
          ),
        );

      case MessageType.system:
        return Text(
          message.content,
          style: TextStyle(
            fontSize: 12,
            fontStyle: FontStyle.italic,
            color: Colors.grey[600],
          ),
        );

      case MessageType.announcement:
        return Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.campaign_outlined,
                size: 16,
                color: Colors.orange[700],
              ),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  message.content,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.orange[700],
                  ),
                ),
              ),
            ],
          ),
        );

      default:
        return Text(message.content);
    }
  }

  Widget _buildReactionsRow(GroupMessage message) {
    return Wrap(
      spacing: 4,
      children: message.reactions.entries.map((entry) {
        final emoji = entry.key;
        final users = entry.value;
        final hasCurrentUserReacted = users.contains('current_user');

        return GestureDetector(
          onTap: () => controller.addReaction(message.id, emoji),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: hasCurrentUserReacted
                  ? Colors.blue[100]
                  : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: hasCurrentUserReacted
                  ? Border.all(color: Colors.blue[300]!)
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji, style: TextStyle(fontSize: 12)),
                SizedBox(width: 2),
                Text(
                  users.length.toString(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: hasCurrentUserReacted
                        ? Colors.blue[700]
                        : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Column(
        children: [
          // Typing indicator
          Obx(() {
            if (controller.typingUsers.isNotEmpty) {
              return Container(
                padding: EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.more_horiz, size: 16, color: Colors.grey[500]),
                    SizedBox(width: 4),
                    Text(
                      '${controller.typingUsers.join(', ')} typing...',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }
            return SizedBox.shrink();
          }),

          // Input row
          Row(
            children: [
              // Attachment button
              IconButton(
                onPressed: () => _showAttachmentOptions(),
                icon: Icon(Icons.attach_file_outlined),
                tooltip: 'Attach file',
              ),

              // Message input
              Expanded(
                child: TextField(
                  controller: controller.messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  maxLines: null,
                  onChanged: (text) {
                    if (text.isNotEmpty) {
                      controller.startTyping();
                    }
                  },
                  onSubmitted: (text) {
                    if (text.trim().isNotEmpty) {
                      controller.sendMessage(text);
                    }
                  },
                ),
              ),

              SizedBox(width: 8),

              // Emoji button
              IconButton(
                onPressed: () => _showEmojiPicker(),
                icon: Icon(Icons.emoji_emotions_outlined),
                tooltip: 'Add emoji',
              ),

              // Send button
              Obx(
                () => IconButton(
                  onPressed: controller.messageController.text.trim().isNotEmpty
                      ? () => controller.sendMessage(
                          controller.messageController.text,
                        )
                      : null,
                  icon: Icon(Icons.send_outlined),
                  color: Colors.blue[600],
                  tooltip: 'Send message',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getMessageBubbleColor(GroupMessage message, bool isCurrentUser) {
    switch (message.type) {
      case MessageType.system:
        return Colors.grey[200]!;
      case MessageType.announcement:
        return Colors.orange[50]!;
      default:
        return isCurrentUser ? Colors.blue[600]! : Colors.white;
    }
  }

  String _formatMessageTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${timestamp.day}/${timestamp.month} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }

  void _startVideoCall(RecruitmentGroup group) {
    Get.snackbar(
      'Video Call',
      'Starting video call with ${group.name}...',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _startVoiceCall(RecruitmentGroup group) {
    Get.snackbar(
      'Voice Call',
      'Starting voice call with ${group.name}...',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void _showChatSettings(RecruitmentGroup group) {
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
              'Chat Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            ListTile(
              leading: Icon(Icons.search_outlined),
              title: Text('Search Messages'),
              onTap: () {
                Get.back();
                // Implement message search
              },
            ),

            ListTile(
              leading: Icon(Icons.image_outlined),
              title: Text('Media & Files'),
              onTap: () {
                Get.back();
                // Show media gallery
              },
            ),

            ListTile(
              leading: Icon(Icons.notifications_outlined),
              title: Text('Notifications'),
              trailing: Switch(
                value: controller.isNotificationsEnabled.value,
                onChanged: (value) {
                  controller.isNotificationsEnabled.value = value;
                },
              ),
              onTap: () {},
            ),

            ListTile(
              leading: Icon(Icons.clear_all_outlined),
              title: Text('Clear Chat'),
              onTap: () {
                Get.back();
                _showClearChatDialog(group);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showMessageOptions(GroupMessage message) {
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
            // Message preview
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                message.content,
                style: TextStyle(fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            SizedBox(height: 16),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMessageAction(Icons.reply_outlined, 'Reply', () {
                  Get.back();
                  // Implement reply
                }),

                _buildMessageAction(Icons.content_copy_outlined, 'Copy', () {
                  Get.back();
                  // Copy to clipboard
                  Get.snackbar('Copied', 'Message copied to clipboard');
                }),

                _buildMessageAction(Icons.emoji_emotions_outlined, 'React', () {
                  Get.back();
                  _showQuickReactions(message);
                }),

                if (message.senderId == 'current_user')
                  _buildMessageAction(Icons.delete_outline, 'Delete', () {
                    Get.back();
                    controller.deleteMessage(message.id);
                  }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageAction(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Colors.grey[600]),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  void _showQuickReactions(GroupMessage message) {
    final reactions = ['👍', '❤️', '😂', '😮', '😢', '😡'];

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
              'React to message',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 16),

            Wrap(
              spacing: 16,
              children: reactions.map((emoji) {
                return GestureDetector(
                  onTap: () {
                    Get.back();
                    controller.addReaction(message.id, emoji);
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(emoji, style: TextStyle(fontSize: 24)),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttachmentOptions() {
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
              'Share',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                  Icons.photo_outlined,
                  'Photo',
                  Colors.green,
                  () {
                    Get.back();
                    // Implement photo sharing
                  },
                ),

                _buildAttachmentOption(
                  Icons.insert_drive_file_outlined,
                  'Document',
                  Colors.blue,
                  () {
                    Get.back();
                    // Implement document sharing
                  },
                ),

                _buildAttachmentOption(
                  Icons.location_on_outlined,
                  'Location',
                  Colors.red,
                  () {
                    Get.back();
                    // Implement location sharing
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),

          SizedBox(height: 8),

          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  void _showEmojiPicker() {
    // Implement emoji picker
    Get.snackbar(
      'Emoji Picker',
      'Emoji picker coming soon!',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void _showClearChatDialog(RecruitmentGroup group) {
    Get.dialog(
      AlertDialog(
        title: Text('Clear Chat'),
        content: Text(
          'Are you sure you want to clear all messages in ${group.name}? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.groupMessages.clear();
              Get.snackbar('Chat Cleared', 'All messages have been cleared');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Clear'),
          ),
        ],
      ),
    );
  }
}
