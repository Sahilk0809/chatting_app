import 'package:chatting_app/controller/chat_controller.dart';
import 'package:chatting_app/modal/user_modal.dart';
import 'package:chatting_app/services/auth/auth_service.dart';
import 'package:chatting_app/services/chat/chat_services.dart';
import 'package:chatting_app/views/screens/components/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                  return const Center(
                    child: CircularProgressIndicator(),
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
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(userList[index].image),
                        ),
                        title: Text(userList[index].name),
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
