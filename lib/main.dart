import 'package:chatting_app/theme/theme.dart';
import 'package:chatting_app/views/screens/chat_screen.dart';
import 'package:chatting_app/views/screens/components/user_login_status.dart';
import 'package:chatting_app/views/screens/home_screen.dart';
import 'package:chatting_app/views/screens/sign_in_screen.dart';
import 'package:chatting_app/views/screens/sign_up_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      getPages: [
        GetPage(
          name: '/',
          page: () => const UserLoginStatus(),
          transition: Transition.rightToLeftWithFade,
        ),
        GetPage(
          name: '/home',
          page: () => const HomeScreen(),
          transition: Transition.rightToLeftWithFade,
        ),
        GetPage(
          name: '/signUp',
          page: () => const SignUpScreen(),
          transition: Transition.rightToLeftWithFade,
        ),
        GetPage(
          name: '/signIn',
          page: () => const SignInScreen(),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: '/chat',
          page: () => const ChatScreen(),
          transition: Transition.rightToLeftWithFade,
        ),
      ],
    );
  }
}
