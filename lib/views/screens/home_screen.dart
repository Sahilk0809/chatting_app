import 'package:chatting_app/controller/chat_controller.dart';
import 'package:chatting_app/services/auth/auth_service.dart';
import 'package:chatting_app/views/screens/components/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WhatsApp'),
        actions: [
          IconButton(
            onPressed: () async {
              await AuthService.authService.signOut();
              Get.offAndToNamed('/');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            MyTextField(
              controller: chatController.search,
              label: 'Search',
              prefixIcon: const Icon(Icons.search),
            ),
          ],
        ),
      ),
    );
  }
}
