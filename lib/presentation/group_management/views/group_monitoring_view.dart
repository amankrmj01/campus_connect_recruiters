import 'package:flutter/material.dart';

import 'package:get/get.dart';

class GroupMonitoringView extends GetView {
  const GroupMonitoringView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GroupMonitoringView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'GroupMonitoringView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
