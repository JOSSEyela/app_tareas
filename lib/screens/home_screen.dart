import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔹 Con listen:true porque queremos redibujar si userData cambia
    final authProvider = Provider.of<AuthProvider>(context);

    // 🔹 Obtenemos el modelo de usuario
    final userData = authProvider.userData;

    return Scaffold(
      appBar: AppBar(
        title: Text("Inicio (${userData?.username ?? ''})"), // ejemplo usando username
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();

              //Navega al login y elimina el historial
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Bienvenido ${userData?.username ?? 'Usuario'}",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              "Email: ${userData?.email ?? ''}",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
