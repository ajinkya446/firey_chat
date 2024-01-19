import 'package:firey_chat/screens/authentication.dart';
import 'package:firey_chat/screens/login_screen.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'dashboard_screen.dart';
import 'email_validator.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isSigningIn = false;
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
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: const Color(0xfffffff),
            elevation: 0,
            title: const Text("Profile Screen", style: TextStyle(color: Colors.black, fontSize: 20, fontStyle: FontStyle.italic))),
        body: Column(
          children: [
            const SizedBox(height: 30),
            Center(
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
                          child: TextFormField(controller: phoneController, decoration: const InputDecoration(labelText: 'Enter Mobile Number', border: InputBorder.none))),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.blue),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: InkWell(
                            onTap: () async {
                              checkValidation();
                            },
                            child: const Text(
                              "Update",
                              style: TextStyle(color: Colors.white, fontSize: 20, fontStyle: FontStyle.italic),
                            )),
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
                            child: const Text(
                              "Sign Out",
                              style: TextStyle(color: Colors.white, fontSize: 20, fontStyle: FontStyle.italic),
                            )),
                      )
                    ]),
            ),
          ],
        ),
      ),
    );
  }

  Future checkValidation() async {
    String regexPattern = r'^[6-9]\d{9}$';
    final regExp = RegExp(regexPattern);
    RegExp exp = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!exp.hasMatch(emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(Authentication.customSnackBar(content: 'Please Enter Email Address'));
    } else if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(Authentication.customSnackBar(content: 'Please Enter Valid Name'));
    } else if (!regExp.hasMatch(phoneController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(Authentication.customSnackBar(content: 'Please Enter Valid Mobile number'));
    }
  }
}
