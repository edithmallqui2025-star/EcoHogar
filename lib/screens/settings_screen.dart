import 'package:flutter/material.dart';
import 'package:eco_hogar/widgets/custom_app_bar.dart';
import 'package:eco_hogar/services/auth_service.dart';
import 'package:eco_hogar/config/routes/app_routes.dart';

/// Pantalla de Configuración
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();
  bool _darkMode = false;
  String _language = 'es';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Configuración',
        showBackButton: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Sección de apariencia
          Text(
            'Apariencia',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Tema Oscuro'),
            trailing: Switch(
              value: _darkMode,
              onChanged: (value) {
                setState(() => _darkMode = value);
              },
            ),
          ),
          const Divider(),
          // Idioma
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Idioma'),
            trailing: DropdownButton<String>(
              value: _language,
              items: const [
                DropdownMenuItem(value: 'es', child: Text('Español')),
                DropdownMenuItem(value: 'en', child: Text('English')),
              ],
              onChanged: (value) {
                setState(() => _language = value ?? 'es');
              },
            ),
          ),
          const Divider(),
          const SizedBox(height: 24),
          // Sección de cuenta
          Text(
            'Cuenta',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Perfil'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Editar perfil - Próximamente')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Cambiar Contraseña'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cambiar contraseña - Próximamente')),
              );
            },
          ),
          const Divider(),
          const SizedBox(height: 24),
          // Sección de información
          Text(
            'Información',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Acerca de EcoHogar'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'EcoHogar',
                applicationVersion: '1.0.0',
                applicationLegalese:
                    '© 2024 EcoHogar. Todos los derechos reservados.',
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Ayuda y Soporte'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ayuda - Próximamente')),
              );
            },
          ),
          const Divider(),
          const SizedBox(height: 24),
          // Botón de cerrar sesión
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.red),
            ),
            trailing: const Icon(Icons.arrow_forward, color: Colors.red),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Cerrar Sesión'),
                  content: const Text(
                      '¿Estás seguro de que deseas cerrar sesión?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await _authService.logout();
                        if (mounted) {
                          Navigator.of(context).pushReplacementNamed(
                            AppRoutes.login,
                          );
                        }
                      },
                      child: const Text(
                        'Cerrar Sesión',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
