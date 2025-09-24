import 'package:flutter/material.dart';

import '../models/task.dart'; // Modelo Task
import '../services/firestore_service.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  final FirestoreService _firestoreService = FirestoreService();
  bool _isSaving = false; // Estado para mostrar loading mientras se guarda

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  /// Guarda la tarea usando FirestoreService
  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      // Creamos un Task sin id (Firestore lo genera)
      final task = Task(
        id: '', // Firestore asignará el ID
        title: _titleController.text,
        status: 'pendiente',
        createdAt: DateTime.now(),
      );

      try {
        await _firestoreService.addTask(task); // Conecta con el CRUD
        if (!mounted) return;
        Navigator.pop(context); // Cierra la pantalla
      } catch (e) {
        setState(() {
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error guardando la tarea: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Tarea')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'El título es obligatorio' : null,
              ),
              const SizedBox(height: 24),
              Center(
                child: _isSaving
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text('Guardar'),
                        onPressed: _saveTask,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
