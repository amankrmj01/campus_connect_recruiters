import 'package:flutter/material.dart';

import 'package:get/get.dart';

class CreateJobView extends GetView {
  const CreateJobView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CreateJobView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CreateJobView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
