import 'package:flutter/material.dart';

import 'package:get/get.dart';

class CandidateProfileView extends GetView {
  const CandidateProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CandidateProfileView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CandidateProfileView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
