import 'package:flutter/material.dart';

import 'package:get/get.dart';

class JobRequirementsFormView extends GetView {
  const JobRequirementsFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JobRequirementsFormView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'JobRequirementsFormView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
