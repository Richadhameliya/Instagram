import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:instagram_app/constant/app_assets.dart';
import 'package:instagram_app/controller/register_controller.dart';
import 'package:instagram_app/helper/helper.dart';
import 'package:instagram_app/widget/app_button.dart';
import 'package:instagram_app/widget/app_txtfeild.dart';
import '../../constant/app_string.dart';
import '../main/bottombar/bottom_bar.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatelessWidget {
  final RegisterController registerController = Get.put(RegisterController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _registerUser(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      String email = _emailController.text.trim();
      String username = _usernameController.text.trim();
      String password = _passwordController.text.trim();

      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final User? user = userCredential.user;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('InstaUser')
              .doc(user.uid)
              .set({
            'email': email,
            'username': username,
            'pronouns': '',
            'bio': '',
            'imageUrl': '',
          });

          Helper.dialogCall.showToast(context, AppString.registrationSuccessful,
              Colors.black, Colors.white);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavBar(),
            ),
          );
        }
      } catch (e) {
        Helper.dialogCall.showToast(
            context, '${AppString.error}: $e', Colors.black, Colors.white);
      }
    }
  }

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
                  LoginTextField(
                    controller: _emailController,
                    hintText: AppString.email,
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
                  LoginTextField(
                    controller: _usernameController,
                    hintText: AppString.username,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppString.pleaseEnterAUsername;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenSize.height * 0.01),
                  LoginTextField(
                    controller: _passwordController,
                    obscureText: true,
                    hintText: AppString.password,
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
                  LoginButton(
                      appTile: AppString.signup,
                      onTap: () => _registerUser(context)),
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
