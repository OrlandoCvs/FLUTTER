import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserModel? _user;
  UserModel? get user => _user;

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await _authService.signIn(
        email: email,
        password: password,
      );

      if (result != null) {
        _user = result;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("ERROR SIGNIN: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await _authService.signUp(
        username: username,
        email: email,
        password: password,
      );

      if (result != null) {
        _user = result;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("ERROR SIGNUP: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }
}