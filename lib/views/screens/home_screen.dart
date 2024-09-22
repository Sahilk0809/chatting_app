import 'package:chatting_app/controller/chat_controller.dart';
import 'package:chatting_app/modal/user_modal.dart';
import 'package:chatting_app/services/auth/auth_service.dart';
import 'package:chatting_app/services/chat/chat_services.dart';
import 'package:chatting_app/views/screens/components/my_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ChatServices.chatServices.toggleOnlineStatus(true, Timestamp.now());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.paused){
      ChatServices.chatServices.toggleOnlineStatus(false, Timestamp.now());
    } else if(state == AppLifecycleState.resumed){
      ChatServices.chatServices.toggleOnlineStatus(true, Timestamp.now());
    } else if(state == AppLifecycleState.inactive){
      ChatServices.chatServices.toggleOnlineStatus(false, Timestamp.now());
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: FutureBuilder(
          future: ChatServices.chatServices.getCurrentUserFromFireStore(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  style: TextStyle(color: Colors.grey.shade700),
                ),
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
                  colors: [Colors.blueGrey.shade700, Colors.blueGrey.shade500],
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      userModal.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Colors.white.withOpacity(0.6),
                    ),
                    title: const Text(
                      'Profile',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.settings,
                      color: Colors.white.withOpacity(0.6),
                    ),
                    title: const Text(
                      'Settings',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Are you sure!"),
                          content: const Text('Do you want to logout'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                AuthService.authService.signOut();
                                ChatServices.chatServices.toggleOnlineStatus(false, Timestamp.now());
                                Get.offAndToNamed('/');
                              },
                              child: const Text('Logout'),
                            ),
                          ],
                        ),
                      );
                    },
                    leading: Icon(
                      Icons.logout,
                      color: Colors.white.withOpacity(0.6),
                    ),
                    title: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                      ),
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
        backgroundColor: Colors.blueGrey.shade700,
        title: const Text(
          'Chat',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(seconds: 15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueGrey.shade700, Colors.blueGrey.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                MyTextField(
                  controller: chatController.search,
                  label: 'Search...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: StreamBuilder(
                    stream:
                        ChatServices.chatServices.getAllUsersFromFireStore(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            snapshot.error.toString(),
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade700,
                          highlightColor: Colors.grey.shade500,
                          child: ListView.builder(
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.grey.shade600,
                                ),
                                title: Container(
                                  height: 10,
                                  width: double.infinity,
                                  color: Colors.grey.shade600,
                                ),
                                subtitle: Container(
                                  height: 10,
                                  width: double.infinity,
                                  color: Colors.grey.shade600,
                                ),
                              );
                            },
                          ),
                        );
                      }

                      List data = snapshot.data!.docs;
                      List<UserModal> userList = [];
                      for (var user in data) {
                        userList.add(UserModal.fromMap(user.data()));
                      }
                      return ListView.builder(
                        itemCount: userList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              chatController.getReceiver(
                                userList[index].email,
                                userList[index].name,
                              );
                              chatController.image.value =
                                  userList[index].image;
                              Get.toNamed('/chat');
                            },
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 5.0),
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(userList[index].image),
                              radius: 23,
                            ),
                            title: Text(
                              userList[index].name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              'Last message preview',
                              style: TextStyle(color: Colors.grey.shade400),
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
        ],
      ),
    );
  }
}

String? image;
