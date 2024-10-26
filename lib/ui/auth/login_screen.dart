import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:instagram_app/constant/app_assets.dart';
import 'package:instagram_app/constant/app_string.dart';
import 'package:instagram_app/helper/helper.dart';
import 'package:instagram_app/widget/app_button.dart';
import 'package:instagram_app/widget/app_txtfeild.dart';
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
          Helper.dialogCall.showToast(
              context, AppString.loginSuccessful, Colors.black, Colors.white);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavBar(),
            ),
            (route) => false,
          );
        } else {
          Helper.dialogCall.showToast(
              context, AppString.userNotFound, Colors.black, Colors.white);
        }
      } catch (e) {
        Helper.dialogCall.showToast(context,
            "${AppString.error}: ${e.toString()}", Colors.black, Colors.white);
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
                      LoginTextField(
                        controller: _emailController,
                        hintText: AppString.email,
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
                      LoginTextField(
                        controller: _passwordController,
                        obscureText: true,
                        hintText: AppString.password,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppString.pleaseEnterAPassword;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      LoginButton(appTile: AppString.login, onTap: _login),
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
