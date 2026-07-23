import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/models/todo_model.dart';
import 'package:todoapp/providers/todo_provider.dart';

/// Tarjeta de tarea
class TodoCard extends StatelessWidget {
  final TodoModel todo;

  const TodoCard({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) {
            context.read<TodoProvider>().toggleTodo(todo);
          },
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: todo.isCompleted ? Colors.grey : Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (todo.description != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  todo.description!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                // Categoría
                Chip(
                  label: Text(todo.category),
                  avatar: Icon(todo.getCategoryIcon(), size: 16),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                  padding: EdgeInsets.zero,
                ),
                const SizedBox(width: 8),
                // Prioridad
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: todo.getPriorityColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    todo.priority,
                    style: TextStyle(
                      color: todo.getPriorityColor(),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Fecha de vencimiento
                if (todo.dueDate != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      DateFormat('dd/MM').format(todo.dueDate!),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Text('Editar'),
              onTap: () {
                // Implementar edición
              },
            ),
            PopupMenuItem(
              child: const Text('Eliminar'),
              onTap: () {
                context.read<TodoProvider>().deleteTodo(todo.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
