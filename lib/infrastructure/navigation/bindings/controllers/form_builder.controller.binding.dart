import 'package:get/get.dart';

import '../../../../presentation/form_builder/controllers/form_builder.controller.dart';

class FormBuilderControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FormBuilderController>(
      () => FormBuilderController(),
    );
  }
}
