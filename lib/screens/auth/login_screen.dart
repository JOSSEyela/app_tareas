import 'package:app_tareas_prueba/routes.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  // Controladores para los campos de texto
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(147, 255, 255, 255), Color.fromARGB(146, 255, 255, 255)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo o título
                  const Icon(Icons.lock, size: 80, color: Color.fromARGB(255, 123, 60, 224)),
                  const SizedBox(height: 20),
                  const Text(
                    "Bienvenido",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Inicia sesión para continuar",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 40),

                  // Campo de email
                  CustomTextField(
                    label: "Correo electrónico",
                    icon: Icons.email,
                    controller: emailController,
                  ),
                  const SizedBox(height: 20),

                  // Campo de contraseña
                  CustomTextField(
                    label: "Contraseña",
                    icon: Icons.lock,
                    isPassword: true,
                    controller: passwordController,
                  ),
                  const SizedBox(height: 30),

                  // Botón de iniciar sesión
                  CustomButton(
                    text: "Iniciar Sesión",
                    onPressed: () {
                      // Aquí luego se agregará la lógica con Firebase
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Iniciando sesión...")),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Link de registro
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("¿No tienes cuenta? "),
                      GestureDetector(
                        onTap: () {
                          // Navegación futura a la pantalla de registro
                          Navigator.pushNamed(context, AppRoutes.register);
                        },
                        child: const Text(
                          "Regístrate",
                          style: TextStyle(
                            color: Color.fromARGB(255, 123, 60, 224),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
