import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  // Stream tipado
  Stream<List<Task>> get tasksStream => _firestoreService.getTasks();

  // Añadir
  Future<void> addTask(Task task) async {
    await _firestoreService.addTask(task);
  }

  // Actualizar
  Future<void> updateTask(String taskId, Task task) async {
    await _firestoreService.updateTask(taskId, task);
  }

  // Eliminar
  Future<void> deleteTask(String taskId) async {
    await _firestoreService.deleteTask(taskId);
  }
}
