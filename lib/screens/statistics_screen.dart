import 'package:flutter/material.dart';
import 'package:eco_hogar/widgets/custom_app_bar.dart';

/// Pantalla de Estadísticas
class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Estadísticas',
        showBackButton: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart,
              size: 64,
              color: const Color(0xFF2ECC71).withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Estadísticas en Desarrollo',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Los gráficos de impacto ambiental estarán disponibles pronto',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
