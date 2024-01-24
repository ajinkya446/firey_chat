import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'authentication.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isSigningIn = false;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _isSigningIn = true;
    });
    Authentication().initializeFirebase(context: context).then((value) {
      setState(() {
        _isSigningIn = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("asset/background.png", height: MediaQuery.of(context).size.height * 0.5, width: MediaQuery.of(context).size.width * 0.7),
            const SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _isSigningIn
                    ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.red))
                    : OutlinedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            _isSigningIn = true;
                          });
                          User? user = await Authentication.signInWithGoogle(context: context);
                          if (user != null && (user.email?.isNotEmpty ?? false)) {
                            await Authentication().getUserDetails(context);
                          }
                          setState(() {
                            _isSigningIn = false;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Image(image: AssetImage("asset/google_logo.png"), height: 35.0),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  'Sign in with Google',
                                  style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                        ),
                      ))
          ],
        ),
      ),
    ));
  }
}
