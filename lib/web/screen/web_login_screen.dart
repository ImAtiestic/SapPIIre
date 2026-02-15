// lib/web/screen/web_login_screen.dart
// Web portal entry point for CSWD Staff.
// Supports both Login and Sign Up in a single screen (toggled).
// Uses the shared user_accounts table — staff are identified by role = 'staff'.

import 'package:flutter/material.dart';
import 'package:sappiire/constants/app_colors.dart';
import 'package:sappiire/mobile/widgets/custom_text_field.dart';
import 'package:sappiire/web/screen/manage_forms_screen.dart';
import 'package:sappiire/web/services/web_auth_service.dart';

class WorkerLoginScreen extends StatefulWidget {
  const WorkerLoginScreen({super.key});

  @override
  State<WorkerLoginScreen> createState() => _WorkerLoginScreenState();
}

class _WorkerLoginScreenState extends State<WorkerLoginScreen> {
  final WebAuthService _authService = WebAuthService();
  bool _isSignUpMode = false; // Toggle between Login and Sign Up
  bool _isLoading = false;

  // --- Shared controllers ---
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // --- Sign-up only controllers ---
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------------
  // LOGIN HANDLER
  // ----------------------------------------------------------------
  Future<void> _handleLogin() async {
    if (_usernameController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      _showSnackbar('Please enter your username and password.', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    final result = await _authService.staffLogin(
      username: _usernameController.text.trim(),
      password: _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success']) {
      _showSnackbar('Welcome, ${result['full_name'].isNotEmpty ? result['full_name'] : result['username']}!');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ManageFormsScreen()),
      );
    } else {
      _showSnackbar(result['message'], isError: true);
    }
  }

  // ----------------------------------------------------------------
  // SIGN UP HANDLER
  // ----------------------------------------------------------------
  Future<void> _handleSignUp() async {
    // Basic validation
    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _usernameController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      _showSnackbar('Please fill in all fields.', isError: true);
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnackbar('Passwords do not match.', isError: true);
      return;
    }

    if (_passwordController.text.length < 8) {
      _showSnackbar('Password must be at least 8 characters.', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    final result = await _authService.staffSignUp(
      username: _usernameController.text.trim(),
      password: _passwordController.text,
      email: _emailController.text.trim(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success']) {
      _showSnackbar('Account created! You can now log in.');
      setState(() {
        _isSignUpMode = false;
        _clearSignUpFields();
      });
    } else {
      _showSnackbar(result['message'], isError: true);
    }
  }

  void _clearSignUpFields() {
    _emailController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    _confirmPasswordController.clear();
    _passwordController.clear();
    _usernameController.clear();
  }

  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ----------------------------------------------------------------
  // BUILD
  // ----------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'lib/Logo/sappiire_logo.png',
                height: 180,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 8),
              Text(
                _isSignUpMode ? 'STAFF REGISTRATION' : 'WORKER PORTAL',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  letterSpacing: 4,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 32),

              // Auth Card
              Container(
                width: 480,
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
                    Text(
                      _isSignUpMode ? 'Create Staff Account' : 'Staff Login',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isSignUpMode
                          ? 'Register your CSWD staff credentials'
                          : 'Enter your credentials to access the CSWD dashboard',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ---- SIGN UP EXTRA FIELDS ----
                    if (_isSignUpMode) ...[
                      CustomTextField(
                        hintText: 'First Name',
                        controller: _firstNameController,
                        prefixIcon: const Icon(Icons.person_outline,
                            color: AppColors.white),
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        hintText: 'Last Name',
                        controller: _lastNameController,
                        prefixIcon: const Icon(Icons.person_outline,
                            color: AppColors.white),
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        hintText: 'Email Address',
                        controller: _emailController,
                        prefixIcon: const Icon(Icons.email_outlined,
                            color: AppColors.white),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // ---- SHARED FIELDS (Username + Password) ----
                    CustomTextField(
                      hintText: 'Username',
                      controller: _usernameController,
                      prefixIcon:
                          const Icon(Icons.badge, color: AppColors.white),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hintText: 'Password',
                      obscureText: true,
                      controller: _passwordController,
                      prefixIcon:
                          const Icon(Icons.vpn_key, color: AppColors.white),
                    ),

                    // ---- CONFIRM PASSWORD (sign up only) ----
                    if (_isSignUpMode) ...[
                      const SizedBox(height: 16),
                      CustomTextField(
                        hintText: 'Confirm Password',
                        obscureText: true,
                        controller: _confirmPasswordController,
                        prefixIcon: const Icon(Icons.vpn_key,
                            color: AppColors.white),
                      ),
                    ],

                    const SizedBox(height: 32),

                    // ---- ACTION BUTTON ----
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
                        onPressed: _isLoading
                            ? null
                            : (_isSignUpMode ? _handleSignUp : _handleLogin),
                        child: _isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: AppColors.primaryBlue,
                                ),
                              )
                            : Text(
                                _isSignUpMode
                                    ? 'CREATE ACCOUNT'
                                    : 'LOG IN TO SYSTEM',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ---- TOGGLE BETWEEN LOGIN / SIGN UP ----
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isSignUpMode = !_isSignUpMode;
                          _clearSignUpFields();
                        });
                      },
                      child: Text(
                        _isSignUpMode
                            ? 'Already have an account? Log In'
                            : 'New staff member? Register here',
                        style: const TextStyle(color: AppColors.white),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
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