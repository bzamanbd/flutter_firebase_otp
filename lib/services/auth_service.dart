import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/home_screen.dart';

class AuthService {
///step 8: creating firebase auth instance///
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

///step 9: creating auth credential to login with otp///
  Future<void> singInWithPhoneAuthCredential(
      AuthCredential phoneAuthCredential, context) async {
    try {
      final authCred =
          await firebaseAuth.signInWithCredential(phoneAuthCredential);
      if (authCred.user != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (content) => const HomeScreen(title: 'Home')),
            (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

///step 10: creating signout function///
  Future<void> signOutMe() async {
    await firebaseAuth.signOut();
  }
}
///step 11: get "screens" folder create and open "home_screen.dart" file///
