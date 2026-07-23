import 'package:flutter/material.dart';
import 'package:eco_hogar/widgets/custom_button.dart';
import 'package:eco_hogar/config/routes/app_routes.dart';

/// Pantalla de Onboarding inicial
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'title': 'Bienvenido a EcoHogar',
      'description':
          'Cada residuo bien separado ayuda a cuidar nuestro planeta.',
      'icon': '🏠',
    },
    {
      'title': 'Registra tu Reciclaje',
      'description': 'Documenta cada acción de reciclaje de manera fácil.',
      'icon': '♻️',
    },
    {
      'title': 'Gana Puntos y Insignias',
      'description':
          'Desbloquea logros y sube de nivel mientras ayudas al planeta.',
      'icon': '🏆',
    },
    {
      'title': 'Impacto Ambiental',
      'description':
          'Visualiza el impacto positivo que tu reciclaje tiene en el mundo.',
      'icon': '🌍',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  final data = onboardingData[index];
                  return Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          data['icon']!,
                          style: const TextStyle(fontSize: 80),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          data['title']!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          data['description']!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Indicadores
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingData.length,
                      (index) => Container(
                        width: _currentPage == index ? 32 : 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: _currentPage == index
                              ? const Color(0xFF2ECC71)
                              : const Color(0xFFECF0F1),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Botones
                  if (_currentPage < onboardingData.length - 1)
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            label: 'Atrás',
                            onPressed: _currentPage > 0
                                ? () {
                                    _pageController.previousPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                : () {},
                            isOutlined: true,
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomButton(
                            label: 'Siguiente',
                            onPressed: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  else
                    CustomButton(
                      label: 'Comenzar',
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(AppRoutes.register);
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
