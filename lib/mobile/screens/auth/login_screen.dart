import 'package:flutter/material.dart';
import 'package:sappiire/constants/app_colors.dart';
import 'package:sappiire/mobile/widgets/custom_button.dart';
import 'package:sappiire/mobile/widgets/custom_text_field.dart';
import 'package:sappiire/mobile/screens/auth/manage_info_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ManageInfoScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0), // Reduced top padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo kept at 250 as requested
              const SizedBox(height: 10),
              Image.asset(
                'lib/logo/sappiire_logo.png',
                height: 250,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 3), // Minimal gap

              const Text(
                'Secured autofill application of\nPersonally Identifiable Information',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.white, fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              const Text(
                'The efficient way to fill forms, and data safe.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.white, fontSize: 13, fontStyle: FontStyle.italic),
              ),

              const SizedBox(height: 20), // Reduced from 60 to 20

              // Shorter Login Box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20), // Thinner padding
                decoration: BoxDecoration(
                  color: AppColors.accentBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'LOG IN',
                      style: TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),

                    // Shortened Username Field
                    SizedBox(
                      height: 45, // Forced shorter height
                      child: CustomTextField(
                        hintText: 'Username',
                        controller: _usernameController,
                        prefixIcon: const Icon(Icons.person, color: AppColors.white, size: 18),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Shortened Password Field
                    SizedBox(
                      height: 45, // Forced shorter height
                      child: CustomTextField(
                        hintText: 'Password',
                        obscureText: true,
                        controller: _passwordController,
                        prefixIcon: const Icon(Icons.lock, color: AppColors.white, size: 18),
                      ),
                    ),
                    
                    const SizedBox(height: 20),

                    // Shortened Login Button
                    SizedBox(
                      height: 40, // Slimmer button
                      width: double.infinity,
                      child: CustomButton(
                        text: 'Log in',
                        onPressed: _onLoginPressed,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Expanded(child: Divider(color: AppColors.white)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('or', style: TextStyle(color: AppColors.white, fontSize: 12)),
                        ),
                        Expanded(child: Divider(color: AppColors.white)),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Shortened Sign In Button
                    SizedBox(
                      height: 40, // Slimmer button
                      width: double.infinity,
                      child: CustomButton(
                        text: 'Sign in',
                        onPressed: () {},
                        backgroundColor: Colors.transparent,
                        outlineButton: true,
                        textColor: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}