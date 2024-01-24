import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firey_chat/screens/profile_screen.dart';
import 'package:firey_chat/screens/singleton.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard_screen.dart';

ValueNotifier<User?> userDetails = ValueNotifier(null);

class Authentication {
  Future<FirebaseApp> initializeFirebase({required BuildContext context}) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      dynamic userValue = prefs.getString('user');
      dynamic token = prefs.getString('token');
      dynamic idToken = prefs.getString('idToken');
      UserCredential? userCredential;
      User? user;
      if (userValue != null) {
        final AuthCredential credential = GoogleAuthProvider.credential(accessToken: token, idToken: idToken);
        userCredential = await auth.signInWithCredential(credential);
        user = userCredential.user;
      }
      if (user != null && (user.email?.isNotEmpty ?? false)) {
        userDetails.value = userCredential?.user;
        getUserDetails(context);
      }
    } catch (e) {
      return firebaseApp;
    }
    return firebaseApp;
  }

  Future getUserDetails(BuildContext context) async {
    try {
      if (!MySingleton().isDataFound && !MySingleton().isForLoopCalled) {
        final details = await FirebaseFirestore.instance.collection('users').snapshots();
        details.forEach((element) {
          for (var elementNew in element.docs) {
            final data = elementNew.data();
            if (data['email'].toString().toLowerCase() == userDetails.value?.email?.toLowerCase()) {
              if (data['verified'] == "true") {
                MySingleton().setBoolVal(true);
                // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MyApp()));
                break;
              }
            }
          }
        });
        MySingleton().setBooleanVal(true);
      }
      Future.delayed(const Duration(seconds: 3), () {
        if (MySingleton().isDataFound && !MySingleton().isCalled) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MyHomePage()));
          MySingleton().setBoolVal(true);
          MySingleton().setVal(true);
          // return;
        } else {
          if (!MySingleton().isCalled) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const ProfileScreen()));
            // return;
          }
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      await prefs.setString('token', googleSignInAuthentication.accessToken.toString());
      await prefs.setString('idToken', googleSignInAuthentication.idToken.toString());
      final AuthCredential credential = GoogleAuthProvider.credential(accessToken: googleSignInAuthentication.accessToken, idToken: googleSignInAuthentication.idToken);

      try {
        final UserCredential userCredential = await auth.signInWithCredential(credential);
        await prefs.setString('user', jsonEncode(credential.toString()));
        user = userCredential.user;
        userDetails.value = user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(content: 'The account already exists with a different credential'),
          );
        } else if (e.code == 'invalid-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(content: 'Error occurred while accessing credentials. Try again.'),
          );
        }
      } catch (e) {
        // handle the error here
      }
    }

    return user;
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(content, style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5)),
    );
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
        // await googleSignIn.disconnect();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }
}
