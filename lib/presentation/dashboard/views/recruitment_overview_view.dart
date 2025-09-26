import 'package:flutter/material.dart';

import 'package:get/get.dart';

class RecruitmentOverviewView extends GetView {
  const RecruitmentOverviewView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RecruitmentOverviewView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'RecruitmentOverviewView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
