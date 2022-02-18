import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

///step 1: creating enum to store multi widget info ///
enum Login{
  showMobileNumberWidget,
  showOtpWidget
  }


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
///step 2: setting the default current status of emun///
Login currentState = Login.showMobileNumberWidget;
///step 3: creating firebase auth instance///
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  String verificationID = "";

///setp 4: creating a widget to input the phone number///
  mobileNumberInputWidget(context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Verify your phone number',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Your Phone Number',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  await firebaseAuth.verifyPhoneNumber(
                      phoneNumber: "+88${phoneController.text}",
                      verificationCompleted: (phoneAuthCredential) async {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('OTP has been sent')));
                      },
                      verificationFailed: (verificationFailed) async {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('verificationFailed')));
                      },
                      codeSent: (verificationID, resendingToken) async{
                        setState(() {
                          currentState = Login.showOtpWidget;
                          this.verificationID = verificationID;
                        });
                      },
                      codeAutoRetrievalTimeout: (verificationId) async {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('codeAutoRetrievalTimeout')));
                      });
                },
                child: const Text('Send OTP')),
          ],
        ),
      ),
    );
  }

///setp 5: creating a widget to input the otp number///
  otpInputWidget(context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('ENTER YOUR OTP',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Your OTP',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  AuthCredential phoneAuthCredential =
                      PhoneAuthProvider.credential(
                          verificationId: verificationID,
                          smsCode: otpController.text);
                  AuthService().singInWithPhoneAuthCredential(
                      phoneAuthCredential, context);
                },
                child: const Text('Verify')),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
///setp 6: setting a condition to navigate between both widgets///
        body: currentState == Login.showMobileNumberWidget ? Center(child: mobileNumberInputWidget(context)) : Center(child: otpInputWidget(context)),
      )
    );
  }
}
///setp 7: get the services folder and open "auth_service.dart" file///
