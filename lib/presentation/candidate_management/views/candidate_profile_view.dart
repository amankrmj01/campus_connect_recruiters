import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/candidate_management.controller.dart';

class CandidateProfileView extends GetView<CandidateManagementController> {
  const CandidateProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final candidate = controller.selectedCandidate.value;
      if (candidate == null) return SizedBox.shrink();

      return Container(
        color: Colors.grey[50],
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader(candidate),

            // Content Area
            Expanded(
              child: Row(
                children: [
                  // Main Profile Content
                  Expanded(flex: 2, child: _buildProfileContent(candidate)),

                  // Action Sidebar
                  Container(
                    width: 300,
                    color: Colors.white,
                    child: _buildActionSidebar(candidate),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildProfileHeader(CandidateModel candidate) {
    return Container(
      padding: EdgeInsets.all(24),
      color: Colors.white,
      child: Column(
        children: [
          // Back Button and Actions Row
          Row(
            children: [
              IconButton(
                onPressed: () => controller.selectedCandidate.value = null,
                icon: Icon(Icons.arrow_back_outlined),
                tooltip: 'Back to list',
              ),
              SizedBox(width: 12),
              Text(
                'Candidate Profile',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Spacer(),

              // Quick Actions
              Row(
                children: [
                  IconButton(
                    onPressed: () => controller.addToWatchlist(candidate.id),
                    icon: Icon(
                      candidate.isWatchlisted
                          ? Icons.bookmark
                          : Icons.bookmark_outline,
                      color: candidate.isWatchlisted
                          ? Colors.purple[600]
                          : Colors.grey[400],
                    ),
                    tooltip: candidate.isWatchlisted
                        ? 'Remove from Watchlist'
                        : 'Add to Watchlist',
                  ),

                  SizedBox(width: 8),

                  ElevatedButton.icon(
                    onPressed: () => _showMessageDialog(candidate),
                    icon: Icon(Icons.message_outlined, size: 16),
                    label: Text('Message'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                    ),
                  ),

                  SizedBox(width: 12),

                  ElevatedButton.icon(
                    onPressed: () {
                      controller.selectedCandidates.clear();
                      controller.selectedCandidates.add(candidate.id);
                      controller.shortlistCandidates();
                    },
                    icon: Icon(Icons.star_outlined, size: 16),
                    label: Text('Shortlist'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 24),

          // Profile Summary Row
          Row(
            children: [
              // Profile Picture
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(candidate.profilePicture),
                onBackgroundImageError: (_, __) {},
                child: candidate.profilePicture.isEmpty
                    ? Icon(Icons.person_outlined, size: 40)
                    : null,
              ),

              SizedBox(width: 20),

              // Basic Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          candidate.name,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(width: 12),
                        _buildStatusBadge(candidate.status),
                        if (candidate.isShortlisted) ...[
                          SizedBox(width: 8),
                          Icon(Icons.star, color: Colors.orange[600], size: 20),
                        ],
                        if (candidate.isWatchlisted) ...[
                          SizedBox(width: 8),
                          Icon(
                            Icons.bookmark,
                            color: Colors.purple[600],
                            size: 20,
                          ),
                        ],
                      ],
                    ),

                    SizedBox(height: 4),

                    Text(
                      candidate.email,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),

                    SizedBox(height: 8),

                    Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 16,
                          color: Colors.grey[500],
                        ),
                        SizedBox(width: 4),
                        Text(
                          candidate.phone,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        SizedBox(width: 20),
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Colors.grey[500],
                        ),
                        SizedBox(width: 4),
                        Text(
                          candidate.location,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),

                    SizedBox(height: 12),

                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: Text(
                            '${candidate.department}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.green[200]!),
                          ),
                          child: Text(
                            '${candidate.college}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.green[700],
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getCGPAColor(
                              candidate.cgpa,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _getCGPAColor(
                                candidate.cgpa,
                              ).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            'CGPA: ${candidate.cgpa}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _getCGPAColor(candidate.cgpa),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Quick Stats
              Column(
                children: [
                  _buildQuickStat(
                    'Applications',
                    candidate.appliedJobs.toString(),
                    Colors.blue,
                  ),
                  SizedBox(height: 12),
                  _buildQuickStat(
                    'Response Rate',
                    '${candidate.responseRate.toStringAsFixed(0)}%',
                    Colors.green,
                  ),
                  SizedBox(height: 12),
                  _buildQuickStat(
                    'Graduation',
                    candidate.graduationYear.toString(),
                    Colors.orange,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: color.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(CandidateModel candidate) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Skills Section
          _buildSection(
            'Skills & Technologies',
            Icons.code_outlined,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: candidate.skills.map((skill) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Text(
                    skill,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue[700],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          SizedBox(height: 24),

          // Experience Section
          _buildSection(
            'Experience',
            Icons.work_outlined,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.business_center_outlined, color: Colors.grey[600]),
                  SizedBox(width: 12),
                  Text(
                    candidate.experience,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 24),

          // Application History Section
          _buildSection(
            'Application History',
            Icons.history_outlined,
            child: Obx(() => _buildApplicationHistory()),
          ),

          SizedBox(height: 24),

          // Performance Metrics
          _buildSection(
            'Performance Metrics',
            Icons.analytics_outlined,
            child: _buildPerformanceMetrics(candidate),
          ),

          SizedBox(height: 24),

          // Academic Information
          _buildSection(
            'Academic Information',
            Icons.school_outlined,
            child: _buildAcademicInfo(candidate),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, {required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildApplicationHistory() {
    if (controller.candidateApplications.isEmpty) {
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.inbox_outlined, size: 32, color: Colors.grey[400]),
              SizedBox(height: 8),
              Text(
                'No application history available',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: controller.candidateApplications.map((application) {
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          application.jobTitle,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          application.company,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            application.status,
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          application.status,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _getStatusColor(application.status),
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        _formatDate(application.appliedDate),
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 12),

              Row(
                children: [
                  Icon(
                    Icons.timeline_outlined,
                    size: 16,
                    color: Colors.grey[500],
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Current Stage: ${application.currentRound}',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPerformanceMetrics(CandidateModel candidate) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  'Response Rate',
                  '${candidate.responseRate.toStringAsFixed(0)}%',
                  Icons.trending_up_outlined,
                  Colors.green,
                ),
              ),
              Expanded(
                child: _buildMetricItem(
                  'Total Applications',
                  candidate.appliedJobs.toString(),
                  Icons.assignment_outlined,
                  Colors.blue,
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  'Last Active',
                  _getLastActiveText(candidate.lastActive),
                  Icons.access_time_outlined,
                  Colors.orange,
                ),
              ),
              Expanded(
                child: _buildMetricItem(
                  'Profile Score',
                  '${(candidate.cgpa * 10).toInt()}%',
                  Icons.star_outlined,
                  Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: color.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicInfo(CandidateModel candidate) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildInfoRow('College', candidate.college),
          _buildInfoRow('Department', candidate.department),
          _buildInfoRow('CGPA', candidate.cgpa.toString()),
          _buildInfoRow('Graduation Year', candidate.graduationYear.toString()),
          _buildInfoRow(
            'Registration Number',
            candidate.phone,
          ), // Mock reg number
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionSidebar(CandidateModel candidate) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Actions
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),

          SizedBox(height: 12),

          _buildActionButton(
            'Shortlist Candidate',
            Icons.star_outlined,
            Colors.green,
            () {
              controller.selectedCandidates.clear();
              controller.selectedCandidates.add(candidate.id);
              controller.shortlistCandidates();
            },
          ),

          SizedBox(height: 8),

          _buildActionButton(
            'Send Message',
            Icons.message_outlined,
            Colors.blue,
            () => _showMessageDialog(candidate),
          ),

          SizedBox(height: 8),

          _buildActionButton(
            candidate.isWatchlisted
                ? 'Remove from Watchlist'
                : 'Add to Watchlist',
            candidate.isWatchlisted ? Icons.bookmark : Icons.bookmark_outline,
            Colors.purple,
            () => controller.addToWatchlist(candidate.id),
          ),

          SizedBox(height: 8),

          _buildActionButton(
            'Reject Candidate',
            Icons.close_outlined,
            Colors.red,
            () {
              controller.selectedCandidates.clear();
              controller.selectedCandidates.add(candidate.id);
              controller.rejectCandidates();
            },
          ),

          SizedBox(height: 24),

          // Communication History
          Text(
            'Communication',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),

          SizedBox(height: 12),

          // Add Note
          TextField(
            controller: controller.notesController,
            decoration: InputDecoration(
              labelText: 'Add a note',
              hintText: 'Write a note about this candidate...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.send_outlined),
                onPressed: () => controller.addNote(
                  candidate.id,
                  controller.notesController.text,
                ),
              ),
            ),
            maxLines: 3,
          ),

          SizedBox(height: 16),

          // Interaction History
          Text(
            'Recent Interactions',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),

          SizedBox(height: 8),

          Obx(() => _buildInteractionHistory()),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(text),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color.withOpacity(0.5)),
          padding: EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }

  Widget _buildInteractionHistory() {
    if (controller.candidateInteractions.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'No interactions yet',
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
      );
    }

    return Column(
      children: controller.candidateInteractions.take(5).map((interaction) {
        return Container(
          margin: EdgeInsets.only(bottom: 8),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    interaction.type == 'Email'
                        ? Icons.email_outlined
                        : Icons.note_outlined,
                    size: 14,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 6),
                  Text(
                    interaction.type,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  Spacer(),
                  Text(
                    _formatDate(interaction.timestamp),
                    style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                  ),
                ],
              ),

              SizedBox(height: 4),

              Text(
                interaction.message,
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              Text(
                'by ${interaction.recruiter}',
                style: TextStyle(fontSize: 10, color: Colors.grey[500]),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatusBadge(CandidateStatus status) {
    Color color;
    String text;

    switch (status) {
      case CandidateStatus.active:
        color = Colors.green;
        text = 'Active';
        break;
      case CandidateStatus.inactive:
        color = Colors.grey;
        text = 'Inactive';
        break;
      case CandidateStatus.rejected:
        color = Colors.red;
        text = 'Rejected';
        break;
      case CandidateStatus.hired:
        color = Colors.blue;
        text = 'Hired';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Color _getCGPAColor(double cgpa) {
    if (cgpa >= 9.0) return Colors.green;
    if (cgpa >= 8.0) return Colors.blue;
    if (cgpa >= 7.0) return Colors.orange;
    return Colors.red;
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'shortlisted':
        return Colors.green;
      case 'under review':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getLastActiveText(DateTime lastActive) {
    final diff = DateTime.now().difference(lastActive);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showMessageDialog(CandidateModel candidate) {
    Get.dialog(
      AlertDialog(
        title: Text('Send Message to ${candidate.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller.messageController,
              decoration: InputDecoration(
                labelText: 'Message',
                hintText: 'Type your message here...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              controller.sendMessage(
                candidate.id,
                controller.messageController.text,
              );
              Get.back();
            },
            child: Text('Send'),
          ),
        ],
      ),
    );
  }
}
