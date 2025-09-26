import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/group_management.controller.dart';

class GroupManagementScreen extends GetView<GroupManagementController> {
  const GroupManagementScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GroupManagementScreen'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'GroupManagementScreen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
