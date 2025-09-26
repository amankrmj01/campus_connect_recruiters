import 'package:get/get.dart';

// Import all controllers
import '../../presentation/analytics/controllers/analytics.controller.dart';
import '../../presentation/auth/controllers/auth.controller.dart';
import '../../presentation/candidate_management/controllers/candidate_management.controller.dart';
import '../../presentation/dashboard/controllers/dashboard.controller.dart';
import '../../presentation/form_builder/controllers/form_builder.controller.dart';
import '../../presentation/group_management/controllers/group_management.controller.dart';
import '../../presentation/home/controllers/home.controller.dart';
import '../../presentation/job_management/controllers/job_management.controller.dart';

class ControllerInitializer {
  /// Initialize all controllers when the app starts
  static void init() {
    // Put all controllers into GetX dependency injection
    Get.put<AnalyticsController>(AnalyticsController(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<CandidateManagementController>(
      CandidateManagementController(),
      permanent: true,
    );
    Get.put<DashboardController>(DashboardController(), permanent: true);
    Get.put<FormBuilderController>(FormBuilderController(), permanent: true);
    Get.put<GroupManagementController>(
      GroupManagementController(),
      permanent: true,
    );
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.put<JobManagementController>(
      JobManagementController(),
      permanent: true,
    );
  }

  /// Initialize controllers lazily when needed (alternative approach)
  static void initLazy() {
    Get.lazyPut<AnalyticsController>(() => AnalyticsController(), fenix: true);
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<CandidateManagementController>(
      () => CandidateManagementController(),
      fenix: true,
    );
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);
    Get.lazyPut<FormBuilderController>(
      () => FormBuilderController(),
      fenix: true,
    );
    Get.lazyPut<GroupManagementController>(
      () => GroupManagementController(),
      fenix: true,
    );
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<JobManagementController>(
      () => JobManagementController(),
      fenix: true,
    );
  }

  /// Clean up all controllers
  static void dispose() {
    Get.delete<AnalyticsController>();
    Get.delete<AuthController>();
    Get.delete<CandidateManagementController>();
    Get.delete<DashboardController>();
    Get.delete<FormBuilderController>();
    Get.delete<GroupManagementController>();
    Get.delete<HomeController>();
    Get.delete<JobManagementController>();
  }
}
