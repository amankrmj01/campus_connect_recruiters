import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/candidate_management.controller.dart';

class CandidateListView extends GetView<CandidateManagementController> {
  final bool showWatchlisted;

  const CandidateListView({super.key, this.showWatchlisted = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Main Content
        Expanded(
          flex: 3,
          child: Column(
            children: [
              // Search and Filters Bar
              _buildSearchAndFilters(),

              // Candidates List
              Expanded(child: _buildCandidatesList()),
            ],
          ),
        ),

        // Filters Sidebar
        Container(
          width: 300,
          color: Colors.white,
          child: _buildFiltersSidebar(),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              // Search Bar
              Expanded(
                child: TextField(
                  controller: controller.searchController,
                  decoration: InputDecoration(
                    hintText:
                        'Search candidates by name, email, skills, or college...',
                    prefixIcon: Icon(Icons.search_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
              ),

              SizedBox(width: 12),

              // Clear Filters
              OutlinedButton.icon(
                onPressed: controller.clearFilters,
                icon: Icon(Icons.clear_all_outlined, size: 16),
                label: Text('Clear Filters'),
              ),

              SizedBox(width: 12),

              // Select All
              Obx(
                () => Checkbox(
                  value:
                      controller.selectedCandidates.length ==
                          controller.filteredCandidates.length &&
                      controller.filteredCandidates.isNotEmpty,
                  onChanged: (_) => controller.selectAllCandidates(),
                  tristate: true,
                ),
              ),
              Text('Select All'),
            ],
          ),

          SizedBox(height: 12),

          // Active Filters Display
          Obx(() => _buildActiveFilters()),
        ],
      ),
    );
  }

  Widget _buildActiveFilters() {
    List<Widget> activeFilters = [];

    if (controller.selectedDepartment.value != 'All') {
      activeFilters.add(
        _buildFilterChip(
          'Department: ${controller.selectedDepartment.value}',
          () => controller.selectedDepartment.value = 'All',
        ),
      );
    }

    if (controller.selectedCollege.value != 'All') {
      activeFilters.add(
        _buildFilterChip(
          'College: ${controller.selectedCollege.value}',
          () => controller.selectedCollege.value = 'All',
        ),
      );
    }

    if (controller.selectedGraduationYear.value != 'All') {
      activeFilters.add(
        _buildFilterChip(
          'Year: ${controller.selectedGraduationYear.value}',
          () => controller.selectedGraduationYear.value = 'All',
        ),
      );
    }

    if (controller.selectedSkills.isNotEmpty) {
      for (String skill in controller.selectedSkills) {
        activeFilters.add(
          _buildFilterChip(
            'Skill: $skill',
            () => controller.selectedSkills.remove(skill),
          ),
        );
      }
    }

    if (controller.minCGPA.value > 0 || controller.maxCGPA.value < 10) {
      activeFilters.add(
        _buildFilterChip(
          'CGPA: ${controller.minCGPA.value.toStringAsFixed(1)} - ${controller.maxCGPA.value.toStringAsFixed(1)}',
          () {
            controller.minCGPA.value = 0.0;
            controller.maxCGPA.value = 10.0;
          },
        ),
      );
    }

    if (activeFilters.isEmpty) return SizedBox.shrink();

    return Wrap(spacing: 8, runSpacing: 4, children: activeFilters);
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Chip(
      label: Text(label, style: TextStyle(fontSize: 12)),
      deleteIcon: Icon(Icons.close, size: 16),
      onDeleted: () {
        onRemove();
        controller.filterCandidates();
      },
      backgroundColor: Colors.blue[50],
      deleteIconColor: Colors.blue[600],
    );
  }

