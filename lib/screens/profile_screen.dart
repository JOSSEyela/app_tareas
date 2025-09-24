import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    
    if (authProvider.userData == null && authProvider.user != null) {
      authProvider.loadUserData();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: false,
      ),
      body: authProvider.userData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar
                      const CircleAvatar(
                        radius: 40,
                        child: Icon(Icons.person, size: 50),
                      ),
                      const SizedBox(width: 16),
                      // Datos usuario
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authProvider.userData!.username,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            authProvider.userData!.email,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),

                 

                  const SizedBox(height: 20),
                  const Divider(thickness: 1),
                  const SizedBox(height: 10),

                  // Botón cerrar sesión
                  ElevatedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text("Cerrar sesión"),
                    onPressed: () async {
                      await authProvider.logout();
                      // Navegar al login
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}

