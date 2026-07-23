import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/providers/todo_provider.dart';
import 'package:todoapp/screens/add_todo_screen.dart';
import 'package:todoapp/widgets/todo_card.dart';
import 'package:todoapp/widgets/category_filter.dart';

/// Pantalla Principal
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tareas'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Buscador
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar tareas...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<TodoProvider>().searchTodos('');
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                context.read<TodoProvider>().searchTodos(value);
                setState(() {});
              },
            ),
          ),
          // Filtros de categoría
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Consumer<TodoProvider>(
              builder: (context, provider, _) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: provider.categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category),
                          selected: provider.selectedCategory == category,
                          onSelected: (_) {
                            provider.setSelectedCategory(category);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // Filtros de estado
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Consumer<TodoProvider>(
              builder: (context, provider, _) {
                return Row(
                  children: [
                    _buildFilterButton(
                      label: 'Todas',
                      isActive: provider.filterType == 'all',
                      onTap: () => provider.setFilterType('all'),
                    ),
                    const SizedBox(width: 8),
                    _buildFilterButton(
                      label: 'Activas',
                      isActive: provider.filterType == 'active',
                      onTap: () => provider.setFilterType('active'),
                    ),
                    const SizedBox(width: 8),
                    _buildFilterButton(
                      label: 'Completadas',
                      isActive: provider.filterType == 'completed',
                      onTap: () => provider.setFilterType('completed'),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // Lista de tareas
          Expanded(
            child: Consumer<TodoProvider>(
              builder: (context, provider, _) {
                if (provider.todos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.task_alt,
                          size: 64,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay tareas',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Crea una nueva tarea para comenzar',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: provider.todos.length,
                  itemBuilder: (context, index) {
                    return TodoCard(todo: provider.todos[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddTodoScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterButton({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive
                    ? const Color(0xFF6200EE)
                    : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive
                  ? const Color(0xFF6200EE)
                  : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
