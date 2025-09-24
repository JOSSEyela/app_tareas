import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    final List<Color> taskColors = [
      const Color.fromARGB(55, 255, 255, 255),
      const Color.fromARGB(48, 153, 104, 209),
    ];

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  Línea divisoria debajo del AppBar
          const Divider(
            thickness: 2,
            color: Colors.grey,
          ),

          //  Lista de tareas
          Expanded(
            child: StreamBuilder<List<Task>>(
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
                    final backgroundColor = taskColors[index % taskColors.length];

                    return Container(
                      color: backgroundColor, // Fondo alternado
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 4.0),
                            title: Text(
                              task.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            subtitle: Text('Estado: ${task.status}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.check, color: Colors.green),
                                  tooltip: 'Finalizar tarea',
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
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  tooltip: 'Eliminar tarea',
                                  onPressed: () => taskProvider.deleteTask(task.id),
                                ),
                              ],
                            ),
                          ),
                          //  Media línea divisoria para separar tareas
                          const Divider(
                            thickness: 1,
                            indent: 16,
                            endIndent: 16,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
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
                title: titleController.text.trim(),
                status: 'pendiente',
                createdAt: DateTime.now(),
              );
              if (task.title.isNotEmpty) {
                taskProvider.addTask(task);
              }
              Navigator.pop(context);
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }
}
