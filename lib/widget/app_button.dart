import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final String appTile;
  final VoidCallback onTap;

  const LoginButton({super.key, required this.appTile, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    return MaterialButton(
      height: screenHeight * 0.06,
      minWidth: double.infinity, // Full width button
      color: Colors.lightBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide.none,
      ),
      child: Text(
        appTile,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      // onPressed: () {
      //   if (_formKey.currentState?.validate() ?? false) {
      //     String email = _emailController.text.trim();
      //     String password = _passwordController.text.trim();
      //     loginController.login(
      //         context as BuildContext,
      //         password,
      //         email as String); // Call the login method
      //   }
      // },
      onPressed: onTap,
    );
  }
}
