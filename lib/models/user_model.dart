// lib/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;         // uid
  final String username;
  final String email;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.createdAt,
  });

  // Mapear Firestore → UserModel
  factory UserModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Mapear UserModel → Map para guardar
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'createdAt': createdAt,
    };
  }
}
