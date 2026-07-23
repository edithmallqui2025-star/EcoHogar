import 'package:flutter/material.dart';
import 'package:eco_hogar/widgets/custom_app_bar.dart';
import 'package:eco_hogar/services/recycling_service.dart';
import 'package:eco_hogar/services/auth_service.dart';
import 'package:eco_hogar/models/recycling_model.dart';

/// Pantalla de Historial
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final RecyclingService _recyclingService = RecyclingService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Historial de Reciclaje',
        showBackButton: true,
      ),
      body: FutureBuilder<List<RecyclingModel>>(
        future: _recyclingService.getUserRecyclingHistory(
          _authService.currentUserId ?? '',
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inbox, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No hay registros',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            );
          }

          List<RecyclingModel> records = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: records.length,
            itemBuilder: (context, index) {
              RecyclingModel record = records[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF2ECC71).withOpacity(0.1),
                    ),
                    child: Center(
                      child: Text(
                        record.wasteType.icon,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  title: Text(record.wasteType.displayName),
                  subtitle: Text(
                    '${record.quantity} ${record.unit} • ${record.date.day}/${record.date.month}/${record.date.year}',
                  ),
                  trailing: Text(
                    '+${record.pointsEarned}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2ECC71),
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
