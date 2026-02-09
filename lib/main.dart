import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // IMPORTANT: This gives you 'kIsWeb'
import 'package:sappiire/mobile/screens/auth/login_screen.dart'; 
import 'package:sappiire/web/screen/web_login_screen.dart'; // Import your web screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SapPIIre',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1A237E),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // THE LOGIC: 
      // If running on web, show WorkerLoginScreen. Otherwise, show mobile LoginScreen.
      home: kIsWeb ? const WorkerLoginScreen() : const LoginScreen(), 
    );
  }
}