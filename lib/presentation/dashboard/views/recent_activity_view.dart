import 'package:flutter/material.dart';

import 'package:get/get.dart';

class RecentActivityView extends GetView {
  const RecentActivityView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RecentActivityView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'RecentActivityView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
