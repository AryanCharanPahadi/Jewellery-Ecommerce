import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellary/Component/already_have_an_account.dart';
import 'package:jewellary/Component/show_pop_up.dart';
import 'package:jewellary/Login%20Page/login_controller.dart';
import '../Component/custom_text.dart';
import '../Component/gradient_button.dart';
import '../Sign Up/sign_up.dart';

class LoginPage extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());

  LoginPage({super.key});

  Widget buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool isObscure = false,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final constraints = MediaQuery.of(context).size;
    double padding = constraints.width > 600 ? 100.0 : 30.0;
    double width = constraints.width > 600 ? 500 : double.infinity;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Form(
          key: loginController.formKey,
          child: Container(
            padding: const EdgeInsets.all(20),
            width: width,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close, color: Colors.red),
                  ),
                ),
                const CustomTitleText(text: "Login Here"),
                const SizedBox(height: 20),
                buildTextField(
                  label: "Email",
                  icon: Icons.email,
                  controller: loginController.emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Email';
                    }
                  return null;
                  },
                ),
                const SizedBox(height: 20),
                buildTextField(
                  label: "Password",
                  icon: Icons.lock,
                  controller: loginController.passwordController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your Password'
                      : null,
                  isObscure: true,
                ),
                const SizedBox(height: 30),
                GradientButton(
                  text: "Sign In",
                  onPressed: () => loginController.login(context),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextWidgets.doNotAlreadyHaveAccountText(),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // Close the login page
                          PopupDialog(
                            parentContext: context,
                            childWidget: SignupContent(),
                          ).show(); // Show signup popup
                        },
                        child: CustomTextWidgets.signUp(),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
