import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(147, 255, 255, 255),
              Color.fromARGB(146, 255, 255, 255),
            ],
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
                  const Icon(Icons.person_add,
                      size: 80, color: Color.fromARGB(255, 123, 60, 224)),
                  const SizedBox(height: 20),
                  const Text(
                    "Crear cuenta",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Regístrate para continuar",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 40),

                  // Campo de nombre de usuario
                  CustomTextField(
                    label: "Nombre de usuario",
                    icon: Icons.person,
                    controller: usernameController,
                  ),
                  const SizedBox(height: 20),

                  // Campo de correo
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

                  // Botón de registro
                  CustomButton(
                    text: "Registrarse",
                    onPressed: () async {
                      try {
                        await authProvider.register(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );

                        // Aquí más adelante guardaremos el "username" en Firestore

                        Navigator.pushReplacementNamed(context, "/home");
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: $e")),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),

                  // Link a login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("¿Ya tienes cuenta? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, "/login");
                        },
                        child: const Text(
                          "Inicia sesión",
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
