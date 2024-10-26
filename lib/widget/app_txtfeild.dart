import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final String hintText;
  final String titleText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final FormFieldValidator? validator;
  final bool obscureText;

  LoginTextField(
      {super.key,
      this.keyboardType,
      this.hintText = "",
      this.titleText = "",
      this.controller,
      this.validator,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: validator,
    );
  }
}

class EditTextField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final FormFieldValidator? validator;
  final bool obscureText;
  final suffixIcon;

  EditTextField(
      {super.key,
      this.keyboardType,
      this.hintText = "",
      this.labelText = "",
      this.controller,
      this.validator,
      this.obscureText = false,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: suffixIcon,
        labelStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 15,
        ),
      ),
    );
  }
}
