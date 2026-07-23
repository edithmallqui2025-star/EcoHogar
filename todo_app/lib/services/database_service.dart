import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:todoapp/models/todo_model.dart';

/// Servicio de Base de Datos Local
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  /// Obtener base de datos
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Inicializar base de datos
  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'todoapp.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  /// Crear tablas
  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        category TEXT NOT NULL,
        priority TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        dueDate TEXT,
        isCompleted INTEGER NOT NULL,
        completedAt TEXT
      )
    ''');
  }

  /// Insertar tarea
  Future<void> insertTodo(TodoModel todo) async {
    final db = await database;
    await db.insert(
      'todos',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Obtener todas las tareas
  Future<List<TodoModel>> getAllTodos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('todos');
    return List.generate(
      maps.length,
      (i) => TodoModel.fromMap(maps[i]),
    );
  }

  /// Obtener tareas por categoría
  Future<List<TodoModel>> getTodosByCategory(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      where: 'category = ?',
      whereArgs: [category],
    );
    return List.generate(
      maps.length,
      (i) => TodoModel.fromMap(maps[i]),
    );
  }

  /// Obtener tareas activas
  Future<List<TodoModel>> getActiveTodos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      where: 'isCompleted = ?',
      whereArgs: [0],
    );
    return List.generate(
      maps.length,
      (i) => TodoModel.fromMap(maps[i]),
    );
  }

  /// Obtener tareas completadas
  Future<List<TodoModel>> getCompletedTodos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      where: 'isCompleted = ?',
      whereArgs: [1],
    );
    return List.generate(
      maps.length,
      (i) => TodoModel.fromMap(maps[i]),
    );
  }

  /// Actualizar tarea
  Future<void> updateTodo(TodoModel todo) async {
    final db = await database;
    await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  /// Eliminar tarea
  Future<void> deleteTodo(String id) async {
    final db = await database;
    await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Buscar tareas
  Future<List<TodoModel>> searchTodos(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      where: 'title LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return List.generate(
      maps.length,
      (i) => TodoModel.fromMap(maps[i]),
    );
  }

  /// Contar tareas
  Future<int> getTodoCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM todos');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Eliminar todas las tareas
  Future<void> deleteAllTodos() async {
    final db = await database;
    await db.delete('todos');
  }
}
