import 'package:flutter/material.dart';
import 'package:flutter_firebase_otp/services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  final String title;
  const HomeScreen({Key? key,required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: [
          TextButton.icon(
/// step 12: using the function to logout from the app///
            onPressed: ()=>AuthService().signOutMe(),
            icon: const Icon(Icons.logout,color: Colors.white,),
            label: const Text('Log Out',style: TextStyle(color: Colors.white),))
        ],
      ),
      body: const Center(
        child: Text('Welcome to Home Screen'),
      ),
      ),
    );
  }
}
