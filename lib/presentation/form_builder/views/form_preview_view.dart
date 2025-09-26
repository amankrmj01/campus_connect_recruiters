import 'package:flutter/material.dart';

import 'package:get/get.dart';

class FormPreviewView extends GetView {
  const FormPreviewView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FormPreviewView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'FormPreviewView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
