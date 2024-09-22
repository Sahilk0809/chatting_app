import 'package:chatting_app/controller/chat_controller.dart';
import 'package:chatting_app/services/auth/auth_service.dart';
import 'package:chatting_app/views/screens/components/google_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'components/button.dart';
import 'components/my_text_field.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          AnimatedContainer(
            duration: const Duration(seconds: 15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueGrey.shade800, Colors.blueGrey.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
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
                    height: height * 0.16,
                  ),
                  // Animated icon with zoom effect
                  ZoomIn(
                    child: const Icon(
                      Icons.message,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Fade-in text
                  FadeInUp(
                    duration: const Duration(seconds: 1),
                    child: const Text(
                      'Create your account',
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
                  FadeInLeft(
                    duration: const Duration(milliseconds: 800),
                    child: MyTextField(
                      controller: chatController.txtName,
                      label: 'Name',
                      prefixIcon: const Icon(
                        Icons.account_circle,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  // Animated Email TextField
                  FadeInLeft(
                    duration: const Duration(milliseconds: 800),
                    child: MyTextField(
                      controller: chatController.txtEmail,
                      label: 'Email',
                      prefixIcon: const Icon(
                        Icons.mail,
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
                        prefixIcon: const Icon(
                          Icons.lock,
                        ),
                        obscureText: chatController.passwordVisible.value,
                        suffixIcon: IconButton(
                          onPressed: () {
                            chatController.passwordVisible.value =
                                !chatController.passwordVisible.value;
                          },
                          icon: (chatController.passwordVisible.value)
                              ? const Icon(
                                  Icons.visibility_off,
                                )
                              : const Icon(
                                  Icons.visibility,
                                ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  // Animated Confirm Password TextField
                  Obx(
                    () => FadeInLeft(
                      duration: const Duration(milliseconds: 800),
                      child: MyTextField(
                        controller: chatController.txtConfirmPassword,
                        label: 'Confirm Password',
                        prefixIcon: const Icon(
                          Icons.lock,
                        ),
                        obscureText: chatController.passwordVisible.value,
                        suffixIcon: IconButton(
                          onPressed: () {
                            chatController.passwordVisible.value =
                                !chatController.passwordVisible.value;
                          },
                          icon: (chatController.passwordVisible.value)
                              ? const Icon(
                                  Icons.visibility_off,
                                )
                              : const Icon(
                                  Icons.visibility,
                                ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  // Gesture for navigation to Sign-In screen
                  GestureDetector(
                    onTap: () {
                      chatController.txtEmail.clear();
                      chatController.txtPassword.clear();
                      chatController.txtConfirmPassword.clear();
                      Get.offAndToNamed('/signIn');
                    },
                    child: const Text(
                      "Already have an account? Sign In",
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
                  // Animated Sign-Up button
                  ZoomIn(
                    child: MyButton(
                      text: 'Sign Up',
                      onTap: () {
                        chatController.createAccountValidation(
                          email: chatController.txtEmail.text,
                          password: chatController.txtPassword.text,
                          confirmPassword:
                              chatController.txtConfirmPassword.text,
                          name: chatController.txtName.text,
                          image:
                              'https://www.pngkit.com/png/detail/25-258694_cool-avatar-transparent-image-cool-boy-avatar.png',
                          token: '',
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
