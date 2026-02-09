import 'package:flutter/material.dart';
import 'package:sappiire/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final Icon? prefixIcon; // Optional icon for the text field

  const CustomTextField({
    super.key,
    required this.hintText,
    this.obscureText = false,
    this.controller,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.1), // Semi-transparent white
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.buttonOutlineBlue, width: 2), // Blue border
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: AppColors.white), // Text color
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.white.withOpacity(0.6)), // Hint text color
          prefixIcon: prefixIcon,
          border: InputBorder.none, // Remove default border
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}