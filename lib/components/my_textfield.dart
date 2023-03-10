import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final keyboardType;
  final validate;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
    this.keyboardType,
    this.validate,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Form(
        autovalidateMode: AutovalidateMode.always,
        child: TextFormField(
          validator: validate,
          keyboardType:
              (keyboardType == null) ? TextInputType.text : keyboardType,
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              fillColor: Colors.grey.shade200,
              filled: true,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[500])),
        ),
      ),
    );
  }
}
