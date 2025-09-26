import 'package:get/get.dart';

import '../../../../presentation/group_management/controllers/group_management.controller.dart';

class GroupManagementControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupManagementController>(
      () => GroupManagementController(),
    );
  }
}
