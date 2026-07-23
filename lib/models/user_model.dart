import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de Usuario
class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? phone;
  final String community;
  final String userLevel; // Semilla, Árbol, Bosque
  final int totalPoints;
  final int totalRecycled;
  final List<String> badges;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? profileImageUrl;
  final String language;
  final bool darkMode;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.phone,
    required this.community,
    this.userLevel = 'Semilla',
    this.totalPoints = 0,
    this.totalRecycled = 0,
    this.badges = const [],
    required this.createdAt,
    required this.updatedAt,
    this.profileImageUrl,
    this.language = 'es',
    this.darkMode = false,
  });

  /// Convertir a JSON para Firestore
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'community': community,
      'userLevel': userLevel,
      'totalPoints': totalPoints,
      'totalRecycled': totalRecycled,
      'badges': badges,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'profileImageUrl': profileImageUrl,
      'language': language,
      'darkMode': darkMode,
    };
  }

  /// Crear desde JSON de Firestore
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      community: json['community'] ?? '',
      userLevel: json['userLevel'] ?? 'Semilla',
      totalPoints: json['totalPoints'] ?? 0,
      totalRecycled: json['totalRecycled'] ?? 0,
      badges: List<String>.from(json['badges'] ?? []),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      profileImageUrl: json['profileImageUrl'],
      language: json['language'] ?? 'es',
      darkMode: json['darkMode'] ?? false,
    );
  }

  /// Crear copia con cambios
  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? community,
    String? userLevel,
    int? totalPoints,
    int? totalRecycled,
    List<String>? badges,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? profileImageUrl,
    String? language,
    bool? darkMode,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      community: community ?? this.community,
      userLevel: userLevel ?? this.userLevel,
      totalPoints: totalPoints ?? this.totalPoints,
      totalRecycled: totalRecycled ?? this.totalRecycled,
      badges: badges ?? this.badges,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      language: language ?? this.language,
      darkMode: darkMode ?? this.darkMode,
    );
  }
}
