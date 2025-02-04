import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellary/Component/already_have_an_account.dart';
import 'package:jewellary/Component/custom_container_login_signup.dart';
import 'package:jewellary/Component/custom_text_field.dart';
import 'package:jewellary/Component/show_pop_up.dart';
import 'package:jewellary/Login%20Page/login_controller.dart';
import '../Component/custom_text.dart';
import '../Component/gradient_button.dart';
import '../Component/responsive_padding_component.dart';
import '../Sign Up/sign_up.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    ResponsivePaddingWidth responsive = ResponsivePaddingWidth(context);

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: responsive.padding),
        child: Form(
          key: loginController.formKey,
          child: CustomContainer(
            width: responsive.width,
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
                CustomTextField(
                  label: "Email",
                  icon: Icons.email,
                  controller: loginController.emailController,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: "Password",
                  icon: Icons.lock,
                  controller: loginController.passwordController,
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
                            childWidget: const SignupContent(),
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
