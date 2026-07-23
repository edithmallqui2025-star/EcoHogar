import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/providers/todo_provider.dart';

/// Pantalla para agregar nueva tarea
class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({Key? key}) : super(key: key);

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  String _selectedCategory = 'Personal';
  String _selectedPriority = 'Media';
  DateTime? _selectedDate;

  final List<String> _categories = [
    'Trabajo',
    'Personal',
    'Compras',
    'Salud',
    'Educación'
  ];
  final List<String> _priorities = ['Baja', 'Media', 'Alta'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  void _saveTodo() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un título')),
      );
      return;
    }

    context.read<TodoProvider>().addTodo(
          title: _titleController.text,
          description: _descriptionController.text.isEmpty
              ? null
              : _descriptionController.text,
          category: _selectedCategory,
          priority: _selectedPriority,
          dueDate: _selectedDate,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('¡Tarea creada!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Tarea'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Título de la tarea',
                prefixIcon: const Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 16),
            // Descripción
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Descripción (opcional)',
                prefixIcon: const Icon(Icons.description),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            // Categoría
            Text(
              'Categoría',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _categories.map((category) {
                return ChoiceChip(
                  label: Text(category),
                  selected: _selectedCategory == category,
                  onSelected: (selected) {
                    setState(() => _selectedCategory = category);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            // Prioridad
            Text(
              'Prioridad',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _priorities.map((priority) {
                return ChoiceChip(
                  label: Text(priority),
                  selected: _selectedPriority == priority,
                  onSelected: (selected) {
                    setState(() => _selectedPriority = priority);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            // Fecha de vencimiento
            Text(
              'Fecha de vencimiento',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _selectDate,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 12),
                    Text(
                      _selectedDate != null
                          ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                          : 'Selecciona una fecha',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Botón guardar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveTodo,
                child: const Text('Crear Tarea'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
