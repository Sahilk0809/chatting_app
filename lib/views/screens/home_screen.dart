import 'package:chatting_app/controller/chat_controller.dart';
import 'package:chatting_app/modal/user_modal.dart';
import 'package:chatting_app/services/auth/auth_service.dart';
import 'package:chatting_app/services/chat/chat_services.dart';
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
            return Column(
              children: [
                DrawerHeader(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(userModal.image),
                  ),
                ),
                Text(userModal.name),
              ],
            );
          },
        ),
      ),
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
              onChanged: (String value) {},
            ),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder(
              future: ChatServices.chatServices.getAllUsersFromFireStore(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Expanded(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                            ),
                            title: Container(
                              height: 10,
                              width: double.infinity,
                              color: Colors.white,
                            ),
                            subtitle: Container(
                              height: 10,
                              width: double.infinity,
                              color: Colors.white,
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
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          chatController.getReceiver(
                            userList[index].email,
                            userList[index].name,
                          );
                          Get.toNamed('/chat');
                        },
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(userList[index].image),
                        ),
                        title: Text(userList[index].name),
                        subtitle: Text(userList[index].email),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
