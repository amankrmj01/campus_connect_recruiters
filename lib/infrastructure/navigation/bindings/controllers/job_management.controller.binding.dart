import 'package:get/get.dart';

import '../../../../presentation/job_management/controllers/job_management.controller.dart';

class JobManagementControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobManagementController>(
      () => JobManagementController(),
    );
  }
}
