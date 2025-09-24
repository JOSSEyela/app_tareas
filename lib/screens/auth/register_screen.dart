import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear cuenta"),
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
                  Icon(Icons.person_add, size: 80, color: cs.primary),
                  const SizedBox(height: 20),
                  Text("Crear cuenta", style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("Regístrate para continuar", style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
                  const SizedBox(height: 40),
                  CustomTextField(
                    label: "Nombre de usuario",
                    icon: Icons.person,
                    controller: usernameController,
                  ),
                  const SizedBox(height: 20),
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
                    text: "Registrarse",
                    onPressed: () async {
                      try {
                        await authProvider.register(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                          usernameController.text.trim(),
                        );
                        Navigator.pushReplacementNamed(context, "/login");
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: $e")),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("¿Ya tienes cuenta? ", style: tt.bodyMedium),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, "/login");
                        },
                        child: Text(
                          "Inicia sesión",
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