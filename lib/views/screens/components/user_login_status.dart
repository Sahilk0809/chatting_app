import 'package:chatting_app/services/auth/auth_service.dart';
import 'package:chatting_app/views/screens/home_screen.dart';
import 'package:chatting_app/views/screens/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserLoginStatus extends StatelessWidget {
  const UserLoginStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return const HomeScreen();
        } else{
          return const SignInScreen();
        }
      },
    );
  }
}
