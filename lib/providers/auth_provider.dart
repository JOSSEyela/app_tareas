import 'package:app_tareas_prueba/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;

  User? get user => _user;

  AuthProvider() {
    // Escucha los cambios en la sesión de Firebase
    _authService.userChanges.listen((user) async {
      _user = user;
      // 🔹 Si hay usuario logueado, cargamos sus datos de Firestore
      if (_user != null) {
        await loadUserData();
      } else {
        _userData = null;
      }
      notifyListeners();
    });
  }

  // Registrar usuario
  Future<void> register(String email, String password, String username) async {
    await _authService.register(email, password, username);
    // después de registrar se carga userData automáticamente por el listener
  }

  // 🔹 UserModel
  UserModel? _userData;
  UserModel? get userData => _userData;

  Future<void> loadUserData() async {
    _userData = await _authService.getCurrentUserData();
    notifyListeners();
  }

  //Iniciar sesión
  Future<void> login(String email, String password) async {
    await _authService.login(email, password);
    // _user se actualiza automáticamente por el listener y carga datos
  }

  //Cerrar sesión
  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _userData = null; // 🔹 limpiar datos de usuario
    notifyListeners();
  }
}
