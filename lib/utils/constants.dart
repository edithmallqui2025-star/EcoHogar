// Constantes de la aplicación

class AppConstants {
  // URLs
  static const String firebaseProjectId = 'YOUR_PROJECT_ID';

  // Mensajes
  static const String welcomeMessage =
      'Cada residuo bien separado ayuda a cuidar nuestro planeta.';
  static const String appName = 'EcoHogar';

  // Números
  static const int minPasswordLength = 8;
  static const int phoneNumberLength = 10;

  // Niveles de usuario
  static const Map<String, int> userLevels = {
    'Semilla': 0,
    'Árbol': 500,
    'Bosque': 2000,
  };

  // Impacto ambiental estimado
  static const Map<String, dynamic> environmentalImpact = {
    'plastic': {'co2': 0.05, 'description': 'kg de CO2 evitado'},
    'paper': {'co2': 0.03, 'description': 'kg de CO2 evitado'},
    'cardboard': {'co2': 0.04, 'description': 'kg de CO2 evitado'},
    'glass': {'co2': 0.06, 'description': 'kg de CO2 evitado'},
    'metal': {'co2': 0.08, 'description': 'kg de CO2 evitado'},
    'organic': {'co2': 0.02, 'description': 'kg de CO2 evitado'},
  };

  // Consejos de educación ambiental
  static const List<Map<String, String>> educationTips = [
    {
      'title': 'Separación de Plástico',
      'content':
          'Lava y aplasta las botellas plásticas antes de reciclarlas. Esto ahorra espacio en los contenedores.',
      'icon': '♻️'
    },
    {
      'title': 'Reciclaje de Papel',
      'content':
          'El papel se puede reciclar hasta 7 veces. Evita mezclar papel mojado o sucio.',
      'icon': '📄'
    },
    {
      'title': 'Vidrio Transparente',
      'content':
          'Separa el vidrio transparente del oscuro. Retira etiquetas y tapa antes de reciclar.',
      'icon': '🍷'
    },
    {
      'title': 'Metal Limpio',
      'content':
          'Enjuaga las latas antes de reciclarlas. El metal es 100% reciclable sin perder calidad.',
      'icon': '⚙️'
    },
    {
      'title': 'Compostaje Orgánico',
      'content':
          'Los residuos orgánicos se pueden convertir en compost para el jardín. No necesitan recicladoras.',
      'icon': '🌱'
    },
    {
      'title': 'Cartón Corrugado',
      'content':
          'Aplasta las cajas de cartón para ahorrar espacio. Retira cintas adhesivas y empaques.',
      'icon': '📦'
    },
  ];
}
