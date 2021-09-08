import 'package:aplikasi_asabri_nullsafety/common/theme.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String title;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboard;
  final TextEditingController controller;

  const CustomTextFormField({
    Key? key,
    required this.title,
    required this.hintText,
    this.obscureText = false,
    this.keyboard = TextInputType.text,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTextStyle,
          ),
          SizedBox(
            height: 6,
          ),
          TextFormField(
            cursorColor: textColor,
            obscureText: obscureText,
            controller: controller,
            keyboardType: keyboard,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: textTextStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  24,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  24,
                ),
                borderSide: BorderSide(
                  color: textColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
