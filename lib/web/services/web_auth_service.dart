// lib/web/services/web_auth_service.dart
// Handles authentication for CSWD Staff on the web portal.
// Queries the same user_accounts table as the mobile app,
// but restricts login to accounts with role = 'staff'.

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class WebAuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Hash password using SHA-256 — same algorithm as mobile AuthService
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // ================================================================
  // STAFF SIGN UP
  // Creates a new staff account in the shared user_accounts table
  // with role = 'staff'. No profile table needed for staff.
  // ================================================================
  Future<Map<String, dynamic>> staffSignUp({
    required String username,
    required String password,
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    try {
      // 1. Check if username already taken (by anyone — client or staff)
      final existing = await _supabase
          .from('user_accounts')
          .select('username')
          .eq('username', username)
          .maybeSingle();

      if (existing != null) {
        return {'success': false, 'message': 'Username is already taken.'};
      }

      // 2. Check if email already registered
      final existingEmail = await _supabase
          .from('user_accounts')
          .select('email')
          .eq('email', email)
          .maybeSingle();

      if (existingEmail != null) {
        return {'success': false, 'message': 'Email is already registered.'};
      }

      // 3. Hash password
      final hashedPassword = _hashPassword(password);

      // 4. Insert staff account with role = 'staff'
      final response = await _supabase
          .from('user_accounts')
          .insert({
            'username': username,
            'password': hashedPassword,
            'email': email,
            'is_active': true,
            'role': 'staff',
          })
          .select()
          .single();

      // 5. Optionally insert into user_profiles for staff name info
      await _supabase.from('user_profiles').insert({
        'user_id': response['user_id'],
        'firstname': firstName,
        'middle_name': '',
        'lastname': lastName,
        'email': email,
      });

      return {
        'success': true,
        'message': 'Staff account created successfully.',
        'user_id': response['user_id'],
        'username': response['username'],
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Sign-up error: ${e.toString()}',
      };
    }
  }

  // ================================================================
  // STAFF LOGIN
  // Only allows login if the account has role = 'staff'.
  // Clients cannot log in through the web portal.
  // ================================================================
  Future<Map<String, dynamic>> staffLogin({
    required String username,
    required String password,
  }) async {
    try {
      // 1. Hash password
      final hashedPassword = _hashPassword(password);

      // 2. Query user_accounts — must match username + password + role = 'staff'
      final response = await _supabase
          .from('user_accounts')
          .select('user_id, username, email, is_active, role')
          .eq('username', username)
          .eq('password', hashedPassword)
          .maybeSingle();

      // 3. No match found
      if (response == null) {
        return {
          'success': false,
          'message': 'Invalid username or password.',
        };
      }

      // 4. Check if the account is a staff account
      if (response['role'] != 'staff') {
        return {
          'success': false,
          'message': 'Access denied. This portal is for CSWD staff only.',
        };
      }

      // 5. Check if account is active
      if (response['is_active'] == false) {
        return {
          'success': false,
          'message': 'Your account has been deactivated. Contact your admin.',
        };
      }

      // 6. Fetch profile data for display name
      final profile = await _supabase
          .from('user_profiles')
          .select('firstname, lastname')
          .eq('user_id', response['user_id'])
          .maybeSingle();

      return {
        'success': true,
        'message': 'Login successful.',
        'user_id': response['user_id'],
        'username': response['username'],
        'email': response['email'],
        'full_name':
            '${profile?['firstname'] ?? ''} ${profile?['lastname'] ?? ''}'.trim(),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Login error: ${e.toString()}',
      };
    }
  }
}
