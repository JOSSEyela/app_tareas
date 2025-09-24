import 'package:app_tareas_prueba/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../providers/theme_provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Iniciar sesión"),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, theme, _) => IconButton(
              tooltip: theme.isDark ? 'Modo claro' : 'Modo oscuro',
              icon: Icon(theme.isDark ? Icons.dark_mode : Icons.light_mode),
              onPressed: () => theme.toggle(),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [cs.surface, cs.surfaceVariant],
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
                  Icon(Icons.lock, size: 80, color: cs.primary),
                  const SizedBox(height: 20),
                  Text("Bienvenido", style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("Inicia sesión para continuar", style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
                  const SizedBox(height: 40),
                  CustomTextField(
                    label: "Correo electrónico",
                    icon: Icons.email,
                    controller: emailController,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: "Contraseña",
                    icon: Icons.lock,
                    isPassword: true,
                    controller: passwordController,
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: "Iniciar Sesión",
                    onPressed: () async {
                      final email = emailController.text.trim();
                      final password = passwordController.text.trim();

                      if (email.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Por favor ingresa todos los campos")),
                        );
                        return;
                      }

                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
                        Navigator.pushReplacementNamed(context, AppRoutes.home);
                      } on FirebaseAuthException catch (e) {
                        String mensaje = "Ocurrió un error";
                        if (e.code == 'user-not-found') {
                          mensaje = "Usuario no encontrado";
                        } else if (e.code == 'wrong-password') {
                          mensaje = "Contraseña incorrecta";
                        }
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("¿No tienes cuenta? ", style: tt.bodyMedium),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.register);
                        },
                        child: Text(
                          "Regístrate",
                          style: tt.bodyMedium?.copyWith(color: cs.primary, fontWeight: FontWeight.bold),
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