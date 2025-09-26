import 'package:get/get.dart';

import '../../../../presentation/candidate_management/controllers/candidate_management.controller.dart';

class CandidateManagementControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CandidateManagementController>(
      () => CandidateManagementController(),
    );
  }
}
