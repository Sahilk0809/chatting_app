import 'package:chatting_app/controller/chat_controller.dart';
import 'package:chatting_app/modal/chat_modal.dart';
import 'package:chatting_app/services/auth/auth_service.dart';
import 'package:chatting_app/views/screens/components/my_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
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
                    height: height * 0.03,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.offAndToNamed('/home');
                        },
                        child: const Icon(
                          Icons.arrow_back_outlined,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.03,
                      ),
                      Text(
                        chatController.receiverName.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: height * 0.05,
                        width: width * 0.1,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        child: const Icon(
                          Icons.call,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.03,
                      ),
                      Container(
                        height: height * 0.05,
                        width: width * 0.1,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        child: const Icon(
                          CupertinoIcons.video_camera_solid,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.82,
                  ),
                  // StreamBuilder(stream:, builder: (context, snapshot) {
                  //
                  // },),

                  MyTextField(
                    controller: chatController.txtMessage,
                    label: 'Message',
                    suffixIcon: IconButton(
                      onPressed: () {
                        ChatModal(
                          receiver: chatController.receiverEmail.value,
                          message: chatController.txtMessage.text,
                          sender:
                              AuthService.authService.getCurrentUser()!.email,
                          timestamp: Timestamp.now(),
                        );
                        chatController.txtMessage.clear();
                      },
                      icon: const Icon(Icons.send),
                    ),
                  ),

                  // TextField(
                  //   cursorColor: Colors.white.withOpacity(0.3),
                  //   decoration: InputDecoration(
                  //     hintText: 'Message',
                  //     hintStyle:
                  //     TextStyle(color: Colors.white.withOpacity(0.3)),
                  //     enabledBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //       borderSide: BorderSide(
                  //         width: 1,
                  //         color: Colors.white.withOpacity(0.3),
                  //       ),
                  //     ),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //       borderSide: BorderSide(
                  //         width: 1,
                  //         color: Colors.white.withOpacity(0.3),
                  //       ),
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //       borderSide: BorderSide(
                  //         width: 2,
                  //         color: Colors.white.withOpacity(0.3),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
