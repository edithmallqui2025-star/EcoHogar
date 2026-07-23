import 'package:flutter/material.dart';

/// Rutas de la aplicación
class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String register = '/register';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String scanQR = '/scan-qr';
  static const String registerRecycling = '/register-recycling';
  static const String history = '/history';
  static const String statistics = '/statistics';
  static const String education = '/education';
  static const String settings = '/settings';
  static const String certificates = '/certificates';

  static final Map<String, WidgetBuilder> routes = {
    onboarding: (context) => const OnboardingScreen(),
    register: (context) => const RegisterScreen(),
    login: (context) => const LoginScreen(),
    dashboard: (context) => const DashboardScreen(),
    scanQR: (context) => const ScanQRScreen(),
    registerRecycling: (context) => const RegisterRecyclingScreen(),
    history: (context) => const HistoryScreen(),
    statistics: (context) => const StatisticsScreen(),
    education: (context) => const EducationScreen(),
    settings: (context) => const SettingsScreen(),
    certificates: (context) => const CertificatesScreen(),
  };
}

// Pantallas placeholder (se implementarán después)
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const Scaffold();
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const Scaffold();
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const Scaffold();
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const Scaffold();
}

class ScanQRScreen extends StatelessWidget {
  const ScanQRScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const Scaffold();
}

class RegisterRecyclingScreen extends StatelessWidget {
  const RegisterRecyclingScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const Scaffold();
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const Scaffold();
}

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const Scaffold();
}

class EducationScreen extends StatelessWidget {
  const EducationScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const Scaffold();
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const Scaffold();
}

class CertificatesScreen extends StatelessWidget {
  const CertificatesScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const Scaffold();
}
