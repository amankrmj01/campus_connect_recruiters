import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ApplicationReviewView extends GetView {
  const ApplicationReviewView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ApplicationReviewView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ApplicationReviewView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
