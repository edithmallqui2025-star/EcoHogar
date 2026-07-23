import 'package:cloud_firestore/cloud_firestore.dart';

/// Tipos de residuos
enum WasteType {
  plastic('Plástico'),
  paper('Papel'),
  cardboard('Cartón'),
  glass('Vidrio'),
  metal('Metal'),
  organic('Orgánicos');

  final String displayName;
  const WasteType(this.displayName);

  String get icon {
    switch (this) {
      case WasteType.plastic:
        return '♻️';
      case WasteType.paper:
        return '📄';
      case WasteType.cardboard:
        return '📦';
      case WasteType.glass:
        return '🍷';
      case WasteType.metal:
        return '⚙️';
      case WasteType.organic:
        return '🌱';
    }
  }
}

/// Modelo de Registro de Reciclaje
class RecyclingModel {
  final String id;
  final String userId;
  final WasteType wasteType;
  final double quantity; // en kg
  final String unit; // kg o unidades
  final DateTime date;
  final int pointsEarned;
  final String? photoUrl;
  final String? qrCode;
  final DateTime createdAt;
  final String notes;

  RecyclingModel({
    required this.id,
    required this.userId,
    required this.wasteType,
    required this.quantity,
    required this.unit,
    required this.date,
    required this.pointsEarned,
    this.photoUrl,
    this.qrCode,
    required this.createdAt,
    this.notes = '',
  });

  /// Calcular puntos automáticamente
  static int calculatePoints(double quantity, WasteType type) {
    // Base: 10 puntos por kg
    int basePoints = (quantity * 10).toInt();
    
    // Bonus según tipo
    int bonus = 0;
    switch (type) {
      case WasteType.plastic:
        bonus = 5;
        break;
      case WasteType.glass:
        bonus = 15;
        break;
      case WasteType.metal:
        bonus = 20;
        break;
      default:
        bonus = 5;
    }
    
    return basePoints + bonus;
  }

  /// Convertir a JSON para Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'wasteType': wasteType.name,
      'quantity': quantity,
      'unit': unit,
      'date': date,
      'pointsEarned': pointsEarned,
      'photoUrl': photoUrl,
      'qrCode': qrCode,
      'createdAt': createdAt,
      'notes': notes,
    };
  }

  /// Crear desde JSON de Firestore
  factory RecyclingModel.fromJson(Map<String, dynamic> json) {
    return RecyclingModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      wasteType: WasteType.values.byName(json['wasteType'] ?? 'plastic'),
      quantity: (json['quantity'] ?? 0).toDouble(),
      unit: json['unit'] ?? 'kg',
      date: (json['date'] as Timestamp).toDate(),
      pointsEarned: json['pointsEarned'] ?? 0,
      photoUrl: json['photoUrl'],
      qrCode: json['qrCode'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      notes: json['notes'] ?? '',
    );
  }
}
