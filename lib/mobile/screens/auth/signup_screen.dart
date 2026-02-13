import 'package:flutter/material.dart';
import 'package:sappiire/constants/app_colors.dart';
import 'package:sappiire/mobile/widgets/custom_button.dart';
import 'package:sappiire/mobile/widgets/custom_text_field.dart';
import 'package:sappiire/mobile/screens/auth/manage_info_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Personal information
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _suffixController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Account credentials
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _suffixController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onCreateAccount() {
    if (_formKey.currentState?.validate() ?? false) {
      // At this point we'd normally send the data to the backend / database.
      // For now just proceed to the "success" screen.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignUpSuccessScreen()),
      );
    }
  }

  String? _nonEmptyValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+");
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _passwordMatchValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Sign Up'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Basic Information',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: 'First Name',
                  controller: _firstNameController,
                  validator: _nonEmptyValidator,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: 'Middle Name',
                  controller: _middleNameController,
                  validator: _nonEmptyValidator,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: 'Last Name',
                  controller: _lastNameController,
                  validator: _nonEmptyValidator,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: 'Suffix',
                  controller: _suffixController,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: 'Date of Birth (MM/DD/YYYY)',
                  controller: _dobController,
                  validator: _nonEmptyValidator,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: 'Email',
                  controller: _emailController,
                  validator: _emailValidator,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: 'Phone Number',
                  controller: _phoneController,
                  validator: _nonEmptyValidator,
                ),
                const SizedBox(height: 20),

                const Text(
                  'Account Credentials',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: 'Username',
                  controller: _usernameController,
                  prefixIcon: const Icon(
                    Icons.person,
                    color: AppColors.white,
                    size: 18,
                  ),
                  validator: _nonEmptyValidator,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: 'Password',
                  controller: _passwordController,
                  obscureText: true,
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: AppColors.white,
                    size: 18,
                  ),
                  validator: _nonEmptyValidator,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: 'Confirm Password',
                  controller: _confirmPasswordController,
                  obscureText: true,
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: AppColors.white,
                    size: 18,
                  ),
                  validator: _passwordMatchValidator,
                ),
                const SizedBox(height: 30),

                CustomButton(
                  text: 'Create Account',
                  onPressed: _onCreateAccount,
                  backgroundColor: AppColors.white,
                  textColor: AppColors.primaryBlue,
                ),

                const SizedBox(height: 20),
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.white)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'or',
                        style: TextStyle(color: AppColors.white),
                      ),
                    ),
                    const Expanded(child: Divider(color: AppColors.white)),
                  ],
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: 'Back to login',
                  onPressed: () => Navigator.pop(context),
                  outlineButton: true,
                  backgroundColor: Colors.transparent,
                  textColor: AppColors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Simple placeholder shown after "sign up" completes.
class SignUpSuccessScreen extends StatelessWidget {
  const SignUpSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'All signed in!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Welcome to the Autofill App',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.white, fontSize: 16),
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: 'Proceed',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const ManageInfoScreen()),
                  );
                },
                backgroundColor: AppColors.white,
                textColor: AppColors.primaryBlue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
