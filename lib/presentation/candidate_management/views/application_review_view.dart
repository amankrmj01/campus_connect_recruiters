import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/candidate_management.controller.dart';

class ApplicationReviewView extends GetView<CandidateManagementController> {
  const ApplicationReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: Column(
        children: [
          // Header
          _buildHeader(),

          // Review Interface
          Expanded(
            child: Row(
              children: [
                // Applications List
                Expanded(flex: 1, child: _buildApplicationsList()),

                // Review Panel
                Expanded(flex: 2, child: _buildReviewPanel()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Icon(Icons.assignment_outlined, size: 24, color: Colors.blue[600]),
          SizedBox(width: 12),
          Text(
            'Application Review',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          Spacer(),
          Chip(
            label: Text(
              '${controller.filteredCandidates.where((c) => c.status == CandidateStatus.active && !c.isShortlisted).length} Pending Review',
            ),
            backgroundColor: Colors.orange[100],
            labelStyle: TextStyle(color: Colors.orange[800]),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationsList() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Pending Applications',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),

          Expanded(
            child: Obx(() {
              final pendingCandidates = controller.filteredCandidates
                  .where(
                    (c) =>
                        c.status == CandidateStatus.active && !c.isShortlisted,
                  )
                  .toList();

              if (pendingCandidates.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outlined,
                        size: 64,
                        color: Colors.green[300],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'All applications reviewed!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Great job keeping up with applications',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: pendingCandidates.length,
                separatorBuilder: (context, index) => Divider(height: 1),
                itemBuilder: (context, index) {
                  final candidate = pendingCandidates[index];
                  return _buildApplicationItem(candidate);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationItem(CandidateModel candidate) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(candidate.profilePicture),
        onBackgroundImageError: (_, __) {},
        child: candidate.profilePicture.isEmpty
            ? Icon(Icons.person_outlined)
            : null,
      ),
      title: Text(
        candidate.name,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${candidate.department} • ${candidate.college}',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.star_outline, size: 14, color: Colors.grey[500]),
              SizedBox(width: 2),
              Text(
                'CGPA: ${candidate.cgpa}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              SizedBox(width: 12),
              Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
              SizedBox(width: 2),
              Text(
                _getLastActiveText(candidate.lastActive),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.orange[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Review',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.orange[800],
          ),
        ),
      ),
      onTap: () => controller.viewCandidateProfile(candidate),
    );
  }

  Widget _buildReviewPanel() {
    return Container(
      margin: EdgeInsets.only(left: 1),
      color: Colors.white,
      child: Obx(() {
        if (controller.selectedCandidate.value == null) {
          return _buildSelectCandidatePrompt();
        }

        return _buildCandidateReviewDetails(
          controller.selectedCandidate.value!,
        );
      }),
    );
  }

  Widget _buildSelectCandidatePrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 64, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text(
            'Select an application to review',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Text(
            'Choose a candidate from the list to view their profile and application details',
            style: TextStyle(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCandidateReviewDetails(CandidateModel candidate) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Actions
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(candidate.profilePicture),
                onBackgroundImageError: (_, __) {},
                child: candidate.profilePicture.isEmpty
                    ? Icon(Icons.person_outlined, size: 30)
                    : null,
              ),

              SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      candidate.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      candidate.email,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${candidate.department} • ${candidate.college}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              // Action Buttons
              Row(
                children: [
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

                  SizedBox(width: 12),

                  OutlinedButton.icon(
                    onPressed: () {
                      controller.selectedCandidates.clear();
                      controller.selectedCandidates.add(candidate.id);
                      controller.rejectCandidates();
                    },
                    icon: Icon(Icons.close_outlined, size: 16),
                    label: Text('Reject'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red[600],
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 24),

          // Key Metrics
          Row(
            children: [
              _buildMetricCard(
                'CGPA',
                candidate.cgpa.toString(),
                Icons.star_outlined,
                _getCGPAColor(candidate.cgpa),
              ),
              SizedBox(width: 16),
              _buildMetricCard(
                'Response Rate',
                '${candidate.responseRate.toStringAsFixed(0)}%',
                Icons.trending_up_outlined,
                Colors.blue,
              ),
              SizedBox(width: 16),
              _buildMetricCard(
                'Applications',
                candidate.appliedJobs.toString(),
                Icons.assignment_outlined,
                Colors.purple,
              ),
            ],
          ),

          SizedBox(height: 24),

          // Candidate Details
          _buildSectionTitle('Profile Information'),
          SizedBox(height: 12),
          _buildInfoCard([
            _buildInfoRow('Phone', candidate.phone),
            _buildInfoRow('Location', candidate.location),
            _buildInfoRow('Experience', candidate.experience),
            _buildInfoRow(
              'Graduation Year',
              candidate.graduationYear.toString(),
            ),
            _buildInfoRow(
              'Last Active',
              _getLastActiveText(candidate.lastActive),
            ),
          ]),

          SizedBox(height: 20),

          // Skills
          _buildSectionTitle('Skills & Technologies'),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: candidate.skills.map((skill) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Text(
                  skill,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue[700],
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 20),

          // Application History
          _buildSectionTitle('Application History'),
          SizedBox(height: 12),
          Obx(() => _buildApplicationHistoryCard()),

          SizedBox(height: 20),

          // Notes Section
          _buildSectionTitle('Recruiter Notes'),
          SizedBox(height: 12),
          _buildNotesSection(candidate),

          SizedBox(height: 20),

          // Communication History
          _buildSectionTitle('Communication History'),
          SizedBox(height: 12),
          Obx(() => _buildCommunicationHistory()),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: color.withOpacity(0.8)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey[800])),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationHistoryCard() {
    if (controller.candidateApplications.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text('No application history available'),
      );
    }

    return Column(
      children: controller.candidateApplications.map((application) {
        return Container(
          margin: EdgeInsets.only(bottom: 8),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      application.jobTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      application.company,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Applied: ${_formatDate(application.appliedDate)}',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                    application.currentRound,
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNotesSection(CandidateModel candidate) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller.notesController,
            decoration: InputDecoration(
              hintText: 'Add a note about this candidate...',
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
        ],
      ),
    );
  }

  Widget _buildCommunicationHistory() {
    if (controller.candidateInteractions.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text('No communication history'),
      );
    }

    return Column(
      children: controller.candidateInteractions.map((interaction) {
        return Container(
          margin: EdgeInsets.only(bottom: 8),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
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
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 8),
                  Text(
                    interaction.type,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                      fontSize: 13,
                    ),
                  ),
                  Spacer(),
                  Text(
                    _formatDate(interaction.timestamp),
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                interaction.message,
                style: TextStyle(color: Colors.grey[700], fontSize: 14),
              ),
              SizedBox(height: 4),
              Text(
                'by ${interaction.recruiter}',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ),
        );
      }).toList(),
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
}
