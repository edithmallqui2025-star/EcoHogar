import 'package:flutter/material.dart';
import 'package:eco_hogar/widgets/custom_app_bar.dart';
import 'package:eco_hogar/services/auth_service.dart';
import 'package:eco_hogar/services/certificate_service.dart';

/// Pantalla de Certificados
class CertificatesScreen extends StatefulWidget {
  const CertificatesScreen({Key? key}) : super(key: key);

  @override
  State<CertificatesScreen> createState() => _CertificatesScreenState();
}

class _CertificatesScreenState extends State<CertificatesScreen> {
  final AuthService _authService = AuthService();
  final CertificateService _certificateService = CertificateService();
  bool _isLoading = false;

  Future<void> _generateCertificate() async {
    setState(() => _isLoading = true);

    try {
      var user = await _authService.getCurrentUser();
      if (user == null) throw Exception('Usuario no encontrado');

      var file = await _certificateService.generateMonthlyCertificate(
        userName: user.name,
        totalRecycled: user.totalRecycled,
        totalPoints: user.totalPoints,
        community: user.community,
        month: DateTime.now(),
      );

      if (file != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Certificado guardado en: ${file.path}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Certificados',
        showBackButton: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.card_membership,
                size: 80,
                color: const Color(0xFF2ECC71).withOpacity(0.5),
              ),
              const SizedBox(height: 24),
              Text(
                'Certificado del Mes',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'Genera tu certificado de impacto ambiental',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _generateCertificate,
                icon: const Icon(Icons.download),
                label: Text(_isLoading ? 'Generando...' : 'Generar Certificado'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
