import 'package:flutter/material.dart';

import 'package:get/get.dart';

class MetricsView extends GetView {
  const MetricsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MetricsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'MetricsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
