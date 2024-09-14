import 'package:chatting_app/modal/user_modal.dart';
import 'package:chatting_app/services/auth/auth_service.dart';
import 'package:chatting_app/services/chat/chat_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  var txtEmail = TextEditingController();
  var txtName = TextEditingController();
  var txtPassword = TextEditingController();
  var txtConfirmPassword = TextEditingController();
  var search = TextEditingController();
  String searchUser = '';
  RxBool passwordVisible = false.obs;

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
}

var chatController = Get.put(ChatController());
