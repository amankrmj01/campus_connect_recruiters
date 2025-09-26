import 'package:flutter/material.dart';

import 'package:get/get.dart';

class QuestionEditorView extends GetView {
  const QuestionEditorView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QuestionEditorView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'QuestionEditorView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
