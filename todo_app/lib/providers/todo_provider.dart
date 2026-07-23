import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:todoapp/models/todo_model.dart';
import 'package:todoapp/services/database_service.dart';
import 'package:todoapp/services/notification_service.dart';

/// Provider para gestionar tareas
class TodoProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final NotificationService _notificationService = NotificationService();

  List<TodoModel> _todos = [];
  List<TodoModel> _filteredTodos = [];
  String _filterType = 'all'; // all, active, completed
  String _selectedCategory = 'Todas';

  List<TodoModel> get todos => _filteredTodos;
  String get filterType => _filterType;
  String get selectedCategory => _selectedCategory;

  List<String> categories = [
    'Todas',
    'Trabajo',
    'Personal',
    'Compras',
    'Salud',
    'Educación'
  ];

  /// Inicializar provider
  TodoProvider() {
    loadTodos();
  }

  /// Cargar todas las tareas
  Future<void> loadTodos() async {
    try {
      _todos = await _databaseService.getAllTodos();
      _applyFilters();
    } catch (e) {
      print('Error cargando tareas: $e');
    }
  }

  /// Agregar nueva tarea
  Future<void> addTodo({
    required String title,
    String? description,
    required String category,
    required String priority,
    DateTime? dueDate,
  }) async {
    try {
      final todo = TodoModel(
        id: const Uuid().v4(),
        title: title,
        description: description,
        category: category,
        priority: priority,
        createdAt: DateTime.now(),
        dueDate: dueDate,
      );

      await _databaseService.insertTodo(todo);
      _todos.add(todo);

      // Programar notificación si tiene fecha de vencimiento
      if (dueDate != null) {
        await _notificationService.scheduleNotification(
          id: todo.id.hashCode,
          title: 'Recordatorio: $title',
          body: 'Tu tarea vence hoy',
          scheduledDate: dueDate,
        );
      }

      _applyFilters();
    } catch (e) {
      print('Error agregando tarea: $e');
    }
  }

  /// Actualizar tarea
  Future<void> updateTodo(TodoModel todo) async {
    try {
      await _databaseService.updateTodo(todo);
      final index = _todos.indexWhere((t) => t.id == todo.id);
      if (index != -1) {
        _todos[index] = todo;
      }
      _applyFilters();
    } catch (e) {
      print('Error actualizando tarea: $e');
    }
  }

  /// Marcar como completada
  Future<void> toggleTodo(TodoModel todo) async {
    try {
      final updatedTodo = todo.copyWith(
        isCompleted: !todo.isCompleted,
        completedAt: !todo.isCompleted ? DateTime.now() : null,
      );
      await updateTodo(updatedTodo);

      if (updatedTodo.isCompleted) {
        _notificationService.showNotification(
          id: todo.id.hashCode,
          title: '¡Tarea completada!',
          body: todo.title,
        );
      }
    } catch (e) {
      print('Error completando tarea: $e');
    }
  }

  /// Eliminar tarea
  Future<void> deleteTodo(String id) async {
    try {
      await _databaseService.deleteTodo(id);
      _todos.removeWhere((todo) => todo.id == id);
      _applyFilters();
    } catch (e) {
      print('Error eliminando tarea: $e');
    }
  }

  /// Buscar tareas
  Future<void> searchTodos(String query) async {
    try {
      if (query.isEmpty) {
        _applyFilters();
      } else {
        _filteredTodos = await _databaseService.searchTodos(query);
      }
      notifyListeners();
    } catch (e) {
      print('Error buscando tareas: $e');
    }
  }

  /// Cambiar filtro
  void setFilterType(String filter) {
    _filterType = filter;
    _applyFilters();
  }

  /// Cambiar categoría
  void setSelectedCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  /// Aplicar filtros
  void _applyFilters() {
    _filteredTodos = _todos.where((todo) {
      // Filtro por tipo
      if (_filterType == 'active' && todo.isCompleted) return false;
      if (_filterType == 'completed' && !todo.isCompleted) return false;

      // Filtro por categoría
      if (_selectedCategory != 'Todas' && todo.category != _selectedCategory) {
        return false;
      }

      return true;
    }).toList();

    // Ordenar por prioridad y fecha de vencimiento
    _filteredTodos.sort((a, b) {
      if (a.isCompleted == b.isCompleted) {
        final priorityOrder = {'Alta': 0, 'Media': 1, 'Baja': 2};
        final aPriority = priorityOrder[a.priority] ?? 3;
        final bPriority = priorityOrder[b.priority] ?? 3;
        if (aPriority != bPriority) return aPriority.compareTo(bPriority);
        return a.createdAt.compareTo(b.createdAt);
      }
      return a.isCompleted ? 1 : -1;
    });

    notifyListeners();
  }
}
