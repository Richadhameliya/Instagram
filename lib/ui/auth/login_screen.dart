import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:instagram_app/constant/app_assets.dart';
import 'package:instagram_app/constant/app_string.dart';

import '../../controller/login_controller.dart';
import '../main/bottombar/bottom_bar.dart';
import 'register_screen.dart';

class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  GetStorage box = GetStorage();
  final LoginController loginController = Get.put(LoginController());

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      print("email: $email");
      print("pass: $password");

      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        final userId = userCredential.user!.uid;
        await box.write("uid", userId);

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('InstaUser')
            .doc(userCredential.user?.uid)
            .get();

        if (userDoc.exists) {
          Fluttertoast.showToast(
            msg: AppString.loginSuccessful,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white,
          );

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavBar(),
            ),
            (route) => false,
          );
        } else {
          Fluttertoast.showToast(
            msg: AppString.userNotFound,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white,
          );
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: "${AppString.error}: ${e.toString()}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: screenHeight * 0.08,
                ),
                Text(
                  '${AppString.english}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                Center(
                  child: assetImage(AppAssets.instaLogo,
                      height: screenHeight * 0.1),
                ),
                SizedBox(height: screenHeight * 0.05),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: AppString.email,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppString.pleaseEnterAnEmail;
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: AppString.password,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppString.pleaseEnterAPassword;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      MaterialButton(
                        height: screenHeight * 0.06,
                        minWidth: double.infinity, // Full width button
                        color: Colors.lightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide.none,
                        ),
                        child: Text(
                          AppString.login,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                screenWidth * 0.05, // Responsive font size
                          ),
                        ),
                        onPressed: _login,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            // Handle forgotten password
                          },
                          child: Text(
                            AppString.forgottenPassword,
                            style: TextStyle(
                              color: Colors.lightBlue,
                              fontSize:
                                  screenWidth * 0.04, // Responsive font size
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.18),
                      MaterialButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegistrationScreen(),
                              ));
                        },
                        height: screenHeight * 0.07,
                        minWidth: double.infinity,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(color: Colors.lightBlue, width: 2),
                        ),
                        child: Text(
                          AppString.createNewAccount,
                          style: TextStyle(
                            color: Colors.lightBlue,
                            fontSize: screenWidth * 0.05,
                          ),
                        ),
                      ),
                      Center(
                        child: assetImage(AppAssets.meta,
                            height: screenHeight * 0.07),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
