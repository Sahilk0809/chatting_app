import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:chatting_app/services/chat/chat_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class NotificationServices {
  NotificationServices._();

  static NotificationServices notificationServices = NotificationServices._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> getFirebaseMessagingToken() async {
    NotificationSettings notificationSettings =
        await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    await _messaging.getToken().then(
      (value) {
        if (value != null) {
          ChatServices.chatServices.updateToken(value);
          // FirebaseMessaging.onBackgroundMessage();
          // FirebaseMessaging.onMessage.listen();
          log("----------------token $value-------------------------");
        } else {
          log("-------------------------null--------------------");
        }
      },
    );
  }
}
