import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  // Reactive variables
  var isLoading = false.obs;
  var isLoginMode = true.obs;
  var currentStep = 0.obs;
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  var rememberMe = false.obs;

  // Form Controllers
  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();
  final companySetupFormKey = GlobalKey<FormState>();

  // Text Controllers for Login
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Text Controllers for Signup
  final signupEmailController = TextEditingController();
  final signupPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final recruiterNameController = TextEditingController();
  final recruiterPhoneController = TextEditingController();
  final recruiterDesignationController = TextEditingController();

  // Text Controllers for Company Setup
  final companyNameController = TextEditingController();
  final companyWebsiteController = TextEditingController();
  final companyDescriptionController = TextEditingController();
  final companyAddressController = TextEditingController();
  final companyPhoneController = TextEditingController();

  // Dropdown selections
  var selectedIndustry = 'Technology'.obs;
  var selectedCompanySize = 'Medium'.obs;
  var selectedDepartment = 'Human Resources'.obs;
  var isCompanyVerified = false.obs;

  // Options
  final industries = [
    'Technology',
    'Finance',
    'Healthcare',
    'Manufacturing',
    'Retail',
    'Education',
    'Consulting',
    'Real Estate',
    'Media & Entertainment',
    'Government',
    'Non-Profit',
    'Other',
  ];

  final companySizes = [
    'Startup (1-50)',
    'Small (51-200)',
    'Medium (201-1000)',
    'Large (1001-5000)',
    'Enterprise (5000+)',
  ];

  final departments = [
    'Human Resources',
    'Talent Acquisition',
    'Engineering',
    'Product Management',
    'Marketing',
    'Sales',
    'Operations',
    'Finance',
    'Other',
  ];

  @override
  void onInit() {
    super.onInit();
    // Auto-fill demo data for testing
    _fillDemoData();
  }

  @override
  void onClose() {
    // Dispose controllers
    emailController.dispose();
    passwordController.dispose();
    signupEmailController.dispose();
    signupPasswordController.dispose();
    confirmPasswordController.dispose();
    recruiterNameController.dispose();
    recruiterPhoneController.dispose();
    recruiterDesignationController.dispose();
    companyNameController.dispose();
    companyWebsiteController.dispose();
    companyDescriptionController.dispose();
    companyAddressController.dispose();
    companyPhoneController.dispose();
    super.onClose();
  }

  void _fillDemoData() {
    // Demo login data
    emailController.text = 'recruiter@techcorp.com';
    passwordController.text = 'password123';

    // Demo signup data
    signupEmailController.text = 'new.recruiter@company.com';
    recruiterNameController.text = 'John Recruiter';
    recruiterPhoneController.text = '+91 9876543210';
    recruiterDesignationController.text = 'Senior Talent Acquisition Manager';

    // Demo company data
    companyNameController.text = 'TechCorp Solutions';
    companyWebsiteController.text = 'https://techcorp.com';
    companyDescriptionController.text =
        'Leading technology company specializing in software development and digital transformation services.';
    companyAddressController.text = 'Bangalore, Karnataka, India';
    companyPhoneController.text = '+91 80 1234 5678';
  }

  void toggleAuthMode() {
    isLoginMode.value = !isLoginMode.value;
    currentStep.value = 0;
    clearForms();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  void clearForms() {
    loginFormKey.currentState?.reset();
    signupFormKey.currentState?.reset();
    companySetupFormKey.currentState?.reset();

    if (!isLoginMode.value) {
      // Don't clear login form when switching to signup
      emailController.clear();
      passwordController.clear();
    }
  }

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      // Mock validation
      if (emailController.text == 'recruiter@techcorp.com' &&
          passwordController.text == 'password123') {
        Get.snackbar(
          'Login Successful',
          'Welcome back! Redirecting to dashboard...',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );

        // Navigate to home/dashboard
        await Future.delayed(Duration(seconds: 1));
        Get.offAllNamed('/home');
      } else {
        Get.snackbar(
          'Login Failed',
          'Invalid email or password. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred during login. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signup() async {
    if (!signupFormKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      Get.snackbar(
        'Account Created',
        'Your recruiter account has been created successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Move to company setup step
      currentStep.value = 1;
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred during signup. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setupCompany() async {
    if (!companySetupFormKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 3));

      Get.snackbar(
        'Company Setup Complete',
        'Your company profile has been created. Awaiting verification...',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );

      // Move to verification step
      currentStep.value = 2;

      // Auto-verify after 2 seconds for demo
      await Future.delayed(Duration(seconds: 2));
      isCompanyVerified.value = true;

      Get.snackbar(
        'Verification Complete',
        'Your company has been verified! Welcome to Campus Connect.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );

      // Navigate to home after verification
      await Future.delayed(Duration(seconds: 1));
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred during company setup. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgotPassword() async {
    if (emailController.text.isEmpty) {
      Get.snackbar(
        'Email Required',
        'Please enter your email address first.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      Get.snackbar(
        'Reset Link Sent',
        'Password reset link has been sent to ${emailController.text}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send reset link. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendVerification() async {
    isLoading.value = true;

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 1));

      Get.snackbar(
        'Verification Sent',
        'Verification request has been sent to admin.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send verification request.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goBack() {
    if (currentStep.value > 0) {
      currentStep.value--;
    } else {
      isLoginMode.value = true;
    }
  }

  void skipCompanySetup() {
    Get.dialog(
      AlertDialog(
        title: Text('Skip Company Setup?'),
        content: Text(
          'You can complete your company profile later from settings. Continue without setup?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.offAllNamed('/home');
            },
            child: Text('Skip'),
          ),
        ],
      ),
    );
  }

  // Validation methods
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != signupPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!GetUtils.isPhoneNumber(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'Website URL is required';
    }
    if (!GetUtils.isURL(value)) {
      return 'Please enter a valid URL';
    }
    return null;
  }
}
