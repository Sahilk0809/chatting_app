import 'package:chatting_app/controller/chat_controller.dart';
import 'package:chatting_app/modal/user_modal.dart';
import 'package:chatting_app/services/auth/auth_service.dart';
import 'package:chatting_app/services/chat/chat_services.dart';
import 'package:chatting_app/views/screens/chat_screen.dart';
import 'package:chatting_app/views/screens/components/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: FutureBuilder(
          future: ChatServices.chatServices.getCurrentUserFromFireStore(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            Map? data = snapshot.data!.data();
            UserModal userModal = UserModal.fromMap(data!);
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueGrey.shade800, Colors.blueGrey.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  DrawerHeader(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(userModal.image),
                    ),
                  ),
                  Text(
                    userModal.name,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueGrey[800],
        title: const Text('WhatsApp'),
        actions: [
          IconButton(
            onPressed: () {
              AuthService.authService.signOut();
            },
            icon: const Icon(Icons.logout),
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
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                MyTextField(
                  controller: chatController.search,
                  label: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  onChanged: (String value) {},
                ),
                const SizedBox(
                  height: 10,
                ),
                StreamBuilder(
                  stream: ChatServices.chatServices.getAllUsersFromFireStore(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Expanded(
                        child: Shimmer.fromColors(
                          baseColor: Colors.white.withOpacity(0.2),
                          highlightColor: Colors.white.withOpacity(0.2),
                          child: ListView.builder(
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor:
                                      Colors.white.withOpacity(0.2),
                                ),
                                title: Container(
                                  height: 10,
                                  width: double.infinity,
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                subtitle: Container(
                                  height: 10,
                                  width: double.infinity,
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }

                    List data = snapshot.data!.docs;
                    List<UserModal> userList = [];
                    for (var user in data) {
                      userList.add(UserModal.fromMap(user.data()));
                    }
                    return Expanded(
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: userList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              chatController.getReceiver(
                                userList[index].email,
                                userList[index].name,
                              );
                              image = userList[index].image;
                              Get.toNamed('/chat');
                            },
                            leading: CircleAvatar(
                              backgroundColor: Colors.white.withOpacity(0.2),
                              backgroundImage:
                                  NetworkImage(userList[index].image),
                            ),
                            title: Text(
                              userList[index].name,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              lastMessage,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String? image;