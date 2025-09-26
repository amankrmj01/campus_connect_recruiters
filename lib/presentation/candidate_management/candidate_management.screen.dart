import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/candidate_management.controller.dart';
import 'views/application_review_view.dart';
import 'views/candidate_list_view.dart';
import 'views/candidate_profile_view.dart';
import 'views/shortlisting_panel_view.dart';

class CandidateManagementScreen extends StatefulWidget {
  const CandidateManagementScreen({super.key});

  @override
  State<CandidateManagementScreen> createState() =>
      _CandidateManagementScreenState();
}

class _CandidateManagementScreenState extends State<CandidateManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final CandidateManagementController controller =
      Get.find<CandidateManagementController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CandidateManagementController>(
      builder: (controller) {
        return Container(
          color: Colors.grey[50],
          child: Column(
            children: [
              // Header Section
              _buildHeader(),

              // Tab Bar
              _buildTabBar(),

              // Content Area
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (controller.selectedCandidate.value != null) {
                    return CandidateProfileView();
                  }

                  switch (controller.selectedTabIndex.value) {
                    case 0:
                      return CandidateListView();
                    case 1:
                      return ShortlistingPanelView();
                    case 2:
                      return ApplicationReviewView();
                    case 3:
                      return CandidateListView(showWatchlisted: true);
                    default:
                      return CandidateListView();
                  }
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Candidate Management',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Manage applications, shortlist candidates, and track recruitment progress',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
              Row(
                children: [
                  // Bulk Actions (shown when candidates are selected)
                  Obx(() {
                    if (controller.isSelectionMode.value) {
                      return Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: controller.shortlistCandidates,
                            icon: Icon(Icons.star_outlined, size: 16),
                            label: Text(
                              'Shortlist (${controller.selectedCandidates.length})',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[600],
                              foregroundColor: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: controller.rejectCandidates,
                            icon: Icon(Icons.close_outlined, size: 16),
                            label: Text('Reject'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[600],
                              foregroundColor: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12),
                          IconButton(
                            onPressed: controller.clearSelection,
                            icon: Icon(Icons.clear_outlined),
                            tooltip: 'Clear Selection',
                          ),
                        ],
                      );
                    }
                    return SizedBox.shrink();
                  }),

                  // Regular Actions
                  Obx(() {
                    if (!controller.isSelectionMode.value) {
                      return Row(
                        children: [
                          IconButton(
                            onPressed: controller.refreshData,
                            icon: Icon(Icons.refresh_outlined),
                            tooltip: 'Refresh',
                          ),
                          SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: controller.exportCandidates,
                            icon: Icon(Icons.download_outlined, size: 16),
                            label: Text('Export'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      );
                    }
                    return SizedBox.shrink();
                  }),
                ],
              ),
            ],
          ),

          SizedBox(height: 20),

          // Quick Stats
          Row(
            children: [
              _buildStatCard(
                'Total Candidates',
                '${controller.allCandidates.length}',
                Icons.people_outlined,
                Colors.blue,
              ),
              SizedBox(width: 16),
              _buildStatCard(
                'Shortlisted',
                '${controller.shortlistedCandidates.length}',
                Icons.star_outlined,
                Colors.green,
              ),
              SizedBox(width: 16),
              _buildStatCard(
                'In Review',
                '${controller.filteredCandidates.where((c) => c.status == CandidateStatus.active && !c.isShortlisted).length}',
                Icons.hourglass_empty_outlined,
                Colors.orange,
              ),
              SizedBox(width: 16),
              _buildStatCard(
                'Watchlisted',
                '${controller.watchlistedCandidates.length}',
                Icons.bookmark_outlined,
                Colors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    final tabs = [
      {'title': 'All Candidates', 'icon': Icons.people_outlined},
      {'title': 'Shortlisted', 'icon': Icons.star_outlined},
      {'title': 'Under Review', 'icon': Icons.assignment_outlined},
      {'title': 'Watchlist', 'icon': Icons.bookmark_outlined},
    ];

    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        onTap: Get.find<CandidateManagementController>().changeTab,
        labelColor: Colors.blue[600],
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: Colors.blue[600],
        tabs: tabs.map((tab) {
          return Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(tab['icon'] as IconData, size: 16),
                SizedBox(width: 8),
                Text(tab['title'] as String),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
