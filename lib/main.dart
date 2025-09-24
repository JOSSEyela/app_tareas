import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // lo generó flutterfire configure
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Tareas',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _mensaje = "Conectando con Firebase...";

  @override
  void initState() {
    super.initState();
    _probarConexion();
  }

  Future<void> _probarConexion() async {
    try {
      // Crear un documento de prueba en Firestore
      await FirebaseFirestore.instance.collection("prueba").add({
        "mensaje": "Hola desde Flutter 🚀",
        "timestamp": DateTime.now(),
      });

      setState(() {
        _mensaje = "✅ Conectado a Firebase y guardado en Firestore";
      });
    } catch (e) {
      setState(() {
        _mensaje = "❌ Error conectando a Firebase: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Prueba Firebase")),
      body: Center(child: Text(_mensaje)),
    );
  }
}
