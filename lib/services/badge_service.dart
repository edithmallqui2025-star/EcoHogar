import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_hogar/models/badge_model.dart';
import 'package:eco_hogar/config/firebase_config.dart';

/// Servicio de Insignias
class BadgeService {
  final FirebaseFirestore _firestore = FirebaseConfig.firestore;

  /// Obtener insignias desbloqueadas del usuario
  Future<List<String>> getUserBadges(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(userId)
          .get();

      if (doc.exists) {
        List<String> badges = List<String>.from(doc['badges'] ?? []);
        return badges;
      }
      return [];
    } catch (e) {
      print('Error obteniendo insignias: $e');
      return [];
    }
  }

  /// Desbloquear insignia
  Future<bool> unlockBadge(String userId, String badgeId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(userId)
          .get();

      List<String> currentBadges =
          List<String>.from(doc['badges'] ?? []);

      if (!currentBadges.contains(badgeId)) {
        currentBadges.add(badgeId);
        await _firestore
            .collection('users')
            .doc(userId)
            .update({'badges': currentBadges});
        return true;
      }
      return false;
    } catch (e) {
      print('Error desbloqueando insignia: $e');
      return false;
    }
  }

  /// Verificar y desbloquear insignias
  Future<List<String>> checkAndUnlockBadges(
    String userId,
    int totalPoints,
    int recyclingCount,
  ) async {
    List<String> newlyUnlockedBadges = [];
    List<BadgeModel> badges = BadgeModel.getPredefinedBadges();

    for (BadgeModel badge in badges) {
      bool shouldUnlock = false;

      if (badge.pointsRequired > 0 && totalPoints >= badge.pointsRequired) {
        shouldUnlock = true;
      }

      if (badge.recyclingCountRequired > 0 &&
          recyclingCount >= badge.recyclingCountRequired) {
        shouldUnlock = true;
      }

      if (shouldUnlock) {
        bool unlocked = await unlockBadge(userId, badge.id);
        if (unlocked) {
          newlyUnlockedBadges.add(badge.name);
        }
      }
    }

    return newlyUnlockedBadges;
  }

  /// Obtener progreso de insignias
  Future<Map<String, dynamic>> getBadgeProgress(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(userId)
          .get();

      int totalPoints = doc['totalPoints'] ?? 0;
      List<String> unlockedBadges = List<String>.from(doc['badges'] ?? []);

      List<BadgeModel> badges = BadgeModel.getPredefinedBadges();
      List<Map<String, dynamic>> progress = [];

      for (BadgeModel badge in badges) {
        bool isUnlocked = unlockedBadges.contains(badge.id);
        double progressPercentage = 0;

        if (badge.pointsRequired > 0) {
          progressPercentage =
              (totalPoints / badge.pointsRequired).clamp(0.0, 1.0);
        }

        progress.add({
          'id': badge.id,
          'name': badge.name,
          'icon': badge.icon,
          'description': badge.description,
          'isUnlocked': isUnlocked,
          'progressPercentage': progressPercentage,
        });
      }

      return {
        'badges': progress,
        'totalPoints': totalPoints,
        'unlockedCount': unlockedBadges.length,
      };
    } catch (e) {
      print('Error obteniendo progreso: $e');
      return {};
    }
  }
}
