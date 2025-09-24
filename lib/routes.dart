import 'package:app_tareas_prueba/screens/auth/login_screen.dart';
import 'package:app_tareas_prueba/screens/auth/register_screen.dart';
import 'package:app_tareas_prueba/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_tareas_prueba/screens/tasks_screen.dart';

class AppRoutes {
  // Rutas como constantes
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String tasks = '/tasks';

  // Mapeo de rutas
  static Map<String, WidgetBuilder> routes = {
    login: (context) => LoginScreen(),
    register: (context) => RegisterScreen(),
    home: (context) => HomeScreen(),
    tasks: (context) => TasksScreen(),
  };
}

