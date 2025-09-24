import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final String status; // pendiente, activo, finalizado
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.status,
    required this.createdAt,
  });

  // De Firestore a Task
  factory Task.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      title: data['title'] ?? '',
      status: data['status'] ?? 'pendiente',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // De Task a Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'status': status,
      'createdAt': createdAt,
    };
  }
}
