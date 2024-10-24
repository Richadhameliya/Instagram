import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:instagram_app/constant/app_assets.dart';
import 'package:instagram_app/controller/register_controller.dart';

import '../../constant/app_string.dart';
import '../main/bottombar/bottom_bar.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatelessWidget {
  final RegisterController registerController = Get.put(RegisterController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    final screenSize = MediaQuery.of(context).size;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.05,
              vertical: screenSize.height * 0.02,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: screenSize.height * 0.1,
                  ),
                  Center(
                    child: assetImage(AppAssets.instaLogo,
                        height: screenHeight * 0.1),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  Text(
                    AppString.createAnAccount,
                    style: TextStyle(
                      fontSize: screenSize.width * 0.07,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: AppString.email,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(screenSize.width * 0.03),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppString.pleaseEnterAnEmail;
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return AppString.pleaseEnterValidEmail;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenSize.height * 0.01),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: AppString.username,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(screenSize.width * 0.03),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppString.pleaseEnterAUsername;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenSize.height * 0.01),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: AppString.password,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(screenSize.width * 0.03),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppString.pleaseEnterAPassword;
                      }
                      if (value.length < 6) {
                        return AppString.passwordMustBe;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  MaterialButton(
                    child: Text(
                      AppString.signup,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: screenSize.width * 0.05),
                    ),
                    height: screenSize.height * 0.07,
                    minWidth: screenSize.width * 0.9,
                    color: Colors.lightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(screenSize.width * 0.07),
                    ),
                    onPressed: () => registerController.registerUser(context),
                  ),
                  SizedBox(height: screenSize.height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(AppString.alreadyHaveAnAccount),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LogInScreen(),
                              ));
                        },
                        child: const Text(AppString.login),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
