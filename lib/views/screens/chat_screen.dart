import 'package:chatting_app/controller/chat_controller.dart';
import 'package:chatting_app/modal/chat_modal.dart';
import 'package:chatting_app/services/auth/auth_service.dart';
import 'package:chatting_app/services/chat/chat_services.dart';
import 'package:chatting_app/views/screens/components/chat_bubble.dart';
import 'package:chatting_app/views/screens/components/my_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController scrollController = ScrollController();

  void scrollToBottom() {
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
          );
        }
      },
    );
  }

  @override
  void initState() {
    scrollToBottom();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueGrey[800],
        leading: const Text(''),
        title: const Text('WhatsApp'),
        actions: [
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
            width: width * 0.02,
          ),
          CircleAvatar(
            radius: 17,
            backgroundImage: NetworkImage(image!),
          ),
          SizedBox(
            width: width * 0.02,
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
            margin: const EdgeInsets.only(right: 10),
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
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Row(
                //   children: [
                //     GestureDetector(
                //       onTap: () {
                //         Get.offAndToNamed('/home');
                //       },
                //       child: const Icon(
                //         Icons.arrow_back_outlined,
                //         color: Colors.white,
                //       ),
                //     ),
                //     SizedBox(
                //       width: width * 0.02,
                //     ),
                //     CircleAvatar(
                //       radius: 17,
                //       backgroundImage: NetworkImage(image!),
                //     ),
                //     SizedBox(
                //       width: width * 0.02,
                //     ),
                //     Text(
                //       chatController.receiverName.value,
                //       style: const TextStyle(
                //         color: Colors.white,
                //         fontSize: 20,
                //       ),
                //     ),
                //     const Spacer(),
                //     Container(
                //       height: height * 0.05,
                //       width: width * 0.1,
                //       decoration: BoxDecoration(
                //         shape: BoxShape.circle,
                //         color: Colors.white.withOpacity(0.3),
                //       ),
                //       child: const Icon(
                //         Icons.call,
                //         color: Colors.white,
                //       ),
                //     ),
                //     SizedBox(
                //       width: width * 0.03,
                //     ),
                //     Container(
                //       height: height * 0.05,
                //       width: width * 0.1,
                //       decoration: BoxDecoration(
                //         shape: BoxShape.circle,
                //         color: Colors.white.withOpacity(0.3),
                //       ),
                //       child: const Icon(
                //         CupertinoIcons.video_camera_solid,
                //         color: Colors.white,
                //         size: 30,
                //       ),
                //     ),
                //   ],
                // ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: StreamBuilder(
                          stream: ChatServices.chatServices
                              .readMessagesFromFireStore(
                                  chatController.receiverEmail.value),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(snapshot.error.toString()),
                              );
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            List data = snapshot.data!.docs;
                            List<ChatModal> chatList = [];

                            for (var i in data) {
                              chatList.add(ChatModal.fromMap(i.data() as Map));
                            }

                            return ListView.builder(
                              controller: scrollController,
                              itemCount: chatList.length,
                              itemBuilder: (context, index) {
                                bool isCurrentUser = chatList[index].sender ==
                                    AuthService.authService
                                        .getCurrentUser()!
                                        .email;
                                var alignment = isCurrentUser
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft;
                                return Container(
                                  alignment: alignment,
                                  child: Column(
                                    crossAxisAlignment: isCurrentUser
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                    children: [
                                      ChatBubble(
                                        isCurrentUser: isCurrentUser,
                                        message: chatList[index].message!,
                                        timestamp: chatList[index].timestamp!,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.005,
                ),
                MyTextField(
                  controller: chatController.txtMessage,
                  label: 'Message',
                  suffixIcon: IconButton(
                    onPressed: () async {
                      // Trim the message text before checking if it's empty
                      String messageText =
                          chatController.txtMessage.text.trim();

                      if (messageText.isNotEmpty) {
                        ChatModal chat = ChatModal(
                          receiver: chatController.receiverEmail.value,
                          message: messageText, // Use the trimmed message text
                          sender:
                              AuthService.authService.getCurrentUser()!.email,
                          timestamp: Timestamp.now(),
                        );
                        chatController.txtMessage.clear();
                        scrollToBottom();
                        await ChatServices.chatServices
                            .addMessageToFireStore(chat);
                      }
                    },
                    icon: const Icon(Icons.send),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
