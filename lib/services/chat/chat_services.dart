import 'package:cloud_firestore/cloud_firestore.dart';

class ChatServices {
  ChatServices._();

  static final ChatServices chatServices = ChatServices._();
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<void> addUserToFireStore(
      String name, String email, String image, String token) async {
    final docRef = await _fireStore.collection('users').add({
      'name': name,
      'email': email,
      'token': token,
      'image': image,
    });
  }
}
