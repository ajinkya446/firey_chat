import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firey_chat/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import 'dashboard_screen.dart';

class OTPVerficationScreen extends StatefulWidget {
  final String mobileNumber, verificationCode;

  const OTPVerficationScreen({super.key, required this.mobileNumber, required this.verificationCode});

  @override
  State<OTPVerficationScreen> createState() => _OTPVerficationScreenState();
}

class _OTPVerficationScreenState extends State<OTPVerficationScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12.0),
                child: Text("Verification Code", style: TextStyle(fontSize: 22)),
              ),
              const SizedBox(height: 30),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12.0), child: Text("We texted you a code \n Please enter it below", style: TextStyle(fontSize: 18))),
              const SizedBox(height: 30),
              OtpTextField(
                numberOfFields: 6,
                borderColor: const Color(0xFF512DA8),
                //set to true to show as box or false to show as dash
                showFieldAsBox: true,
                //runs when a code is typed in
                onCodeChanged: (String code) {
                  //handle validation or checks here
                },
                onSubmit: (String verificationCode) async {
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.verificationCode, smsCode: verificationCode);

                  final details = await FirebaseFirestore.instance.collection('users').snapshots();
                  details.forEach((element) async {
                    for (var elementNew in element.docs) {
                      final data = elementNew.data();
                      if (data['phone'] == widget.mobileNumber) {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(elementNew.id)
                            .update({'email': data['email'], 'name': data['name'], "phone": data['phone'], "photo_url": data['photo_url'], "verified": "true"});
                      }
                    }
                  });
                  // Sign the user in (or link) with the credential
                  await auth.signInWithCredential(credential).then((value) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => const MyHomePage()));
                  });
                }, // end onSubmit
              ),
            ],
          ),
        ),
      ),
    );
  }
}
