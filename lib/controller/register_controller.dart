import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:instagram_app/helper/helper.dart';

import '../constant/app_string.dart';
import '../ui/main/bottombar/bottom_bar.dart';

class RegisterController extends GetxController {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<void> registerUser(BuildContext context) async {
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
}
