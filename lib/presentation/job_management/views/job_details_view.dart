import 'package:flutter/material.dart';

import 'package:get/get.dart';

class JobDetailsView extends GetView {
  const JobDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JobDetailsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'JobDetailsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
