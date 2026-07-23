import 'package:flutter/material.dart';
import 'package:eco_hogar/widgets/custom_app_bar.dart';
import 'package:eco_hogar/widgets/stat_card.dart';
import 'package:eco_hogar/widgets/bottom_nav_bar.dart';
import 'package:eco_hogar/services/auth_service.dart';
import 'package:eco_hogar/services/recycling_service.dart';
import 'package:eco_hogar/models/user_model.dart';
import 'package:eco_hogar/config/routes/app_routes.dart';

/// Dashboard principal
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AuthService _authService = AuthService();
  final RecyclingService _recyclingService = RecyclingService();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: _authService.getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Error cargando datos'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.login,
                      (route) => false,
                    ),
                    child: const Text('Volver al login'),
                  ),
                ],
              ),
            ),
          );
        }

        UserModel user = snapshot.data!;

        return Scaffold(
          appBar: CustomAppBar(
            title: 'EcoHogar',
            actions: [
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.settings);
                },
              ),
            ],
          ),
          body: _currentIndex == 0 ? _buildHomeTab(user) : _buildOtherTabs(),
          bottomNavigationBar: BottomNavBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() => _currentIndex = index);
              _navigateToTab(index);
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.scanQR);
            },
            child: const Icon(Icons.qr_code_scanner),
          ),
        );
      },
    );
  }

  Widget _buildHomeTab(UserModel user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Saludo
          Text(
            '¡Hola, ${user.name}!',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Comunidad: ${user.community}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          // Tarjetas de estadísticas
          StatCard(
            title: 'Puntos Acumulados',
            value: '${user.totalPoints}',
            icon: Icons.star,
            backgroundColor: const Color(0xFF3498DB),
          ),
          const SizedBox(height: 12),
          StatCard(
            title: 'Total Reciclado',
            value: '${user.totalRecycled.toStringAsFixed(1)} kg',
            icon: Icons.eco,
            backgroundColor: const Color(0xFF2ECC71),
          ),
          const SizedBox(height: 12),
          StatCard(
            title: 'Nivel del Usuario',
            value: user.userLevel,
            subtitle: _getLevelDescription(user.userLevel),
            icon: Icons.trending_up,
            backgroundColor: const Color(0xFFE67E22),
          ),
          const SizedBox(height: 24),
          // Botones de acción
          Text(
            'Acciones Rápidas',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _buildActionButton(
                icon: Icons.qr_code,
                label: 'Escanear QR',
                onTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.scanQR),
              ),
              _buildActionButton(
                icon: Icons.add,
                label: 'Registrar',
                onTap: () => Navigator.of(context)
                    .pushNamed(AppRoutes.registerRecycling),
              ),
              _buildActionButton(
                icon: Icons.download,
                label: 'Certificado',
                onTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.certificates),
              ),
              _buildActionButton(
                icon: Icons.emoji_events,
                label: 'Insignias',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Insignias - Próximamente')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFF2ECC71).withOpacity(0.1),
          border: Border.all(
            color: const Color(0xFF2ECC71),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: const Color(0xFF2ECC71),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2ECC71),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherTabs() {
    return const Center(
      child: Text('Contenido en desarrollo'),
    );
  }

  String _getLevelDescription(String level) {
    switch (level) {
      case 'Semilla':
        return 'Principiante';
      case 'Árbol':
        return 'Intermedio';
      case 'Bosque':
        return 'Experto';
      default:
        return '';
    }
  }

  void _navigateToTab(int index) {
    switch (index) {
      case 1:
        Navigator.of(context).pushNamed(AppRoutes.history);
        break;
      case 2:
        Navigator.of(context).pushNamed(AppRoutes.statistics);
        break;
      case 3:
        Navigator.of(context).pushNamed(AppRoutes.education);
        break;
      case 4:
        Navigator.of(context).pushNamed(AppRoutes.settings);
        break;
    }
  }
}
