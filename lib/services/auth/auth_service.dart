import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../chat/chat_services.dart';

class AuthService {
  AuthService._();

  static AuthService authService = AuthService._();
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  User? user;
  UserCredential? userCredential;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<UserCredential> createAccountUsingEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Get.snackbar('Invalid!', e.code);
    }
  }

  Future<UserCredential> signInUsingEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Get.snackbar('Invalid!', 'Invalid password or email!');
    }
  }

  Future<void> signUpUsingGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        userCredential = await _auth.signInWithCredential(authCredential);
        await ChatServices.chatServices.addUserToFireStore(
          userCredential!.user!.displayName!,
          userCredential!.user!.email!,
          userCredential!.user!.photoURL!,
          '',
        );
        Get.offAndToNamed('/home');
      }
    } on FirebaseAuthException catch (e) {
      throw Get.snackbar('Error!', e.code);
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
