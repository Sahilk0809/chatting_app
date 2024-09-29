import 'package:chatting_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () async {
        AuthService.authService.signUpUsingGoogle();
        // Get.toNamed('/authGate');
      },
      child: Container(
        height: height * 0.065,
        width: width,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[900],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/googleLogo.png',
              height: 40,
            ),
            SizedBox(
              width: width * 0.04,
            ),
            const Text(
              'Sign In with Google',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