  Widget _buildCandidatesList() {
    return Container(
      color: Colors.grey[50],
      child: Obx(() {
        if (controller.filteredCandidates.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16),
                Text(
                  'No candidates found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Try adjusting your search criteria or filters',
                  style: TextStyle(color: Colors.grey[500]),
                ),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: controller.clearFilters,
                  icon: Icon(Icons.clear_all_outlined),
                  label: Text('Clear All Filters'),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.all(16),
          itemCount: controller.filteredCandidates.length,
          separatorBuilder: (context, index) => SizedBox(height: 12),
          itemBuilder: (context, index) {
            final candidate = controller.filteredCandidates[index];
            return _buildCandidateCard(candidate);
          },
        );
      }),
    );
  }

  Widget _buildCandidateCard(CandidateModel candidate) {
    return Obx(
      () => Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => controller.viewCandidateProfile(candidate),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: controller.selectedCandidates.contains(candidate.id)
                  ? Border.all(color: Colors.blue[600]!, width: 2)
                  : null,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // Selection Checkbox
                    Checkbox(
                      value: controller.selectedCandidates.contains(
                        candidate.id,
                      ),
                      onChanged: (_) =>
                          controller.selectCandidate(candidate.id),
                    ),

                    SizedBox(width: 12),

                    // Profile Picture
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(candidate.profilePicture),
                      onBackgroundImageError: (_, __) {},
                      child: candidate.profilePicture.isEmpty
                          ? Icon(Icons.person_outlined)
                          : null,
                    ),

                    SizedBox(width: 16),

                    // Candidate Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  candidate.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              _buildStatusBadge(candidate.status),
                              SizedBox(width: 8),
                              if (candidate.isWatchlisted)
                                Icon(
                                  Icons.bookmark,
                                  color: Colors.purple[600],
                                  size: 20,
                                ),
                              if (candidate.isShortlisted)
                                Icon(
                                  Icons.star,
                                  color: Colors.orange[600],
                                  size: 20,
                                ),
                            ],
                          ),

                          SizedBox(height: 4),

                          Text(
                            candidate.email,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),

                          SizedBox(height: 8),

                          Row(
                            children: [
                              Icon(
                                Icons.school_outlined,
                                size: 16,
                                color: Colors.grey[500],
                              ),
                              SizedBox(width: 4),
                              Text(
                                '${candidate.department} • ${candidate.college}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(width: 16),
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 16,
                                color: Colors.grey[500],
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Class of ${candidate.graduationYear}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 8),

                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getCGPAColor(
                                    candidate.cgpa,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
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
                              SizedBox(width: 8),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${candidate.appliedJobs} Applications',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue[600],
                                  ),
                                ),
                              ),
                              Spacer(),
                              Text(
                                _getLastActiveText(candidate.lastActive),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 16),

                    // Action Buttons
                    Column(
                      children: [
                        IconButton(
                          onPressed: () =>
                              controller.addToWatchlist(candidate.id),
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

                        PopupMenuButton<String>(
                          onSelected: (action) =>
                              _handleAction(action, candidate),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'view',
                              child: Row(
                                children: [
                                  Icon(Icons.visibility_outlined, size: 16),
                                  SizedBox(width: 8),
                                  Text('View Profile'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'shortlist',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star_outlined,
                                    size: 16,
                                    color: Colors.green,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Shortlist',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'reject',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.close_outlined,
                                    size: 16,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Reject',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'message',
                              child: Row(
                                children: [
                                  Icon(Icons.message_outlined, size: 16),
                                  SizedBox(width: 8),
                                  Text('Send Message'),
                                ],
                              ),
                            ),
                          ],
                          child: Icon(
                            Icons.more_vert_outlined,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Skills Tags
                if (candidate.skills.isNotEmpty) ...[
                  SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: candidate.skills.take(5).map((skill) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            skill,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[700],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
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
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildFiltersSidebar() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filters',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),

          SizedBox(height: 20),

          // Department Filter
          Text(
            'Department',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          SizedBox(height: 8),
          Obx(
            () => DropdownButtonFormField<String>(
              value: controller.selectedDepartment.value,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              items: controller.departments.map((dept) {
                return DropdownMenuItem(
                  value: dept,
                  child: Text(dept, style: TextStyle(fontSize: 13)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.selectedDepartment.value = value;
                  controller.filterCandidates();
                }
              },
            ),
          ),

          SizedBox(height: 16),

          // College Filter
          Text(
            'College',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          SizedBox(height: 8),
          Obx(
            () => DropdownButtonFormField<String>(
              value: controller.selectedCollege.value,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              items: controller.colleges.map((college) {
                return DropdownMenuItem(
                  value: college,
                  child: Text(college, style: TextStyle(fontSize: 13)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.selectedCollege.value = value;
                  controller.filterCandidates();
                }
              },
            ),
          ),

          SizedBox(height: 16),

          // Graduation Year Filter
          Text(
            'Graduation Year',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          SizedBox(height: 8),
          Obx(
            () => DropdownButtonFormField<String>(
              value: controller.selectedGraduationYear.value,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              items: controller.graduationYears.map((year) {
                return DropdownMenuItem(
                  value: year,
                  child: Text(year, style: TextStyle(fontSize: 13)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.selectedGraduationYear.value = value;
                  controller.filterCandidates();
                }
              },
            ),
          ),

          SizedBox(height: 16),

          // CGPA Range Filter
          Text(
            'CGPA Range',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          SizedBox(height: 8),
          Obx(
            () => RangeSlider(
              values: RangeValues(
                controller.minCGPA.value,
                controller.maxCGPA.value,
              ),
              min: 0.0,
              max: 10.0,
              divisions: 40,
              labels: RangeLabels(
                controller.minCGPA.value.toStringAsFixed(1),
                controller.maxCGPA.value.toStringAsFixed(1),
              ),
              onChanged: (values) {
                controller.minCGPA.value = values.start;
                controller.maxCGPA.value = values.end;
              },
              onChangeEnd: (values) => controller.filterCandidates(),
            ),
          ),

          SizedBox(height: 16),

          // Skills Filter
          Text(
            'Skills',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: controller.skillCategories.map((skill) {
              return Obx(
                () => FilterChip(
                  label: Text(skill, style: TextStyle(fontSize: 12)),
                  selected: controller.selectedSkills.contains(skill),
                  onSelected: (selected) {
                    if (selected) {
                      controller.selectedSkills.add(skill);
                    } else {
                      controller.selectedSkills.remove(skill);
                    }
                    controller.filterCandidates();
                  },
                  backgroundColor: Colors.grey[100],
                  selectedColor: Colors.blue[100],
                  checkmarkColor: Colors.blue[600],
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 24),

          // Clear Filters Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: controller.clearFilters,
              child: Text('Clear All Filters'),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCGPAColor(double cgpa) {
    if (cgpa >= 9.0) return Colors.green;
    if (cgpa >= 8.0) return Colors.blue;
    if (cgpa >= 7.0) return Colors.orange;
    return Colors.red;
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

  void _handleAction(String action, CandidateModel candidate) {
    switch (action) {
      case 'view':
        controller.viewCandidateProfile(candidate);
        break;
      case 'shortlist':
        controller.selectedCandidates.clear();
        controller.selectedCandidates.add(candidate.id);
        controller.shortlistCandidates();
        break;
      case 'reject':
        controller.selectedCandidates.clear();
        controller.selectedCandidates.add(candidate.id);
        controller.rejectCandidates();
        break;
      case 'message':
        _showMessageDialog(candidate);
        break;
    }
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
