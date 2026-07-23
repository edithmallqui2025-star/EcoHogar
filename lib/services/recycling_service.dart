import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:eco_hogar/models/recycling_model.dart';
import 'package:eco_hogar/config/firebase_config.dart';

/// Servicio de Reciclaje
class RecyclingService {
  final FirebaseFirestore _firestore = FirebaseConfig.firestore;
  const uuid = const Uuid();

  /// Registrar nuevo reciclaje
  Future<RecyclingModel?> registerRecycling({
    required String userId,
    required WasteType wasteType,
    required double quantity,
    required String unit,
    required DateTime date,
    String? photoUrl,
    String? qrCode,
    String notes = '',
  }) async {
    try {
      int points = RecyclingModel.calculatePoints(quantity, wasteType);

      RecyclingModel recycling = RecyclingModel(
        id: const Uuid().v4(),
        userId: userId,
        wasteType: wasteType,
        quantity: quantity,
        unit: unit,
        date: date,
        pointsEarned: points,
        photoUrl: photoUrl,
        qrCode: qrCode,
        createdAt: DateTime.now(),
        notes: notes,
      );

      await _firestore
          .collection('recycling')
          .doc(recycling.id)
          .set(recycling.toJson());

      // Actualizar estadísticas del usuario
      await _updateUserStats(userId, points, quantity);

      return recycling;
    } catch (e) {
      print('Error registrando reciclaje: $e');
      return null;
    }
  }

  /// Obtener historial de reciclaje del usuario
  Future<List<RecyclingModel>> getUserRecyclingHistory(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('recycling')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) =>
              RecyclingModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error obteniendo historial: $e');
      return [];
    }
  }

  /// Obtener reciclajes del mes actual
  Future<List<RecyclingModel>> getMonthlyRecycling(String userId) async {
    try {
      DateTime now = DateTime.now();
      DateTime startOfMonth = DateTime(now.year, now.month, 1);
      DateTime endOfMonth = DateTime(now.year, now.month + 1, 0);

      QuerySnapshot snapshot = await _firestore
          .collection('recycling')
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: startOfMonth)
          .where('date', isLessThanOrEqualTo: endOfMonth)
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) =>
              RecyclingModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error obteniendo reciclajes mensuales: $e');
      return [];
    }
  }

  /// Actualizar estadísticas del usuario
  Future<void> _updateUserStats(
      String userId, int points, double quantity) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'totalPoints': FieldValue.increment(points),
        'totalRecycled': FieldValue.increment(quantity),
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      print('Error actualizando estadísticas: $e');
    }
  }

  /// Obtener estadísticas por tipo de residuo
  Future<Map<String, double>> getRecyclingByType(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('recycling')
          .where('userId', isEqualTo: userId)
          .get();

      Map<String, double> stats = {};
      for (var doc in snapshot.docs) {
        RecyclingModel recycling =
            RecyclingModel.fromJson(doc.data() as Map<String, dynamic>);
        String type = recycling.wasteType.displayName;
        stats[type] = (stats[type] ?? 0) + recycling.quantity;
      }

      return stats;
    } catch (e) {
      print('Error obteniendo estadísticas: $e');
      return {};
    }
  }

  /// Eliminar registro de reciclaje
  Future<bool> deleteRecycling(String recyclingId, int points) async {
    try {
      await _firestore.collection('recycling').doc(recyclingId).delete();
      return true;
    } catch (e) {
      print('Error eliminando reciclaje: $e');
      return false;
    }
  }
}
