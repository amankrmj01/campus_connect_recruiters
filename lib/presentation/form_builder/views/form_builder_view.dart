import 'package:flutter/material.dart';

import 'package:get/get.dart';

class FormBuilderView extends GetView {
  const FormBuilderView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FormBuilderView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'FormBuilderView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
