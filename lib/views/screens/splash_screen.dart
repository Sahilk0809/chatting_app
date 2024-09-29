import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/chat_controller.dart';
import '../../controller/theme_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 4),
      () {
        Get.offAllNamed('/authGate');
      },
    );
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Obx(
              () => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      (themeController.isDark.value)
                          ? Colors.black
                          : Colors.blueGrey.shade700,
                      (themeController.isDark.value)
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
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(
                    //   height: 120,
                    //   width: 120,
                    //   child: LottieBuilder.asset(
                    //     'assets/lottie/Animation - 1723794246779.json',
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                    ZoomIn(
                      duration: const Duration(seconds: 1),
                      child: const Icon(
                        Icons.message_outlined,
                        size: 90,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ZoomIn(
                      duration: const Duration(seconds: 1),
                      child: const Text(
                        'ChatterFlow',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          letterSpacing: 4,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
