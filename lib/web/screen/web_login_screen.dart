import 'package:flutter/material.dart';
import 'package:sappiire/constants/app_colors.dart'; 
import 'package:sappiire/mobile/widgets/custom_text_field.dart';
import 'package:sappiire/web/screen/manage_forms_screen.dart'; // Import for navigation

class WorkerLoginScreen extends StatefulWidget {
  const WorkerLoginScreen({super.key});

  @override
  State<WorkerLoginScreen> createState() => _WorkerLoginScreenState();
}

class _WorkerLoginScreenState extends State<WorkerLoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleLogin() {
    // Navigate to the Manage Forms Screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ManageFormsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue, 
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo as UI Title
              Image.asset(
                'lib/Logo/sappiire_logo.png',
                height: 200, 
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 10),
              const Text(
                'WORKER PORTAL',
                style: TextStyle(
                  color: AppColors.white, // Using AppColors
                  fontSize: 18,
                  letterSpacing: 4,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 40),

              // Login Card
              Container(
                width: 450, 
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: AppColors.accentBlue, 
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Staff Login',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Enter your credentials to access the CSWD dashboard',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.white, fontSize: 14), // Using AppColors.white (opacity can be applied if needed)
                    ),
                    const SizedBox(height: 35),

                    // Username
                    CustomTextField(
                      hintText: 'Username',
                      controller: _usernameController,
                      prefixIcon: const Icon(Icons.badge, color: AppColors.white),
                    ),
                    const SizedBox(height: 20),

                    // Password
                    CustomTextField(
                      hintText: 'Password',
                      obscureText: true,
                      controller: _passwordController,
                      prefixIcon: const Icon(Icons.vpn_key, color: AppColors.white),
                    ),
                    
                    const SizedBox(height: 40),

                    // Login Button using AppColors
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.white,
                          foregroundColor: AppColors.primaryBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: _handleLogin, // Triggers navigation
                        child: const Text(
                          'LOG IN TO SYSTEM',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: AppColors.white),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 50),
              const Text(
                '© 2026 City Social Welfare and Development Office',
                style: TextStyle(color: AppColors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}