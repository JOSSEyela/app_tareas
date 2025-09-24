import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis tareas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddTaskDialog(context, taskProvider),
          ),
        ],
      ),
      body: StreamBuilder<List<Task>>(
        stream: taskProvider.tasksStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay tareas aún.'));
          }

          final tasks = snapshot.data!;

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return ListTile(
                title: Text(task.title),
                subtitle: Text('Estado: ${task.status}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () {
                        final updatedTask = Task(
                          id: task.id,
                          title: task.title,
                          status: 'finalizado',
                          createdAt: task.createdAt,
                        );
                        taskProvider.updateTask(task.id, updatedTask);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => taskProvider.deleteTask(task.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, TaskProvider taskProvider) {
    final titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva tarea'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(labelText: 'Título de la tarea'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final task = Task(
                id: '',
                title: titleController.text,
                status: 'pendiente',
                createdAt: DateTime.now(),
              );
              taskProvider.addTask(task);
              Navigator.pop(context);
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }
}
