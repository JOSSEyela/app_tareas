import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../routes.dart';
import 'profile_screen.dart';
import 'tasks_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    TaskListHome(),
    TasksScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi App de Tareas'),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, theme, _) => IconButton(
              tooltip: theme.isDark ? 'Modo claro' : 'Modo oscuro',
              icon: Icon(theme.isDark ? Icons.dark_mode : Icons.light_mode),
              onPressed: () => theme.toggle(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await authProvider.logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: cs.primary,
        unselectedItemColor: cs.onSurfaceVariant,
        backgroundColor: cs.surface,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tareas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

class TaskListHome extends StatelessWidget {
  const TaskListHome({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return StreamBuilder<List<Task>>(
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
            );
          },
        );
      },
    );
  }
}
