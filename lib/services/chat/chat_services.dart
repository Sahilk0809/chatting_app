import 'package:chatting_app/modal/chat_modal.dart';
import 'package:chatting_app/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatServices {
  ChatServices._();

  static final ChatServices chatServices = ChatServices._();
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  User? user = AuthService.authService.getCurrentUser();

  Future<void> addUserToFireStore(
      String name, String email, String image, String token) async {
    final docRef = await _fireStore.collection('users').doc(email).set({
      'name': name,
      'email': email,
      'token': token,
      'image': image,
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>>
      getCurrentUserFromFireStore() async {
    return await _fireStore.collection('users').doc(user!.email).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> searchUser(String value) async {
    return await _fireStore
        .collection('users')
        .where("name", isEqualTo: value)
        .get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsersFromFireStore() {
    return _fireStore
        .collection('users')
        .where("email", isNotEqualTo: user!.email)
        .snapshots();
  }

  Future<void> addMessageToFireStore(ChatModal chat) async {
    String? sender = chat.sender;
    String? receiver = chat.receiver;
    List doc = [sender, receiver];
    doc.sort();
    String docId = doc.join("_");
    await _fireStore
        .collection("chatroom")
        .doc(docId)
        .collection("chat")
        .add(chat.toMap(chat));
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> readMessagesFromFireStore(
      String receiver) {
    String sender = AuthService.authService.getCurrentUser()!.email!;
    List doc = [sender, receiver];
    doc.sort();
    String docId = doc.join("_");
    return _fireStore
        .collection("chatroom")
        .doc(docId)
        .collection("chat")
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
