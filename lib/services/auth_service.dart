import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier {
  static const String _usernameKey = 'user_name';
  static const String _isLoggedInKey = 'is_logged_in';

  String _username = '';
  bool _isLoggedIn = false;
  bool _isLoading = true;

  String get username => _username;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  // Initialize and check if user is already logged in
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      _isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
      _username = prefs.getString(_usernameKey) ?? '';
    } catch (e) {
      debugPrint('Error initializing AuthService: $e');
      _isLoggedIn = false;
      _username = '';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Login with username
  Future<void> login(String username) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_usernameKey, username);
      await prefs.setBool(_isLoggedInKey, true);

      _username = username;
      _isLoggedIn = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error logging in: $e');
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_usernameKey);
      await prefs.setBool(_isLoggedInKey, false);

      _username = '';
      _isLoggedIn = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error logging out: $e');
    }
  }

  // Update username
  Future<void> updateUsername(String newUsername) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_usernameKey, newUsername);

      _username = newUsername;
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating username: $e');
    }
  }

  // Get first name from full name
  String get firstName {
    if (_username.isEmpty) return 'User';
    final parts = _username.trim().split(' ');
    return parts.first;
  }
}
