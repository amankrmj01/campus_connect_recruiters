import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth.controller.dart';

class RecruiterLoginScreenView extends GetView<AuthController> {
  const RecruiterLoginScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          child: Card(
            elevation: 20,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Obx(() {
                if (controller.isLoginMode.value) {
                  return _buildLoginForm();
                } else {
                  return _buildSignupForm();
                }
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: controller.loginFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo and Title
          _buildHeader('Welcome Back', 'Sign in to your recruiter account'),

          SizedBox(height: 32),

          // Email Field
          TextFormField(
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            validator: controller.validateEmail,
            decoration: InputDecoration(
              labelText: 'Email Address',
              hintText: 'Enter your email',
              prefixIcon: Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),

          SizedBox(height: 16),

          // Password Field
          Obx(
            () => TextFormField(
              controller: controller.passwordController,
              obscureText: !controller.isPasswordVisible.value,
              validator: controller.validatePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: Icon(Icons.lock_outlined),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordVisible.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
          ),

          SizedBox(height: 16),

          // Remember Me & Forgot Password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Row(
                  children: [
                    Checkbox(
                      value: controller.rememberMe.value,
                      onChanged: (_) => controller.toggleRememberMe(),
                    ),
                    Text('Remember me'),
                  ],
                ),
              ),
              TextButton(
                onPressed: controller.forgotPassword,
                child: Text('Forgot Password?'),
              ),
            ],
          ),

          SizedBox(height: 24),

          // Login Button
          Obx(
            () => SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: controller.isLoading.value
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),

          SizedBox(height: 24),

          // Divider
          Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'OR',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(child: Divider()),
            ],
          ),

          SizedBox(height: 24),

          // Social Login Buttons
          _buildSocialLoginButtons(),

          SizedBox(height: 24),

          // Switch to Signup
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: TextStyle(color: Colors.grey[600]),
              ),
              TextButton(
                onPressed: controller.toggleAuthMode,
                child: Text(
                  'Create Account',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[600],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignupForm() {
    return Form(
      key: controller.signupFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          _buildHeader('Create Account', 'Set up your recruiter profile'),

          SizedBox(height: 32),

          // Recruiter Name
          TextFormField(
            controller: controller.recruiterNameController,
            validator: (value) =>
                controller.validateRequired(value, 'Full name'),
            decoration: InputDecoration(
              labelText: 'Full Name',
              hintText: 'Enter your full name',
              prefixIcon: Icon(Icons.person_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),

          SizedBox(height: 16),

          // Email
          TextFormField(
            controller: controller.signupEmailController,
            keyboardType: TextInputType.emailAddress,
            validator: controller.validateEmail,
            decoration: InputDecoration(
              labelText: 'Email Address',
              hintText: 'Enter your work email',
              prefixIcon: Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),

          SizedBox(height: 16),

          // Phone
          TextFormField(
            controller: controller.recruiterPhoneController,
            keyboardType: TextInputType.phone,
            validator: controller.validatePhone,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              hintText: 'Enter your phone number',
              prefixIcon: Icon(Icons.phone_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),

          SizedBox(height: 16),

          // Designation
          TextFormField(
            controller: controller.recruiterDesignationController,
            validator: (value) =>
                controller.validateRequired(value, 'Designation'),
            decoration: InputDecoration(
              labelText: 'Designation',
              hintText: 'e.g., Senior Talent Acquisition Manager',
              prefixIcon: Icon(Icons.work_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),

          SizedBox(height: 16),

          // Department
          Obx(
            () => DropdownButtonFormField<String>(
              value: controller.selectedDepartment.value,
              decoration: InputDecoration(
                labelText: 'Department',
                prefixIcon: Icon(Icons.business_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              items: controller.departments.map((dept) {
                return DropdownMenuItem(value: dept, child: Text(dept));
              }).toList(),
              onChanged: (value) {
                if (value != null) controller.selectedDepartment.value = value;
              },
            ),
          ),

          SizedBox(height: 16),

          // Password
          Obx(
            () => TextFormField(
              controller: controller.signupPasswordController,
              obscureText: !controller.isPasswordVisible.value,
              validator: controller.validatePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Create a strong password',
                prefixIcon: Icon(Icons.lock_outlined),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordVisible.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
          ),

          SizedBox(height: 16),

          // Confirm Password
          Obx(
            () => TextFormField(
              controller: controller.confirmPasswordController,
              obscureText: !controller.isConfirmPasswordVisible.value,
              validator: controller.validateConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                hintText: 'Re-enter your password',
                prefixIcon: Icon(Icons.lock_outlined),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isConfirmPasswordVisible.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: controller.toggleConfirmPasswordVisibility,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
          ),

          SizedBox(height: 24),

          // Create Account Button
          Obx(
            () => SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.signup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: controller.isLoading.value
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),

          SizedBox(height: 16),

          // Terms and Conditions
          Text(
            'By creating an account, you agree to our Terms of Service and Privacy Policy',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 24),

          // Switch to Login
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account? ',
                style: TextStyle(color: Colors.grey[600]),
              ),
              TextButton(
                onPressed: controller.toggleAuthMode,
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[600],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String title, String subtitle) {
    return Column(
      children: [
        // Logo
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.blue[600],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(Icons.business_outlined, size: 40, color: Colors.white),
        ),

        SizedBox(height: 16),

        Text(
          title,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),

        SizedBox(height: 8),

        Text(
          subtitle,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSocialLoginButtons() {
    return Column(
      children: [
        // Google Login
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: () {
              Get.snackbar(
                'Coming Soon',
                'Google Sign-In will be available soon!',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.blue,
                colorText: Colors.white,
              );
            },
            icon: Icon(Icons.g_mobiledata, color: Colors.red),
            label: Text('Continue with Google'),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        SizedBox(height: 12),

        // LinkedIn Login
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: () {
              Get.snackbar(
                'Coming Soon',
                'LinkedIn Sign-In will be available soon!',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.blue,
                colorText: Colors.white,
              );
            },
            icon: Icon(Icons.business, color: Colors.blue[700]),
            label: Text('Continue with LinkedIn'),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
