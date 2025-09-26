import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/job_management.controller.dart';

class JobDetailsView extends GetView<JobManagementController> {
  const JobDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final job = controller.allJobs.firstWhereOrNull(
        (j) => j.id == controller.selectedJobId.value,
      );

      if (job == null) {
        return _buildNoJobView();
      }

      return Container(
        color: Colors.grey[50],
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Job Header
              _buildJobHeader(job),

              SizedBox(height: 24),

              // Job Content
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Content
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        _buildJobDescription(job),
                        SizedBox(height: 16),
                        _buildJobRequirements(job),
                        SizedBox(height: 16),
                        _buildJobBenefits(job),
                      ],
                    ),
                  ),

                  SizedBox(width: 24),

                  // Side Panel
                  Expanded(
                    child: Column(
                      children: [
                        _buildJobStats(job),
                        SizedBox(height: 16),
                        _buildJobActions(job),
                        SizedBox(height: 16),
                        _buildApplicationsPreview(job),
                        SizedBox(height: 16),
                        _buildJobTimeline(job),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildNoJobView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.work_off_outlined, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'Job not found',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildJobHeader(JobPosting job) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      job.department,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(job.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _getStatusText(job.status),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(job.status),
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _getPriorityColor(job.priority),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        _getPriorityText(job.priority),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 16),

          // Job Details Row
          Wrap(
            spacing: 24,
            runSpacing: 8,
            children: [
              _buildJobDetail(Icons.work_outlined, job.jobType),
              _buildJobDetail(Icons.location_on_outlined, job.location),
              _buildJobDetail(Icons.schedule_outlined, job.experience),
              _buildJobDetail(
                Icons.calendar_today_outlined,
                _formatDate(job.postedDate),
              ),
              _buildJobDetail(
                Icons.access_time_outlined,
                'Expires ${_formatDate(job.deadline)}',
              ),
            ],
          ),

          SizedBox(height: 16),

          // Salary
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.attach_money_outlined,
                  size: 20,
                  color: Colors.green[600],
                ),
                SizedBox(width: 8),
                Text(
                  '₹${_formatSalary(job.salaryMin)} - ₹${_formatSalary(job.salaryMax)} LPA',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
                Spacer(),
                Text(
                  'Annually',
                  style: TextStyle(fontSize: 12, color: Colors.green[600]),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Tags
          if (job.tags.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: job.tags.map((tag) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildJobDetail(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey[500]),
        SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildJobDescription(JobPosting job) {
    return Container(
      padding: EdgeInsets.all(20),
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
                Icons.description_outlined,
                size: 20,
                color: Colors.blue[600],
              ),
              SizedBox(width: 8),
              Text(
                'Job Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          Text(
            job.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobRequirements(JobPosting job) {
    return Container(
      padding: EdgeInsets.all(20),
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
                Icons.checklist_outlined,
                size: 20,
                color: Colors.orange[600],
              ),
              SizedBox(width: 8),
              Text(
                'Requirements',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          Column(
            children: job.requirements.map((requirement) {
              return Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 6),
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.orange[600],
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        requirement,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildJobBenefits(JobPosting job) {
    return Container(
      padding: EdgeInsets.all(20),
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
              Icon(Icons.favorite_outlined, size: 20, color: Colors.green[600]),
              SizedBox(width: 8),
              Text(
                'Benefits & Perks',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          Column(
            children: job.benefits.map((benefit) {
              return Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outlined,
                      size: 16,
                      color: Colors.green[600],
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        benefit,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildJobStats(JobPosting job) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Job Statistics',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),

          SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  '${job.applicationsCount}',
                  'Applications',
                  Colors.blue,
                  Icons.people_outlined,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  '${job.viewsCount}',
                  'Views',
                  Colors.green,
                  Icons.visibility_outlined,
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  '${job.shortlistedCount}',
                  'Shortlisted',
                  Colors.orange,
                  Icons.star_outlined,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  '${(job.applicationsCount > 0 ? (job.shortlistedCount / job.applicationsCount * 100).toInt() : 0)}%',
                  'Conversion',
                  Colors.purple,
                  Icons.trending_up_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String value,
    String label,
    Color color,
    IconData icon,
  ) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
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
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildJobActions(JobPosting job) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),

          SizedBox(height: 16),

          Column(
            children: [
              _buildActionButton(
                Icons.people_outlined,
                'View Applications',
                'See all ${job.applicationsCount} applications',
                Colors.blue,
                () => _viewApplications(job),
              ),

              SizedBox(height: 8),

              _buildActionButton(
                Icons.edit_outlined,
                'Edit Job',
                'Modify job details',
                Colors.orange,
                () => _editJob(job),
              ),

              SizedBox(height: 8),

              _buildActionButton(
                Icons.share_outlined,
                'Share Job',
                'Copy job link',
                Colors.green,
                () => _shareJob(job),
              ),

              SizedBox(height: 8),

              if (job.status == JobStatus.draft)
                _buildActionButton(
                  Icons.publish_outlined,
                  'Publish Job',
                  'Make job live',
                  Colors.green,
                  () => controller.updateJobStatus(job.id, JobStatus.published),
                )
              else if (job.status == JobStatus.published)
                _buildActionButton(
                  Icons.pause_outlined,
                  'Pause Job',
                  'Put job on hold',
                  Colors.orange,
                  () => controller.updateJobStatus(job.id, JobStatus.onHold),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String title,
    String subtitle,
    Color color,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, size: 16, color: color),
            ),

            SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationsPreview(JobPosting job) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Applications',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              TextButton(
                onPressed: () => _viewApplications(job),
                child: Text('View All', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),

          SizedBox(height: 16),

          if (job.applicationsCount > 0)
            Column(
              children: List.generate(3, (index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey[300],
                        child: Text(
                          String.fromCharCode(65 + index),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      SizedBox(width: 8),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Candidate ${index + 1}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${index + 1} hours ago',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'New',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.blue[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            )
          else
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(Icons.people_outline, size: 32, color: Colors.grey[400]),
                  SizedBox(height: 8),
                  Text(
                    'No applications yet',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildJobTimeline(JobPosting job) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Job Timeline',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),

          SizedBox(height: 16),

          Column(
            children: [
              _buildTimelineItem(
                'Job Created',
                _formatDate(job.postedDate),
                Icons.add_circle_outlined,
                Colors.blue,
                isFirst: true,
              ),

              if (job.status != JobStatus.draft)
                _buildTimelineItem(
                  'Job Published',
                  _formatDate(job.postedDate),
                  Icons.publish_outlined,
                  Colors.green,
                ),

              if (job.applicationsCount > 0)
                _buildTimelineItem(
                  'First Application',
                  '${job.applicationsCount} applications received',
                  Icons.people_outlined,
                  Colors.orange,
                ),

              _buildTimelineItem(
                'Application Deadline',
                _formatDate(job.deadline),
                Icons.schedule_outlined,
                Colors.red,
                isLast: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    String title,
    String subtitle,
    IconData icon,
    Color color, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Row(
      children: [
        Column(
          children: [
            if (!isFirst)
              Container(width: 2, height: 16, color: Colors.grey[300]),
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(icon, size: 12, color: Colors.white),
            ),
            if (!isLast)
              Container(width: 2, height: 16, color: Colors.grey[300]),
          ],
        ),

        SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper methods
  Color _getStatusColor(JobStatus status) {
    switch (status) {
      case JobStatus.draft:
        return Colors.orange;
      case JobStatus.published:
        return Colors.green;
      case JobStatus.closed:
        return Colors.red;
      case JobStatus.onHold:
        return Colors.grey;
      case JobStatus.archived:
        return Colors.purple;
    }
  }

  String _getStatusText(JobStatus status) {
    switch (status) {
      case JobStatus.draft:
        return 'Draft';
      case JobStatus.published:
        return 'Published';
      case JobStatus.closed:
        return 'Closed';
      case JobStatus.onHold:
        return 'On Hold';
      case JobStatus.archived:
        return 'Archived';
    }
  }

  Color _getPriorityColor(JobPriority priority) {
    switch (priority) {
      case JobPriority.low:
        return Colors.green;
      case JobPriority.medium:
        return Colors.orange;
      case JobPriority.high:
        return Colors.red;
      case JobPriority.urgent:
        return Colors.purple;
    }
  }

  String _getPriorityText(JobPriority priority) {
    switch (priority) {
      case JobPriority.low:
        return 'Low Priority';
      case JobPriority.medium:
        return 'Medium Priority';
      case JobPriority.high:
        return 'High Priority';
      case JobPriority.urgent:
        return 'Urgent';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else {
      return 'Just now';
    }
  }

  String _formatSalary(int salary) {
    return (salary / 100000).toStringAsFixed(1);
  }

  void _viewApplications(JobPosting job) {
    Get.snackbar(
      'View Applications',
      'Opening applications for ${job.title}...',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void _editJob(JobPosting job) {
    // Pre-fill form and switch to edit mode
    controller.jobTitleController.text = job.title;
    controller.jobDescriptionController.text = job.description;
    controller.requirementsController.text = job.requirements.join('\n');
    controller.benefitsController.text = job.benefits.join('\n');
    controller.salaryMinController.text = job.salaryMin.toString();
    controller.salaryMaxController.text = job.salaryMax.toString();

    controller.selectedTab.value = 1; // Switch to create/edit tab
    controller.isCreatingJob.value = true;
  }

  void _shareJob(JobPosting job) {
    Get.dialog(
      AlertDialog(
        title: Text('Share Job'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Share "${job.title}" job posting:'),
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
                      'https://campusconnect.com/jobs/${job.id}',
                      style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.snackbar('Copied', 'Job link copied to clipboard');
                    },
                    icon: Icon(Icons.copy_outlined, size: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Close')),
        ],
      ),
    );
  }
}
