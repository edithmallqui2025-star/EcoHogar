import 'package:flutter/material.dart';

/// Modelo de Tarea
class TodoModel {
  final String id;
  final String title;
  final String? description;
  final String category;
  final String priority; // 'Baja', 'Media', 'Alta'
  final DateTime createdAt;
  final DateTime? dueDate;
  final bool isCompleted;
  final DateTime? completedAt;

  TodoModel({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    this.priority = 'Media',
    required this.createdAt,
    this.dueDate,
    this.isCompleted = false,
    this.completedAt,
  });

  /// Convertir a Map para SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  /// Crear desde Map de SQLite
  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      priority: map['priority'],
      createdAt: DateTime.parse(map['createdAt']),
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      isCompleted: map['isCompleted'] == 1,
      completedAt: map['completedAt'] != null ? DateTime.parse(map['completedAt']) : null,
    );
  }

  /// Copiar con cambios
  TodoModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? priority,
    DateTime? createdAt,
    DateTime? dueDate,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  /// Obtener color según prioridad
  Color getPriorityColor() {
    switch (priority) {
      case 'Alta':
        return Colors.red;
      case 'Media':
        return Colors.orange;
      case 'Baja':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  /// Obtener icono según categoría
  IconData getCategoryIcon() {
    switch (category) {
      case 'Trabajo':
        return Icons.work;
      case 'Personal':
        return Icons.person;
      case 'Compras':
        return Icons.shopping_bag;
      case 'Salud':
        return Icons.health_and_safety;
      case 'Educación':
        return Icons.school;
      default:
        return Icons.task_alt;
    }
  }
}
