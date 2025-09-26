import 'package:flutter/material.dart';

import 'package:get/get.dart';

class CandidateListView extends GetView {
  const CandidateListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CandidateListView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CandidateListView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
