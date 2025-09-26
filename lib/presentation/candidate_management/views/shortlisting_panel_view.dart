import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/candidate_management.controller.dart';

class ShortlistingPanelView extends GetView<CandidateManagementController> {
  const ShortlistingPanelView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: Column(
        children: [
          // Header
          _buildHeader(),

          // Content Area
          Expanded(
            child: Row(
              children: [
                // Shortlisted Candidates List
                Expanded(flex: 2, child: _buildShortlistedCandidatesList()),

                // Shortlisting Tools Panel
                Container(
                  width: 350,
                  color: Colors.white,
                  child: _buildShortlistingTools(),
                ),
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
          Icon(Icons.star_outlined, size: 24, color: Colors.orange[600]),
          SizedBox(width: 12),
          Text(
            'Shortlisting Panel',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          Spacer(),
          Obx(
            () => Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${controller.shortlistedCandidates.length} Shortlisted',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[800],
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${controller.filteredCandidates.where((c) => !c.isShortlisted && c.status == CandidateStatus.active).length} Pending Review',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShortlistedCandidatesList() {
    return Column(
      children: [
        // Tab Bar for different views
        Container(
          color: Colors.white,
          child: TabBar(
            controller: TabController(
              length: 3,
              vsync: Scaffold.of(Get.context!),
            ),
            labelColor: Colors.blue[600],
            unselectedLabelColor: Colors.grey[600],
            indicatorColor: Colors.blue[600],
            tabs: [
              Tab(text: 'Shortlisted'),
              Tab(text: 'Top Candidates'),
              Tab(text: 'Recently Added'),
            ],
          ),
        ),

        // Content Area
        Expanded(
          child: TabBarView(
            controller: TabController(
              length: 3,
              vsync: Scaffold.of(Get.context!),
            ),
            children: [
              _buildShortlistedTab(),
              _buildTopCandidatesTab(),
              _buildRecentlyAddedTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShortlistedTab() {
    return Container(
      color: Colors.grey[50],
      child: Obx(() {
        if (controller.shortlistedCandidates.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star_outline, size: 64, color: Colors.grey[400]),
                SizedBox(height: 16),
                Text(
                  'No candidates shortlisted yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Use the filters and tools to find and shortlist promising candidates',
                  style: TextStyle(color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.all(16),
          itemCount: controller.shortlistedCandidates.length,
          separatorBuilder: (context, index) => SizedBox(height: 12),
          itemBuilder: (context, index) {
            final candidate = controller.shortlistedCandidates[index];
            return _buildShortlistedCandidateCard(candidate);
          },
        );
      }),
    );
  }

  Widget _buildTopCandidatesTab() {
    return Container(
      color: Colors.grey[50],
      child: Obx(() {
        // Sort candidates by CGPA and response rate
        final topCandidates =
            List<CandidateModel>.from(controller.allCandidates)..sort((a, b) {
              final scoreA = a.cgpa * 0.6 + (a.responseRate / 100) * 0.4;
              final scoreB = b.cgpa * 0.6 + (b.responseRate / 100) * 0.4;
              return scoreB.compareTo(scoreA);
            });

        return ListView.separated(
          padding: EdgeInsets.all(16),
          itemCount: topCandidates.take(10).length,
          separatorBuilder: (context, index) => SizedBox(height: 12),
          itemBuilder: (context, index) {
            final candidate = topCandidates[index];
            return _buildTopCandidateCard(candidate, index + 1);
          },
        );
      }),
    );
  }

  Widget _buildRecentlyAddedTab() {
    return Container(
      color: Colors.grey[50],
      child: Obx(() {
        final recentCandidates =
            controller.shortlistedCandidates
                .where(
                  (c) => DateTime.now().difference(c.lastActive).inDays <= 7,
                )
                .toList()
              ..sort((a, b) => b.lastActive.compareTo(a.lastActive));

        if (recentCandidates.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.schedule_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16),
                Text(
                  'No recent shortlists',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.all(16),
          itemCount: recentCandidates.length,
          separatorBuilder: (context, index) => SizedBox(height: 12),
          itemBuilder: (context, index) {
            final candidate = recentCandidates[index];
            return _buildShortlistedCandidateCard(candidate);
          },
        );
      }),
    );
  }

  Widget _buildShortlistedCandidateCard(CandidateModel candidate) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => controller.viewCandidateProfile(candidate),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  // Profile Picture
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(candidate.profilePicture),
                    onBackgroundImageError: (_, __) {},
                    child: candidate.profilePicture.isEmpty
                        ? Icon(Icons.person_outlined)
                        : null,
                  ),

                  SizedBox(width: 12),

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
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.orange[600],
                              size: 16,
                            ),
                            if (candidate.isWatchlisted)
                              Icon(
                                Icons.bookmark,
                                color: Colors.purple[600],
                                size: 16,
                              ),
                          ],
                        ),

                        Text(
                          '${candidate.department} • ${candidate.college}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),

                        SizedBox(height: 8),

                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _getCGPAColor(
                                  candidate.cgpa,
                                ).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'CGPA: ${candidate.cgpa}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: _getCGPAColor(candidate.cgpa),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
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
                                '${candidate.appliedJobs} apps',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Actions
                  PopupMenuButton<String>(
                    onSelected: (action) =>
                        _handleShortlistAction(action, candidate),
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
                        value: 'remove',
                        child: Row(
                          children: [
                            Icon(
                              Icons.remove_circle_outline,
                              size: 16,
                              color: Colors.orange,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Remove from Shortlist',
                              style: TextStyle(color: Colors.orange),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'interview',
                        child: Row(
                          children: [
                            Icon(
                              Icons.schedule_outlined,
                              size: 16,
                              color: Colors.green,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Schedule Interview',
                              style: TextStyle(color: Colors.green),
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

              // Skills (if available)
              if (candidate.skills.isNotEmpty) ...[
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 2,
                    children: candidate.skills.take(3).map((skill) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          skill,
                          style: TextStyle(
                            fontSize: 10,
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
    );
  }

  Widget _buildTopCandidateCard(CandidateModel candidate, int rank) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // Rank
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _getRankColor(rank),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            SizedBox(width: 12),

            // Profile Picture
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(candidate.profilePicture),
              onBackgroundImageError: (_, __) {},
              child: candidate.profilePicture.isEmpty
                  ? Icon(Icons.person_outlined)
                  : null,
            ),

            SizedBox(width: 12),

            // Candidate Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    candidate.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  Text(
                    '${candidate.department} • CGPA: ${candidate.cgpa}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ],
              ),
            ),

            // Score
            Column(
              children: [
                Text(
                  '${((candidate.cgpa * 0.6 + (candidate.responseRate / 100) * 0.4) * 10).toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _getRankColor(rank),
                  ),
                ),
                Text(
                  'Score',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),

            SizedBox(width: 12),

            // Quick Shortlist Button
            ElevatedButton(
              onPressed: candidate.isShortlisted
                  ? null
                  : () {
                      controller.selectedCandidates.clear();
                      controller.selectedCandidates.add(candidate.id);
                      controller.shortlistCandidates();
                    },
              child: Text(
                candidate.isShortlisted ? 'Shortlisted' : 'Shortlist',
                style: TextStyle(fontSize: 12),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: candidate.isShortlisted
                    ? Colors.grey
                    : Colors.green[600],
                foregroundColor: Colors.white,
                minimumSize: Size(80, 32),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShortlistingTools() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tools Header
          Text(
            'Shortlisting Tools',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),

          SizedBox(height: 20),

          // Smart Filters
          _buildToolSection('Smart Filters', Icons.filter_alt_outlined, [
            _buildSmartFilterOption(
              'High CGPA (8.5+)',
              () => _applySmartFilter('high_cgpa'),
            ),
            _buildSmartFilterOption(
              'Active Candidates',
              () => _applySmartFilter('active'),
            ),
            _buildSmartFilterOption(
              'Multi-skilled',
              () => _applySmartFilter('multi_skilled'),
            ),
            _buildSmartFilterOption(
              'Quick Responders',
              () => _applySmartFilter('quick_responder'),
            ),
          ]),

          SizedBox(height: 20),

          // Quick Actions
          _buildToolSection('Quick Actions', Icons.flash_on_outlined, [
            _buildQuickAction(
              'Auto-shortlist Top 10',
              'Automatically shortlist top 10 candidates',
              Colors.green,
              () => _autoShortlistTop10(),
            ),
            _buildQuickAction(
              'Bulk Message',
              'Send message to all shortlisted',
              Colors.blue,
              () => _showBulkMessageDialog(),
            ),
            _buildQuickAction(
              'Export Shortlist',
              'Download shortlisted candidates',
              Colors.orange,
              () => controller.exportCandidates(),
            ),
          ]),

          SizedBox(height: 20),

          // Statistics
          _buildToolSection('Statistics', Icons.analytics_outlined, [
            _buildStatItem(
              'Total Candidates',
              controller.allCandidates.length.toString(),
            ),
            _buildStatItem(
              'Shortlisted',
              controller.shortlistedCandidates.length.toString(),
            ),
            _buildStatItem(
              'Avg. CGPA',
              controller.allCandidates.isNotEmpty
                  ? (controller.allCandidates
                                .map((c) => c.cgpa)
                                .reduce((a, b) => a + b) /
                            controller.allCandidates.length)
                        .toStringAsFixed(2)
                  : '0',
            ),
            _buildStatItem(
              'Response Rate',
              controller.allCandidates.isNotEmpty
                  ? '${(controller.allCandidates.map((c) => c.responseRate).reduce((a, b) => a + b) / controller.allCandidates.length).toStringAsFixed(0)}%'
                  : '0%',
            ),
          ]),

          SizedBox(height: 20),

          // Shortlisting Criteria
          _buildToolSection('Criteria Settings', Icons.tune_outlined, [
            _buildCriteriaSlider(
              'Min CGPA',
              0.0,
              10.0,
              controller.minCGPA.value,
              (value) {
                controller.minCGPA.value = value;
                controller.filterCandidates();
              },
            ),
            SizedBox(height: 12),
            Text(
              'Preferred Skills',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: ['Java', 'Python', 'React', 'Node.js', 'AWS'].map((
                skill,
              ) {
                return Obx(
                  () => FilterChip(
                    label: Text(skill, style: TextStyle(fontSize: 11)),
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
                  ),
                );
              }).toList(),
            ),
          ]),

          SizedBox(height: 20),

          // Recent Activity
          _buildRecentActivity(),
        ],
      ),
    );
  }

  Widget _buildToolSection(String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey[600]),
            SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildSmartFilterOption(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        margin: EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Text(
          title,
          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 11, color: color.withOpacity(0.8)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCriteriaSlider(
    String label,
    double min,
    double max,
    double value,
    Function(double) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ${value.toStringAsFixed(1)}',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        SliderTheme(
          data: SliderTheme.of(Get.context!).copyWith(
            trackHeight: 2,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
            activeColor: Colors.blue[600],
            inactiveColor: Colors.grey[300],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.history_outlined, size: 16, color: Colors.grey[600]),
            SizedBox(width: 6),
            Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),

        SizedBox(height: 12),

        Column(
          children: [
            _buildActivityItem(
              '3 candidates shortlisted',
              '2 hours ago',
              Icons.star_outlined,
              Colors.green,
            ),
            _buildActivityItem(
              '5 new applications reviewed',
              '4 hours ago',
              Icons.assignment_outlined,
              Colors.blue,
            ),
            _buildActivityItem(
              'Bulk message sent to 8 candidates',
              '1 day ago',
              Icons.message_outlined,
              Colors.orange,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    String activity,
    String time,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: color),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                ),
                Text(
                  time,
                  style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                ),
              ],
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

  Color _getRankColor(int rank) {
    if (rank <= 3) return Colors.green[600]!;
    if (rank <= 6) return Colors.blue[600]!;
    return Colors.orange[600]!;
  }

  void _handleShortlistAction(String action, CandidateModel candidate) {
    switch (action) {
      case 'view':
        controller.viewCandidateProfile(candidate);
        break;
      case 'remove':
        _removeFromShortlist(candidate);
        break;
      case 'interview':
        _scheduleInterview(candidate);
        break;
      case 'message':
        _showMessageDialog(candidate);
        break;
    }
  }

  void _removeFromShortlist(CandidateModel candidate) {
    Get.dialog(
      AlertDialog(
        title: Text('Remove from Shortlist'),
        content: Text(
          'Are you sure you want to remove ${candidate.name} from the shortlist?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // Update candidate shortlist status
              final index = controller.allCandidates.indexWhere(
                (c) => c.id == candidate.id,
              );
              if (index != -1) {
                controller.allCandidates[index] = controller
                    .allCandidates[index]
                    .copyWith(isShortlisted: false);
                controller.updateFilteredLists();
                Get.snackbar(
                  'Removed',
                  '${candidate.name} removed from shortlist',
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _scheduleInterview(CandidateModel candidate) {
    Get.dialog(
      AlertDialog(
        title: Text('Schedule Interview'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Schedule an interview with ${candidate.name}'),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Interview Date & Time',
                hintText: 'Select date and time',
                prefixIcon: Icon(Icons.calendar_today_outlined),
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: () {
                // TODO: Implement date/time picker
              },
            ),
            SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Interview Type',
                hintText: 'Technical, HR, Final, etc.',
                prefixIcon: Icon(Icons.category_outlined),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Interview Scheduled',
                'Interview scheduled with ${candidate.name}',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: Text('Schedule'),
          ),
        ],
      ),
    );
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

  void _applySmartFilter(String filterType) {
    switch (filterType) {
      case 'high_cgpa':
        controller.minCGPA.value = 8.5;
        break;
      case 'active':
        // Filter for candidates active in last 7 days
        break;
      case 'multi_skilled':
        // Filter for candidates with 4+ skills
        break;
      case 'quick_responder':
        // Filter for candidates with response rate > 80%
        break;
    }
    controller.filterCandidates();
    Get.snackbar(
      'Filter Applied',
      'Smart filter has been applied',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void _autoShortlistTop10() {
    final topCandidates = List<CandidateModel>.from(controller.allCandidates)
      ..sort((a, b) {
        final scoreA = a.cgpa * 0.6 + (a.responseRate / 100) * 0.4;
        final scoreB = b.cgpa * 0.6 + (b.responseRate / 100) * 0.4;
        return scoreB.compareTo(scoreA);
      });

    final candidatesToShortlist = topCandidates
        .take(10)
        .where((c) => !c.isShortlisted)
        .toList();

    if (candidatesToShortlist.isEmpty) {
      Get.snackbar(
        'Already Shortlisted',
        'Top 10 candidates are already shortlisted',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    Get.dialog(
      AlertDialog(
        title: Text('Auto-shortlist Top 10'),
        content: Text(
          'This will shortlist ${candidatesToShortlist.length} top candidates based on CGPA and response rate. Continue?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();

              // Shortlist the candidates
              for (var candidate in candidatesToShortlist) {
                final index = controller.allCandidates.indexWhere(
                  (c) => c.id == candidate.id,
                );
                if (index != -1) {
                  controller.allCandidates[index] = controller
                      .allCandidates[index]
                      .copyWith(isShortlisted: true);
                }
              }

              controller.updateFilteredLists();

              Get.snackbar(
                'Auto-shortlist Complete',
                '${candidatesToShortlist.length} candidates shortlisted',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: Text('Shortlist'),
          ),
        ],
      ),
    );
  }

  void _showBulkMessageDialog() {
    if (controller.shortlistedCandidates.isEmpty) {
      Get.snackbar(
        'No Candidates',
        'No shortlisted candidates to send messages to',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final bulkMessageController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text('Bulk Message'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Send message to ${controller.shortlistedCandidates.length} shortlisted candidates',
            ),
            SizedBox(height: 16),
            TextField(
              controller: bulkMessageController,
              decoration: InputDecoration(
                labelText: 'Message',
                hintText: 'Type your message here...',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Checkbox(value: true, onChanged: null),
                Expanded(
                  child: Text(
                    'Include candidate name in message',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (bulkMessageController.text.isNotEmpty) {
                Get.back();

                // Send message to all shortlisted candidates
                for (var candidate in controller.shortlistedCandidates) {
                  controller.sendMessage(
                    candidate.id,
                    bulkMessageController.text,
                  );
                }

                Get.snackbar(
                  'Messages Sent',
                  'Bulk message sent to ${controller.shortlistedCandidates.length} candidates',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              }
            },
            child: Text('Send to All'),
          ),
        ],
      ),
    );
  }
}
