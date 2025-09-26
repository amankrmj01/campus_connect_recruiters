import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/auth.controller.dart';
import 'views/company_profile_setup_view.dart';
import 'views/recruiter_login_screen_view.dart';

class AuthScreen extends GetView<AuthController> {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[600]!, Colors.blue[800]!],
          ),
        ),
        child: SafeArea(
          child: Obx(() {
            if (controller.isLoginMode.value) {
              return RecruiterLoginScreenView();
            } else {
              if (controller.currentStep.value == 0) {
                return RecruiterLoginScreenView(); // Signup form
              } else {
                return CompanyProfileSetupView();
              }
            }
          }),
        ),
      ),
    );
  }
}
