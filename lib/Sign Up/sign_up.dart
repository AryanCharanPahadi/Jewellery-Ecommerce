import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellary/Component/show_pop_up.dart';
import 'package:jewellary/Sign%20Up/signup_controller.dart';
import '../Component/already_have_an_account.dart';
import '../Component/custom_text.dart';
import '../Component/gradient_button.dart';
import '../Login Page/login_page.dart';

class SignupContent extends StatefulWidget {
  SignupContent({super.key});

  @override
  State<SignupContent> createState() => _SignupContentState();
}

class _SignupContentState extends State<SignupContent> {
  final SignupController signupController = Get.put(SignupController());

  Widget buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool isObscure = false,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: isObscure,
      readOnly: readOnly,
      onTap: onTap,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        double padding = constraints.maxWidth > 600 ? 100.0 : 20.0;
        double width = constraints.maxWidth > 600 ? 500 : double.infinity;

        return Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Form(
              key: signupController.formKey,
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
                    const CustomTitleText(text: "Create Your Account"),
                    const SizedBox(height: 20),
                    buildTextField(
                      label: "Name",
                      icon: Icons.person,
                      controller: signupController.nameController,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter your name'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    buildTextField(
                      label: "Phone Number",
                      icon: Icons.phone,
                      controller: signupController.phoneController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Phone Number';
                        }
                        final RegExp phoneRegex = RegExp(r'^[6-9]\d{9}$');
                        return phoneRegex.hasMatch(value)
                            ? null
                            : 'Invalid Phone Number';
                      },
                    ),
                    const SizedBox(height: 20),
                    buildTextField(
                      label: "Email",
                      icon: Icons.email,
                      controller: signupController.emailController,
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
                      controller: signupController.passwordController,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter your Password'
                          : null,
                      isObscure: true,
                    ),
                    const SizedBox(height: 20),
                    buildTextField(
                      label: "Date of Birth",
                      icon: Icons.calendar_today,
                      controller: signupController.dobController,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please select your Date of Birth'
                          : null,
                      readOnly: true,
                      onTap: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (selectedDate != null) {
                          signupController.dobController.text =
                              "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    buildTextField(
                      label: "Anniversary Date",
                      icon: Icons.calendar_today,
                      controller: signupController.anniversaryController,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please select your Date of Birth'
                          : null,
                      readOnly: true,
                      onTap: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (selectedDate != null) {
                          signupController.anniversaryController.text =
                              "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    GradientButton(
                      text: "Sign Up",
                      onPressed: () => signupController.submitForm(context),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextWidgets.alreadyHaveAccountText(),
                          const SizedBox(height: 10),
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context); // Close the login page

                                PopupDialog(
                                  parentContext: context,
                                  childWidget: LoginPage(),
                                ).show(); // Show signup popup
                              },
                              child: CustomTextWidgets.signIn()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
