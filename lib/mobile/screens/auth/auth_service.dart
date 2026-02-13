import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Hash password using SHA-256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // ================================================================
  // SIGN UP - Create user account + profile
  // ================================================================
  Future<Map<String, dynamic>> signUp({
    required String username,
    required String password,
    required String email,
    required String firstName,
    required String middleName,
    required String lastName,
    required String dateOfBirth,
    required String phoneNumber,
  }) async {
    try {
      // 1. Check if username already exists
      final existingUser = await _supabase
          .from('user_accounts')
          .select('username')
          .eq('username', username)
          .maybeSingle();

      if (existingUser != null) {
        return {'success': false, 'message': 'Username already exists'};
      }

      // 2. Hash the password
      final hashedPassword = _hashPassword(password);

      // 3. Insert into user_accounts table
      final accountResponse = await _supabase
          .from('user_accounts')
          .insert({
            'username': username,
            'password': hashedPassword,
            'email': email,
            'is_active': true,
          })
          .select()
          .single();

      final String userId = accountResponse['user_id'];

      // 4. Parse date of birth (MM/DD/YYYY to YYYY-MM-DD)
      final dateParts = dateOfBirth.split('/');
      final formattedDate =
          '${dateParts[2]}-${dateParts[0].padLeft(2, '0')}-${dateParts[1].padLeft(2, '0')}';

      // 5. Insert into user_profiles table
      await _supabase.from('user_profiles').insert({
        'user_id': userId,
        'firstname': firstName,
        'middle_name': middleName,
        'lastname': lastName,
        'birthdate': formattedDate,
        'email': email,
        'cellphone_number': phoneNumber,
      });

      return {
        'success': true,
        'message': 'Account created successfully',
        'user_id': userId,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error creating account: ${e.toString()}',
      };
    }
  }

  // ================================================================
  // LOGIN - Verify credentials
  // ================================================================
  Future<Map<String, dynamic>> login({
  required String username,
  required String password,
}) async {
  try {
    // 1. Hash the password
    final hashedPassword = _hashPassword(password);

    // 2. Query user_accounts with username and password
    final response = await _supabase
        .from('user_accounts')
        .select('user_id, username, email, is_active')
        .eq('username', username)
        .eq('password', hashedPassword)
        .maybeSingle();

    if (response == null) {
      return {
        'success': false,
        'message': 'Invalid username or password'
      };
    }

    if (response['is_active'] == false) {
      return {
        'success': false,
        'message': 'Account is deactivated'
      };
    }

    // 🔹 REMOVED: Update last_login (column doesn't exist)
    // await _supabase
    //     .from('user_accounts')
    //     .update({'last_login': DateTime.now().toIso8601String()})
    //     .eq('user_id', response['user_id']);

    // 4. Get user profile data
    final profileResponse = await _supabase
        .from('user_profiles')
        .select()
        .eq('user_id', response['user_id'])
        .maybeSingle();

    return {
      'success': true,
      'message': 'Login successful',
      'user_id': response['user_id'],
      'username': response['username'],
      'email': response['email'],
      'profile': profileResponse,
    };

  } catch (e) {
    return {
      'success': false,
      'message': 'Error during login: ${e.toString()}'
    };
  }
}

  // ================================================================
  // GET USER PROFILE - Retrieve profile data
  // ================================================================
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from('user_profiles')
          .select()
          .eq('user_id', userId)
          .single();

      return response;
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }
}
