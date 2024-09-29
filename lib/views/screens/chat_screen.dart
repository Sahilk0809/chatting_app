import 'package:chatting_app/services/storage/storage_services.dart';
import 'package:chatting_app/views/screens/components/call_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:chatting_app/services/chat/chat_services.dart';
import 'package:chatting_app/services/auth/auth_service.dart';
import 'package:chatting_app/controller/chat_controller.dart';
import '../../modal/chat_modal.dart';
import 'components/chat_bubble.dart';
import 'components/my_text_field.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController scrollController = ScrollController();

  void scrollToBottom() {
    Future.delayed(
      const Duration(milliseconds: 300),
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
    // TODO: implement initState
    super.initState();
    scrollToBottom();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

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
            padding: const EdgeInsets.fromLTRB(10, 33, 10, 10),
            child: Column(
              children: [
                Obx(
                  () => (!chatController.toggleBar.value)
                      ? _buildNormalBar(width) // Normal AppBar
                      : _buildEditBar(width), // Edit Mode AppBar
                ),
                SizedBox(
                  height: height * 0.005,
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: ChatServices.chatServices.readMessagesFromFireStore(
                      chatController.receiverEmail.value,
                    ),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('');
                      }

                      var data = snapshot.data!.docs;
                      List<ChatModal> chatList = [];
                      List<String> docIdList = [];

                      for (var i in data) {
                        docIdList.add(i.id);
                        chatList.add(
                          ChatModal.fromMap(i.data() as Map<String, dynamic>),
                        );
                      }

                      return ListView.builder(
                        controller: scrollController,
                        itemCount: chatList.length,
                        itemBuilder: (context, index) {
                          bool isCurrentUser = chatList[index].sender ==
                              AuthService.authService.getCurrentUser()?.email;
                          var alignment = isCurrentUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft;

                          return Container(
                            margin: const EdgeInsets.all(2),
                            alignment: alignment,
                            child: ChatBubble(
                              isCurrentUser: isCurrentUser,
                              message: chatList[index].message!,
                              timestamp: chatList[index].timestamp!,
                              image: chatList[index].image!,
                              onLongPress: () {
                                if (isCurrentUser) {
                                  chatController.docId = docIdList[index];
                                  chatController.messageController =
                                      chatList[index].message;
                                  chatController.toggleBar.value = true;
                                }
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Obx(() {
                  return MyTextField(
                    controller: chatController.txtMessage,
                    minLines: 1,
                    maxLines: 12,
                    label: 'Message',
                    onChanged: (value) {
                      chatController.messageStore.value = value;
                      ChatServices.chatServices.toggleOnlineStatus(
                        true,
                        Timestamp.now(),
                        true,
                      );
                    },
                    onTapOutside: (event) {
                      ChatServices.chatServices.toggleOnlineStatus(
                        true,
                        Timestamp.now(),
                        false,
                      );
                    },
                    suffixIcon: _buildSendButton(),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNormalBar(double width) {
    return Row(
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
        SizedBox(width: width * 0.02),
        CircleAvatar(
          radius: 17,
          backgroundImage: NetworkImage(chatController.image.value),
        ),
        SizedBox(width: width * 0.02),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chatController.receiverName.value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
              ),
            ),
            StreamBuilder(
              stream: ChatServices.chatServices
                  .checkUserIsOnlineOrNot(chatController.receiverEmail.value),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('');
                }

                Map? user = snapshot.data!.data();
                String nightDay = '';
                String lastSeen = '';
                if (user!['timestamp'].toDate().hour > 11) {
                  nightDay = 'PM';
                } else {
                  nightDay = 'AM';
                }

                if (user['timestamp'].toDate().day ==
                    Timestamp.now().toDate().day) {
                  lastSeen =
                      'Last seen at ${user['timestamp'].toDate().hour % 12}:${user['timestamp'].toDate().minute} $nightDay';
                } else if (user['timestamp'].toDate().month ==
                    Timestamp.now().toDate().month) {
                  lastSeen =
                      'Last seen at ${user['timestamp'].toDate().day}/${user['timestamp'].toDate().month} ${user['timestamp'].toDate().hour % 12}:${user['timestamp'].toDate().minute} $nightDay';
                }

                return Text(
                  user['isOnline']
                      ? (user['isTyping'])
                          ? 'Typing...'
                          : 'Online'
                      : lastSeen,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ],
        ),
        const Spacer(),
        _buildCallAndVideoButtons(),
        PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'View Account',
              child: Text('View Account'),
            ),
            const PopupMenuItem(
              value: 'Media, links, and docs',
              child: Text('Media, links, and docs'),
            ),
            const PopupMenuItem(
              value: 'Report',
              child: Text('Report'),
            ),
            const PopupMenuItem(
              value: 'Block',
              child: Text('Block'),
            ),
            const PopupMenuItem(
              value: 'Wallpaper',
              child: Text('Wallpaper'),
            ),
            const PopupMenuItem(
              value: 'Clear chat',
              child: Text('Clear chat'),
            ),
          ],
          icon: const Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildEditBar(double width) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            chatController.toggleBar.value = false;
          },
          child: const Icon(
            Icons.arrow_back_outlined,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            chatController.showEditDeleteDialog(
              chatController.docId!,
              chatController.messageController!,
              chatController.receiverEmail.value,
              context,
            );
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () {
            chatController.copyMessage(chatController.messageController!);
            chatController.toggleBar.value = false;
          },
          icon: const Icon(
            Icons.copy,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            CupertinoIcons.arrow_turn_up_right,
            color: Colors.white,
          ),
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'Info':
                break;
              case 'Copy':
                break;
              case 'Edit':
                // Set message in the text field for editing
                chatController.txtMessage.text =
                    chatController.messageController!;
                chatController.isEditing.value = true;
                chatController.messageIdToEdit.value = chatController.docId!;
                chatController.toggleBar.value = false;
                break;
              case 'Pin':
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'Info',
              child: Text('Info'),
            ),
            const PopupMenuItem(
              value: 'Copy',
              child: Text('Copy'),
            ),
            const PopupMenuItem(
              value: 'Edit',
              child: Text('Edit'),
            ),
            const PopupMenuItem(
              value: 'Pin',
              child: Text('Pin'),
            ),
          ],
          icon: const Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildCallAndVideoButtons() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CallPage(isVideoCall: true),
              ),
            );
          },
          icon: const Icon(
            CupertinoIcons.video_camera_solid,
            size: 32,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CallPage(isVideoCall: false),
              ),
            );
          },
          icon: const Icon(Icons.call, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildSendButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () async {
            String url =
                await StorageServices.storageServices.uploadImageToStorage();
            chatController.uploadImageToStorage(url);
          },
          icon: const Icon(Icons.image),
        ),
        IconButton(
          onPressed: () async {
            String messageText = chatController.txtMessage.text.trim();
            if (chatController.imageStore.value.isNotEmpty) {
              ChatModal chat = ChatModal(
                receiver: chatController.receiverEmail.value,
                message: '',
                sender: AuthService.authService.getCurrentUser()!.email,
                timestamp: Timestamp.now(),
                image: chatController.imageStore.value,
              );
              chatController.txtMessage.clear();
              chatController.uploadImageToStorage("");
              await ChatServices.chatServices.addMessageToFireStore(chat);
              scrollToBottom();
            }
            if (messageText.isNotEmpty) {
              if (chatController.isEditing.value) {
                ChatServices.chatServices.updateMessageInFireStore(
                  chatController.messageIdToEdit.value,
                  chatController.receiverEmail.value,
                  messageText,
                );
                chatController.txtMessage.clear();
                chatController.messageIdToEdit.value = '';
                chatController.isEditing.value = false;
                scrollToBottom();
              } else {
                ChatModal chat = ChatModal(
                  receiver: chatController.receiverEmail.value,
                  message: messageText,
                  sender: AuthService.authService.getCurrentUser()!.email,
                  timestamp: Timestamp.now(),
                  image: chatController.imageStore.value,
                );
                chatController.txtMessage.clear();
                await ChatServices.chatServices.addMessageToFireStore(chat);
                scrollToBottom();
              }
              await ChatServices.chatServices.toggleOnlineStatus(
                true,
                Timestamp.now(),
                false,
              );
            }
          },
          icon: chatController.isEditing.value
              ? const Icon(Icons.check)
              : Icon(
                  Icons.send,
                  color: (chatController.messageStore.trim().isEmpty)
                      ? Colors.grey
                      : (chatController.isDark.value) ? Colors.black : Colors.blueGrey,
                ),
        ),
      ],
    );
  }
}
