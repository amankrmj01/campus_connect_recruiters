import 'package:get/get.dart';

import '../../../../presentation/analytics/controllers/analytics.controller.dart';

class AnalyticsControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnalyticsController>(
      () => AnalyticsController(),
    );
  }
}
