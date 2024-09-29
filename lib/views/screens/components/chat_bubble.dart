import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final bool isCurrentUser;
  final String message;
  final Timestamp timestamp;
  final void Function()? onLongPress;
  final String image;

  const ChatBubble({
    super.key,
    required this.isCurrentUser,
    required this.message,
    required this.timestamp,
    required this.onLongPress,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: const Radius.circular(15),
            bottomRight: const Radius.circular(15),
            topLeft: (isCurrentUser)
                ? const Radius.circular(15)
                : const Radius.circular(0),
            topRight: (isCurrentUser)
                ? const Radius.circular(0)
                : const Radius.circular(15),
          ),
          // borderRadius: BorderRadius.circular(20),
          gradient: (isCurrentUser)
              ? LinearGradient(
                  colors: [
                    Colors.green[700]!,
                    Colors.green[400]!,
                  ],
                )
              : const LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.white60,
                  ],
                ),
        ),
        child: (image.isEmpty || image == '')
            ? Text(
                message,
                style: TextStyle(
                  color: isCurrentUser ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              )
            : Image.network(
                image,
                fit: BoxFit.cover,
                height: 200,
              ),
      ),
    );
  }
}
