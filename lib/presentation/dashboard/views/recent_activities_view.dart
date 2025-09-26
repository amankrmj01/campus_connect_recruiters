import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/dashboard.controller.dart';

class RecentActivitiesView extends GetView<DashboardController> {
  const RecentActivitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).toInt()),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(Icons.history_outlined, color: Colors.blue[600]),
                SizedBox(width: 8),
                Text(
                  'Recent Activities',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Spacer(),
                TextButton(
                  onPressed: () => Get.toNamed('/activity-log'),
                  child: Text('View All'),
                ),
              ],
            ),
          ),

          // Tab Bar for different activity types
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    labelColor: Colors.blue[600],
                    unselectedLabelColor: Colors.grey[600],
                    indicatorColor: Colors.blue[600],
                    tabs: [
                      Tab(text: 'Applications'),
                      Tab(text: 'Interviews'),
                      Tab(text: 'Jobs'),
                    ],
                  ),

                  Container(
                    height: 400,
                    child: TabBarView(
                      children: [
                        _buildApplicationsTab(),
                        _buildInterviewsTab(),
                        _buildJobsTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationsTab() {
    return Obx(
      () => ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: controller.recentApplications.length,
        separatorBuilder: (context, index) => SizedBox(height: 12),
        itemBuilder: (context, index) {
          final application = controller.recentApplications[index];
          return _buildApplicationItem(application);
        },
      ),
    );
  }

  Widget _buildInterviewsTab() {
    return Obx(
      () => ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: controller.upcomingInterviews.length,
        separatorBuilder: (context, index) => SizedBox(height: 12),
        itemBuilder: (context, index) {
          final interview = controller.upcomingInterviews[index];
          return _buildInterviewItem(interview);
        },
      ),
    );
  }

  Widget _buildJobsTab() {
    return Obx(
      () => ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: controller.recentJobs.length,
        separatorBuilder: (context, index) => SizedBox(height: 12),
        itemBuilder: (context, index) {
          final job = controller.recentJobs[index];
          return _buildJobItem(job);
        },
      ),
    );
  }

  Widget _buildApplicationItem(ApplicationSummary application) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // Profile Picture Placeholder
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue[100],
            child: Text(
              application.candidateName[0].toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue[600],
              ),
            ),
          ),

          SizedBox(width: 12),

          // Application Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  application.candidateName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),

                Text(
                  'Applied for ${application.jobTitle}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),

                SizedBox(height: 4),

                Row(
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 12,
                      color: Colors.grey[500],
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${application.college} • CGPA: ${application.cgpa}',
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Status and Actions
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(
                    application.status,
                  ).withAlpha((0.1 * 255).toInt()),
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
                _formatTime(application.appliedDate),
                style: TextStyle(fontSize: 10, color: Colors.grey[500]),
              ),

              SizedBox(height: 8),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _viewApplicationDetails(application),
                    icon: Icon(Icons.visibility_outlined, size: 16),
                    tooltip: 'View Details',
                    constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                    padding: EdgeInsets.all(4),
                  ),
                  IconButton(
                    onPressed: () => _shortlistCandidate(application),
                    icon: Icon(Icons.star_outline, size: 16),
                    tooltip: 'Shortlist',
                    constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                    padding: EdgeInsets.all(4),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInterviewItem(InterviewSummary interview) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // Interview Type Icon
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getInterviewTypeColor(
                interview.interviewType,
              ).withAlpha((0.1 * 255).toInt()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getInterviewTypeIcon(interview.interviewType),
              color: _getInterviewTypeColor(interview.interviewType),
              size: 20,
            ),
          ),

          SizedBox(width: 12),

          // Interview Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  interview.candidateName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),

                Text(
                  '${interview.interviewType} - ${interview.jobTitle}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),

                SizedBox(height: 4),

                Row(
                  children: [
                    Icon(
                      Icons.person_outlined,
                      size: 12,
                      color: Colors.grey[500],
                    ),
                    SizedBox(width: 4),
                    Text(
                      'with ${interview.interviewer}',
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      interview.mode == 'Video Call'
                          ? Icons.videocam_outlined
                          : Icons.location_on_outlined,
                      size: 12,
                      color: Colors.grey[500],
                    ),
                    SizedBox(width: 4),
                    Text(
                      interview.mode,
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Schedule and Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getInterviewStatusColor(
                    interview.status,
                  ).withAlpha((0.1 * 255).toInt()),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  interview.status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _getInterviewStatusColor(interview.status),
                  ),
                ),
              ),

              SizedBox(height: 4),

              Text(
                _formatInterviewTime(interview.scheduledTime),
                style: TextStyle(fontSize: 10, color: Colors.grey[500]),
              ),

              SizedBox(height: 8),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _rescheduleInterview(interview),
                    icon: Icon(Icons.schedule_outlined, size: 16),
                    tooltip: 'Reschedule',
                    constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                    padding: EdgeInsets.all(4),
                  ),
                  IconButton(
                    onPressed: () => _joinInterview(interview),
                    icon: Icon(Icons.video_call_outlined, size: 16),
                    tooltip: 'Join',
                    constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                    padding: EdgeInsets.all(4),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJobItem(JobSummary job) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // Job Status Icon
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getJobStatusColor(
                job.status,
              ).withAlpha((0.1 * 255).toInt()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getJobStatusIcon(job.status),
              color: _getJobStatusColor(job.status),
              size: 20,
            ),
          ),

          SizedBox(width: 12),

          // Job Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        job.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(
                          job.priority,
                        ).withAlpha((0.1 * 255).toInt()),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        job.priority,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _getPriorityColor(job.priority),
                        ),
                      ),
                    ),
                  ],
                ),

                Text(
                  '${job.department} Department',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),

                SizedBox(height: 4),

                Row(
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 12,
                      color: Colors.grey[500],
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${job.applications} applications',
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                    SizedBox(width: 12),
                    Icon(
                      Icons.schedule_outlined,
                      size: 12,
                      color: Colors.grey[500],
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Deadline: ${_formatDeadline(job.deadline)}',
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Actions
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getJobStatusColor(
                    job.status,
                  ).withAlpha((0.1 * 255).toInt()),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  job.status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _getJobStatusColor(job.status),
                  ),
                ),
              ),

              SizedBox(height: 4),

              Text(
                _formatTime(job.postedDate),
                style: TextStyle(fontSize: 10, color: Colors.grey[500]),
              ),

              SizedBox(height: 8),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _editJob(job),
                    icon: Icon(Icons.edit_outlined, size: 16),
                    tooltip: 'Edit Job',
                    constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                    padding: EdgeInsets.all(4),
                  ),
                  IconButton(
                    onPressed: () => _viewJobApplications(job),
                    icon: Icon(Icons.people_outlined, size: 16),
                    tooltip: 'View Applications',
                    constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                    padding: EdgeInsets.all(4),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper Methods
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'shortlisted':
        return Colors.green;
      case 'under review':
        return Colors.orange;
      case 'interviewed':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getInterviewTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'technical round':
        return Colors.blue;
      case 'hr round':
        return Colors.green;
      case 'final round':
        return Colors.purple;
      default:
        return Colors.orange;
    }
  }

  IconData _getInterviewTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'technical round':
        return Icons.code_outlined;
      case 'hr round':
        return Icons.people_outlined;
      case 'final round':
        return Icons.check_circle_outlined;
      default:
        return Icons.question_answer_outlined;
    }
  }

  Color _getInterviewStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Color _getJobStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'draft':
        return Colors.orange;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  IconData _getJobStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Icons.play_circle_outlined;
      case 'draft':
        return Icons.edit_outlined;
      case 'closed':
        return Icons.pause_circle_outlined;
      default:
        return Icons.work_outlined;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  String _formatInterviewTime(DateTime time) {
    final diff = time.difference(DateTime.now());
    if (diff.inHours < 24) {
      return 'in ${diff.inHours}h';
    } else {
      return 'in ${diff.inDays}d';
    }
  }

  String _formatDeadline(DateTime deadline) {
    final diff = deadline.difference(DateTime.now());
    if (diff.inDays < 7) {
      return '${diff.inDays}d left';
    } else {
      return '${(diff.inDays / 7).floor()}w left';
    }
  }

  // Action Methods
  void _viewApplicationDetails(ApplicationSummary application) {
    Get.toNamed(
      '/candidate-management',
      arguments: {'candidateId': application.id},
    );
  }

  void _shortlistCandidate(ApplicationSummary application) {
    Get.snackbar(
      'Shortlisted',
      '${application.candidateName} has been shortlisted',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _rescheduleInterview(InterviewSummary interview) {
    Get.dialog(
      AlertDialog(
        title: Text('Reschedule Interview'),
        content: Text('Reschedule interview with ${interview.candidateName}?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () => Get.back(),
            child: Text('Reschedule'),
          ),
        ],
      ),
    );
  }

  void _joinInterview(InterviewSummary interview) {
    Get.snackbar(
      'Joining Interview',
      'Opening interview session with ${interview.candidateName}',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void _editJob(JobSummary job) {
    Get.toNamed('/job-management', arguments: {'jobId': job.id});
  }

  void _viewJobApplications(JobSummary job) {
    Get.toNamed('/candidate-management', arguments: {'jobId': job.id});
  }
}
