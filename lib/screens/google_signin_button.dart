import 'package:firebase_auth/firebase_auth.dart';
import 'package:firey_chat/screens/profile_screen.dart';
import 'package:flutter/material.dart';

import 'authentication.dart';
import 'dashboard_screen.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
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

                if (user != null) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const ProfileScreen()));
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
            ),
    );
  }
}
