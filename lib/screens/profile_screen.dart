import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firey_chat/screens/authentication.dart';
import 'package:firey_chat/screens/login_screen.dart';
import 'package:firey_chat/screens/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isSigningIn = false, isDataExists = false;
  TextEditingController nameController = TextEditingController(), emailController = TextEditingController(), phoneController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    nameController.text = userDetails.value?.displayName ?? "";
    emailController.text = userDetails.value?.email ?? "";
    phoneController.text = userDetails.value?.phoneNumber ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // appBar: AppBar(
        //     centerTitle: true,
        //     backgroundColor: const Color(0xfffffff),
        //     elevation: 0,
        //     title: const Text("Profile Screen", style: TextStyle(color: Colors.black, fontSize: 20, fontStyle: FontStyle.italic))),
        body: /*Stack(
          children: [
            Image.asset(
              "asset/background_app.png",
              height: double.maxFinite,
              width: double.maxFinite,
              fit: BoxFit.fill,
            ),*/
            Center(
          child: _isSigningIn
              ? SizedBox(height: 50, child: LoadingAnimationWidget.flickr(leftDotColor: Colors.red, rightDotColor: Colors.deepPurple, size: 50))
              : Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Container(
                    height: 200,
                    child: ClipOval(
                        child: Image.network(
                      userDetails.value?.photoURL ?? "",
                      errorBuilder: (ctx, object, stackTrace) {
                        return Image.asset("asset/bonfire.png");
                      },
                    )),
                  ),
                  const SizedBox(height: 20),
                  Container(
                      width: 300,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                      child: TextFormField(controller: emailController, decoration: const InputDecoration(labelText: 'Enter Email', border: InputBorder.none))),
                  const SizedBox(height: 20),
                  Container(
                      width: 300,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                      child: TextFormField(controller: nameController, decoration: const InputDecoration(labelText: 'Enter Name', border: InputBorder.none))),
                  const SizedBox(height: 20),
                  Container(
                      width: 300,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                      child: TextFormField(
                          controller: phoneController,
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(counterText: "", labelText: 'Enter Mobile Number', border: InputBorder.none))),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.blue),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: InkWell(
                        onTap: () async {
                          checkValidation();
                        },
                        child: const Text("Submit", style: TextStyle(color: Colors.white, fontSize: 20))),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.blue),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: InkWell(
                        onTap: () async {
                          setState(() {
                            _isSigningIn = true;
                          });
                          await Authentication.signOut(context: context);
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));

                          setState(() {
                            _isSigningIn = false;
                          });
                        },
                        child: const Text("Sign Out", style: TextStyle(color: Colors.white, fontSize: 20))),
                  ),
                ]),
        ),
        /* ],
        ),*/
      ),
    );
  }

  Future checkValidation() async {
    _isSigningIn = true;
    isDataExists = false;
    setState(() {});
    final details = await FirebaseFirestore.instance.collection('users').snapshots();
    details.forEach((element) {
      for (var elementNew in element.docs) {
        final data = elementNew.data();
        if (data['phone'] == phoneController.text) {
          isDataExists = true;
        }
      }
    });
    String regexPattern = r'^[6-9]\d{9}$';
    final regExp = RegExp(regexPattern);
    RegExp exp = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!exp.hasMatch(emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(Authentication.customSnackBar(content: 'Please Enter Email Address'));
    } else if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(Authentication.customSnackBar(content: 'Please Enter Valid Name'));
    } else if (!regExp.hasMatch(phoneController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(Authentication.customSnackBar(content: 'Please Enter Valid Mobile number'));
    } else {
      Future.delayed(Duration(seconds: 3), () {
        if (!isDataExists) {
          FirebaseFirestore.instance
              .collection('users')
              .add({'email': emailController.text, 'name': nameController.text, "phone": phoneController.text, "photo_url": userDetails.value?.photoURL ?? "", "verified": "false"});
        }
        FirebaseAuth auth = FirebaseAuth.instance;
        auth.verifyPhoneNumber(
            phoneNumber: '+91${phoneController.text}',
            verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => HomeScreen()));
            },
            verificationFailed: (FirebaseAuthException error) {
              AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      headerAnimationLoop: false,
                      title: 'OTP Error',
                      desc: error.message,
                      titleTextStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      descTextStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      btnOkOnPress: () {
                        setState(() {});
                        // return;
                      },
                      isDense: true,
                      btnOkIcon: Icons.cancel,
                      btnOkColor: Colors.red)
                  .show();
              // return;
            },
            codeSent: (String vd, int? forceResendingToken) {
              Navigator.push(context, MaterialPageRoute(builder: (ctx) => OTPVerficationScreen(mobileNumber: phoneController.text, verificationCode: vd)));
              // return;
            },
            codeAutoRetrievalTimeout: (String verificationId) {});
        _isSigningIn = false;
        setState(() {});
        return;
      });
    }
    _isSigningIn = false;
    setState(() {});
    return;
  }
}
