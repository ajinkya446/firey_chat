import 'package:firey_chat/screens/authentication.dart';
import 'package:firey_chat/screens/login_screen.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'dashboard_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isSigningIn
            ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.red))
            : Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                Container(
                  child: ClipOval(
                      child: Image.network(
                    userDetails.value?.photoURL ?? "",
                    errorBuilder: (ctx, object, stackTrace) {
                      return Image.asset("asset/bonfire.png");
                    },
                  )),
                ),
                const SizedBox(height: 20),
                Text(userDetails.value?.email ?? "NULL"),
                const SizedBox(height: 20),
                Text(userDetails.value?.displayName ?? "NULL"),
                const SizedBox(height: 20),
                Text(userDetails.value?.phoneNumber ?? "No Number"),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.blue),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                      child: const Text(
                        "Sign Out",
                        style: TextStyle(color: Colors.white, fontSize: 20, fontStyle: FontStyle.italic),
                      )),
                )
              ]),
      ),
    );
  }
}
