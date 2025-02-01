import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Api Helper/api_helper.dart';
import '../Shared Preferences/shared_preferences_helper.dart';
import 'login_student_modal.dart';

class LoginController extends GetxController {
  // Form keys and controllers
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  void login(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final loginModal = LoginModal(
      email: emailController.text,
      password: passwordController.text,
    );

    // API login response
    final loginResponse = await ApiService.login(loginModal, context);

    // Save login status and user details if login is successful
    await SharedPreferencesHelper.saveLoginStatus(true);
    await SharedPreferencesHelper.saveUserDetails(loginResponse);

    // Navigate to home page or dashboard
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        Navigator.pop(context); // Close the popup
      }
    });

    // Clear the form fields after submission

    clearFields();
  }

  // Clear input fields
  void clearFields() {
    emailController.clear();
    passwordController.clear();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
