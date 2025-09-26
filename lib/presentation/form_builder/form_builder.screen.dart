import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/form_builder.controller.dart';

class FormBuilderScreen extends GetView<FormBuilderController> {
  const FormBuilderScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FormBuilderScreen'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'FormBuilderScreen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
