import 'package:chatting_app/controller/chat_controller.dart';
import 'package:chatting_app/services/auth/auth_service.dart';
import 'package:chatting_app/views/screens/components/google_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'components/button.dart';
import 'components/my_text_field.dart';
import 'package:animate_do/animate_do.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Obx(
            () => Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    (chatController.isDark.value)
                        ? Colors.black
                        : Colors.blueGrey.shade700,
                    (chatController.isDark.value)
                        ? Colors.grey[800]!
                        : Colors.blueGrey.shade500
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: height * 0.2,
                  ),
                  // Animated icon with zoom effect
                  ZoomIn(
                    child: const Icon(
                      Icons.chat_bubble_outline,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Fade-in welcome text
                  FadeInUp(
                    duration: const Duration(seconds: 1),
                    child: const Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  // Animated Email TextField
                  FadeInLeft(
                    duration: const Duration(milliseconds: 800),
                    child: MyTextField(
                      controller: chatController.txtEmail,
                      label: 'Email',
                      prefixIcon: Icon(
                        Icons.mail,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  // Animated Password TextField with show/hide feature
                  Obx(
                    () => FadeInLeft(
                      duration: const Duration(milliseconds: 800),
                      child: MyTextField(
                        controller: chatController.txtPassword,
                        label: 'Password',
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        obscureText: chatController.passwordVisible.value,
                        suffixIcon: IconButton(
                          onPressed: () {
                            chatController.passwordVisible.value =
                                !chatController.passwordVisible.value;
                          },
                          icon: (chatController.passwordVisible.value)
                              ? Icon(
                                  Icons.visibility_off,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                )
                              : Icon(
                                  Icons.visibility,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  // Gesture for navigation to Sign-Up screen
                  GestureDetector(
                    onTap: () {
                      chatController.txtEmail.clear();
                      chatController.txtPassword.clear();
                      Get.toNamed('/signUp');
                    },
                    child: const Text(
                      "Don't have an account? Sign Up",
                      style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  // Animated Sign-In button
                  ZoomIn(
                    child: MyButton(
                      text: 'Sign In',
                      onTap: () async {
                        await AuthService.authService
                            .signInUsingEmailAndPassword(
                          chatController.txtEmail.text,
                          chatController.txtPassword.text,
                        );
                        chatController.txtEmail.clear();
                        chatController.txtPassword.clear();
                        Get.offAndToNamed('/');
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Fade-in "Or" text
                  const Text(
                    'Or',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Google sign-in button
                  const GoogleButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
