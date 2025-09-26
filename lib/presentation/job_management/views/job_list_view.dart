import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/job_management.controller.dart';
import 'job_details_view.dart';

class JobListView extends GetView<JobManagementController> {
  const JobListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Job List Panel
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                right: BorderSide(color: Colors.grey[200]!, width: 1),
              ),
            ),
            child: Column(
              children: [
                // Filters and Search
                _buildFiltersSection(),

                // Job List
                Expanded(child: _buildJobsList()),
              ],
            ),
          ),
        ),

        // Job Details Panel
        Expanded(
          flex: 3,
          child: Obx(() {
            if (controller.selectedJobId.value.isEmpty) {
              return _buildNoJobSelectedView();
            } else {
              return JobDetailsView();
            }
          }),
        ),
      ],
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          TextField(
            controller: controller.searchController,
            decoration: InputDecoration(
              hintText: 'Search jobs by title, department, or tags...',
              prefixIcon: Icon(Icons.search_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),

          SizedBox(height: 16),

          // Filter Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Status Filter
                _buildFilterDropdown(
                  'Status',
                  controller.selectedStatus.value,
                  controller.statusOptions,
                  (value) {
                    controller.selectedStatus.value = value!;
                    controller.applyFilters();
                  },
                ),

                SizedBox(width: 12),

                // Department Filter
                _buildFilterDropdown(
                  'Department',
                  controller.selectedDepartment.value,
                  controller.departmentOptions,
                  (value) {
                    controller.selectedDepartment.value = value!;
                    controller.applyFilters();
                  },
                ),

                SizedBox(width: 12),

                // Priority Filter
                _buildFilterDropdown(
                  'Priority',
                  controller.selectedPriority.value,
                  controller.priorityOptions,
                  (value) {
                    controller.selectedPriority.value = value!;
                    controller.applyFilters();
                  },
                ),

                SizedBox(width: 12),

                // Job Type Filter
                _buildFilterDropdown(
                  'Type',
                  controller.selectedJobType.value,
                  controller.jobTypeOptions,
                  (value) {
                    controller.selectedJobType.value = value!;
                    controller.applyFilters();
                  },
                ),

                SizedBox(width: 12),

                // Clear Filters Button
                if (_hasActiveFilters())
                  TextButton.icon(
                    onPressed: _clearAllFilters,
                    icon: Icon(Icons.clear_outlined, size: 16),
                    label: Text('Clear'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red[600],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(
    String label,
    String value,
    List<String> options,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 4),
        Container(
          width: 120,
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              isDense: true,
            ),
            items: options.map((option) {
              return DropdownMenuItem(
                value: option,
                child: Text(
                  option,
                  style: TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildJobsList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (controller.filteredJobs.isEmpty) {
        return _buildEmptyState();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Results Count
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '${controller.filteredJobs.length} job${controller.filteredJobs.length != 1 ? 's' : ''} found',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),

          // Jobs List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.filteredJobs.length,
              itemBuilder: (context, index) {
                final job = controller.filteredJobs[index];
                return _buildJobCard(job);
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildJobCard(JobPosting job) {
    return Obx(
      () => GestureDetector(
        onTap: () => controller.selectJob(job.id),
        child: Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: controller.selectedJobId.value == job.id
                ? Colors.blue[50]
                : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: controller.selectedJobId.value == job.id
                  ? Colors.blue[200]!
                  : Colors.grey[200]!,
              width: controller.selectedJobId.value == job.id ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Job Header
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          job.department,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Status Badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(job.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusText(job.status),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(job.status),
                      ),
                    ),
                  ),

                  SizedBox(width: 8),

                  // Priority Indicator
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _getPriorityColor(job.priority),
                      shape: BoxShape.circle,
                    ),
                  ),

                  // Context Menu
                  PopupMenuButton<String>(
                    onSelected: (action) => _handleJobAction(action, job),
                    itemBuilder: (context) => _buildJobContextMenu(job),
                    child: Icon(
                      Icons.more_vert_outlined,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              // Job Details
              Row(
                children: [
                  Icon(Icons.work_outlined, size: 12, color: Colors.grey[500]),
                  SizedBox(width: 4),
                  Text(
                    job.jobType,
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),

                  SizedBox(width: 12),

                  Icon(
                    Icons.location_on_outlined,
                    size: 12,
                    color: Colors.grey[500],
                  ),
                  SizedBox(width: 4),
                  Text(
                    job.location,
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),

                  SizedBox(width: 12),

                  Icon(
                    Icons.schedule_outlined,
                    size: 12,
                    color: Colors.grey[500],
                  ),
                  SizedBox(width: 4),
                  Text(
                    job.experience,
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),

              SizedBox(height: 8),

              // Salary Range
              Text(
                '₹${_formatSalary(job.salaryMin)} - ₹${_formatSalary(job.salaryMax)} LPA',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[700],
                ),
              ),

              SizedBox(height: 12),

              // Statistics Row
              Row(
                children: [
                  _buildJobStat(
                    Icons.people_outlined,
                    '${job.applicationsCount}',
                    'Applications',
                  ),
                  _buildJobStat(
                    Icons.visibility_outlined,
                    '${job.viewsCount}',
                    'Views',
                  ),
                  _buildJobStat(
                    Icons.star_outlined,
                    '${job.shortlistedCount}',
                    'Shortlisted',
                  ),

                  Spacer(),

                  // Days since posted
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getDaysPosted(job.postedDate),
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              // Tags
              if (job.tags.isNotEmpty)
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: job.tags.take(3).map((tag) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(fontSize: 10, color: Colors.blue[700]),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobStat(IconData icon, String value, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Colors.grey[500]),
        SizedBox(width: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(width: 8),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.work_off_outlined, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'No jobs found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your filters or create a new job',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: controller.startCreatingJob,
            icon: Icon(Icons.add_outlined),
            label: Text('Create New Job'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoJobSelectedView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.work_outlined, size: 80, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text(
            'Select a job to view details',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Text(
            'Click on any job from the list to see detailed information',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<PopupMenuEntry<String>> _buildJobContextMenu(JobPosting job) {
    List<PopupMenuEntry<String>> items = [];

    // Status-specific actions
    if (job.status == JobStatus.draft) {
      items.add(
        PopupMenuItem(
          value: 'publish',
          child: Row(
            children: [
              Icon(Icons.publish_outlined, size: 16, color: Colors.green),
              SizedBox(width: 8),
              Text('Publish Job', style: TextStyle(color: Colors.green)),
            ],
          ),
        ),
      );
    } else if (job.status == JobStatus.published) {
      items.add(
        PopupMenuItem(
          value: 'pause',
          child: Row(
            children: [
              Icon(Icons.pause_outlined, size: 16, color: Colors.orange),
              SizedBox(width: 8),
              Text('Put On Hold', style: TextStyle(color: Colors.orange)),
            ],
          ),
        ),
      );
      items.add(
        PopupMenuItem(
          value: 'close',
          child: Row(
            children: [
              Icon(Icons.close_outlined, size: 16, color: Colors.red),
              SizedBox(width: 8),
              Text('Close Job', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      );
    }

    // Common actions
    items.addAll([
      PopupMenuItem(
        value: 'edit',
        child: Row(
          children: [
            Icon(Icons.edit_outlined, size: 16),
            SizedBox(width: 8),
            Text('Edit Job'),
          ],
        ),
      ),
      PopupMenuItem(
        value: 'duplicate',
        child: Row(
          children: [
            Icon(Icons.copy_outlined, size: 16),
            SizedBox(width: 8),
            Text('Duplicate'),
          ],
        ),
      ),
      PopupMenuItem(
        value: 'share',
        child: Row(
          children: [
            Icon(Icons.share_outlined, size: 16),
            SizedBox(width: 8),
            Text('Share Job'),
          ],
        ),
      ),
      PopupMenuDivider(),
      PopupMenuItem(
        value: 'delete',
        child: Row(
          children: [
            Icon(Icons.delete_outlined, size: 16, color: Colors.red),
            SizedBox(width: 8),
            Text('Delete', style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    ]);

    return items;
  }

  // Helper methods
  bool _hasActiveFilters() {
    return controller.selectedStatus.value != 'All' ||
        controller.selectedDepartment.value != 'All' ||
        controller.selectedPriority.value != 'All' ||
        controller.selectedJobType.value != 'All';
  }

  void _clearAllFilters() {
    controller.selectedStatus.value = 'All';
    controller.selectedDepartment.value = 'All';
    controller.selectedPriority.value = 'All';
    controller.selectedJobType.value = 'All';
    controller.searchController.clear();
    controller.applyFilters();
  }

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

  String _formatSalary(int salary) {
    if (salary >= 100000) {
      return '${(salary / 100000).toStringAsFixed(1)}';
    }
    return '${(salary / 100000).toStringAsFixed(2)}';
  }

  String _getDaysPosted(DateTime postedDate) {
    final days = DateTime.now().difference(postedDate).inDays;
    if (days == 0) {
      return 'Today';
    } else if (days == 1) {
      return '1 day ago';
    } else {
      return '$days days ago';
    }
  }

  void _handleJobAction(String action, JobPosting job) {
    switch (action) {
      case 'publish':
        controller.updateJobStatus(job.id, JobStatus.published);
        break;
      case 'pause':
        controller.updateJobStatus(job.id, JobStatus.onHold);
        break;
      case 'close':
        controller.updateJobStatus(job.id, JobStatus.closed);
        break;
      case 'edit':
        _editJob(job);
        break;
      case 'duplicate':
        controller.duplicateJob(job.id);
        break;
      case 'share':
        _shareJob(job);
        break;
      case 'delete':
        controller.deleteJob(job.id);
        break;
    }
  }

  void _editJob(JobPosting job) {
    // Pre-fill form with job data
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
