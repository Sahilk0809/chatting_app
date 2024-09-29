import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModal {
  String? receiver, sender, message, image;
  Timestamp? timestamp;

  ChatModal({
    required this.receiver,
    required this.message,
    required this.sender,
    required this.timestamp,
    required this.image,
  });

  factory ChatModal.fromMap(Map m1) {
    return ChatModal(
      receiver: m1['receiver'],
      message: m1['message'],
      sender: m1['sender'],
      timestamp: m1['timestamp'],
      image: m1['image'],
    );
  }

  Map<String, dynamic> toMap(ChatModal chat) {
    return {
      'sender': chat.sender,
      'receiver': chat.receiver,
      'message': chat.message,
      'timestamp': chat.timestamp,
      'image': chat.image,
    };
  }
}