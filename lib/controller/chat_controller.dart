import 'package:chatting_app/services/auth/auth_service.dart';
import 'package:chatting_app/services/chat/chat_services.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  // controllers for textFields
  var txtEmail = TextEditingController();
  var txtName = TextEditingController();
  var txtPassword = TextEditingController();
  var txtConfirmPassword = TextEditingController();
  var txtMessage = TextEditingController();
  var search = TextEditingController();
  String searchUser = '';
  RxBool passwordVisible = false.obs; // to check password is visible or not
  RxString receiverEmail = ''.obs; // storing receiver email
  RxString receiverName = ''.obs; // storing receiver name
  RxString image = ''.obs; // image of selected user
  RxString messageStore =
      ''.obs; // storing message to change the color of send msg
  RxBool toggleBar = false.obs; // to toggle the appbar
  String? docId, messageController; // to delete the particular msg

  // Boolean to track if the user is editing
  RxBool isEditing = false.obs;
  RxString messageIdToEdit = ''.obs;

  // to check if user is typing or not
  RxBool isTyping = false.obs;

  // token to send notification
  RxString deviceToken = ''.obs;

  // to store image to send by the user
  RxString imageStore = ''.obs;

  // to check whether the it is dark mode or light mode
  RxBool isDark = false.obs;

  // toggle the light dark mode

  void toggleLightDarkMode(){
    isDark.value = !isDark.value;
  }

  void uploadImageToStorage(String url) {
    imageStore.value = url;
  }

  Future<void> createAccountValidation({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
    required String image,
    required String token,
  }) async {
    if (name != '' && name.isNotEmpty) {
      if (email.contains(RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$')) &&
          email.isNotEmpty) {
        if (password.length >= 6) {
          if (password == confirmPassword) {
            await AuthService.authService.createAccountUsingEmailAndPassword(
              email,
              password,
            );
            await ChatServices.chatServices
                .addUserToFireStore(name, email, image, token);

            txtEmail.clear();
            txtConfirmPassword.clear();
            txtPassword.clear();
            txtName.clear();
            Get.toNamed('/');
          } else {
            Get.snackbar('Invalid!', 'Passwords not match');
          }
        } else {
          Get.snackbar('Invalid!', 'Password must be 6 character long');
        }
      } else {
        Get.snackbar('Invalid!', 'Invalid Email Address');
      }
    } else {
      Get.snackbar('Invalid!', 'Enter name');
    }
  }

  void getReceiver(String email, String name) {
    receiverEmail.value = email;
    receiverName.value = name;
  }

  // to copy the message
  void copyMessage(String message) {
    FlutterClipboard.copy(message);
  }

  // General Dialog for Edit or Delete
  void showEditDeleteDialog(String messageId, String message,
      String receiverEmail, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Delete',
          ),
          content: const Text('Do you want to delete this message?'),
          actions: [
            TextButton(
              child: const Text(
                'Cancel',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                // Delete the message from Firestore
                ChatServices.chatServices.deleteMessageFromFireStore(
                  messageId,
                  receiverEmail,
                );
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }
}

var chatController = Get.put(ChatController());
