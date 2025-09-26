import 'package:flutter/material.dart';

import 'package:get/get.dart';

class JobListView extends GetView {
  const JobListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JobListView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'JobListView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
