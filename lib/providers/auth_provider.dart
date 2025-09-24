import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;

  User? get user => _user;

  AuthProvider() {
    // Escucha los cambios en la sesión de Firebase
    _authService.userChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  // Registrar usuario
  Future<void> register(String email, String password, String username) async {
    await _authService.register(email, password, username);
  }

  //Iniciar sesión
  Future<void> login(String email, String password) async {
    await _authService.login(email, password);
    // _user se actualiza automáticamente por el listener
  }

  //Cerrar sesión
  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }
}

