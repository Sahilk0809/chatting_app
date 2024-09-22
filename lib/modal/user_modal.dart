import 'package:cloud_firestore/cloud_firestore.dart';

class UserModal {
  late String name, email, token, image;
  late bool isOnline;
  late Timestamp timestamp;

  UserModal({
    required this.name,
    required this.email,
    required this.token,
    required this.image,
    required this.isOnline,
    required this.timestamp,
  });

  factory UserModal.fromMap(Map m1) {
    return UserModal(
      name: m1['name'],
      email: m1['email'],
      token: m1['token'],
      image: m1['image'],
      isOnline: m1['isOnline'] ?? false,
      timestamp: m1['timestamp'],
    );
  }
}
