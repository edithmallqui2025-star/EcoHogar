/// Modelo de Insignia/Badge
class BadgeModel {
  final String id;
  final String name;
  final String description;
  final String icon;
  final int pointsRequired;
  final int recyclingCountRequired;
  final DateTime unlockedAt;

  BadgeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.pointsRequired,
    required this.recyclingCountRequired,
    required this.unlockedAt,
  });

  /// Insignias predefinidas
  static List<BadgeModel> getPredefinedBadges() {
    return [
      BadgeModel(
        id: 'starter',
        name: 'Reciclador Inicial',
        description: 'Registra tu primer reciclaje',
        icon: '🌱',
        pointsRequired: 0,
        recyclingCountRequired: 1,
        unlockedAt: DateTime.now(),
      ),
      BadgeModel(
        id: 'green_protector',
        name: 'Protector Verde',
        description: 'Acumula 500 puntos',
        icon: '🌿',
        pointsRequired: 500,
        recyclingCountRequired: 0,
        unlockedAt: DateTime.now(),
      ),
      BadgeModel(
        id: 'eco_champion',
        name: 'Eco Campeón',
        description: 'Acumula 2000 puntos',
        icon: '🏆',
        pointsRequired: 2000,
        recyclingCountRequired: 0,
        unlockedAt: DateTime.now(),
      ),
      BadgeModel(
        id: 'planet_guardian',
        name: 'Guardián del Planeta',
        description: 'Acumula 5000 puntos',
        icon: '🌍',
        pointsRequired: 5000,
        recyclingCountRequired: 0,
        unlockedAt: DateTime.now(),
      ),
    ];
  }
}
