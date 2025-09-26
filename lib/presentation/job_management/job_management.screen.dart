import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/job_management.controller.dart';

class JobManagementScreen extends GetView<JobManagementController> {
  const JobManagementScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JobManagementScreen'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'JobManagementScreen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
