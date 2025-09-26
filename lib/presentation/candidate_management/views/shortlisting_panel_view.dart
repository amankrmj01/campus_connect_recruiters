import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ShortlistingPanelView extends GetView {
  const ShortlistingPanelView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShortlistingPanelView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ShortlistingPanelView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
