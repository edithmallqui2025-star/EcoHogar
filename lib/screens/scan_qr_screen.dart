import 'package:flutter/material.dart';
import 'package:eco_hogar/widgets/custom_app_bar.dart';

/// Pantalla de Escaneo QR
class ScanQRScreen extends StatelessWidget {
  const ScanQRScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Escanear QR',
        showBackButton: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.qr_code_2,
              size: 64,
              color: const Color(0xFF2ECC71).withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Escaneo QR en Desarrollo',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'La funcionalidad de escaneo QR estará disponible pronto',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
