import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_hogar/models/user_model.dart';
import 'package:eco_hogar/config/firebase_config.dart';

/// Servicio de Autenticación
class AuthService {
  final FirebaseAuth _auth = FirebaseConfig.auth;
  final FirebaseFirestore _firestore = FirebaseConfig.firestore;

  /// Stream de cambios en el usuario autenticado
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Usuario actual
  User? get currentUser => _auth.currentUser;

  /// Registro de nuevo usuario
  Future<UserModel?> register({
    required String email,
    required String password,
    required String name,
    required String community,
    String? phone,
  }) async {
    try {
      // Crear cuenta en Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? firebaseUser = userCredential.user;
      if (firebaseUser == null) throw Exception('Error creando usuario');

      // Crear documento en Firestore
      UserModel newUser = UserModel(
        uid: firebaseUser.uid,
        name: name,
        email: email,
        phone: phone,
        community: community,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(firebaseUser.uid).set(
        newUser.toJson(),
      );

      return newUser;
    } on FirebaseAuthException catch (e) {
      print('Error en registro: ${e.message}');
      rethrow;
    }
  }

  /// Login de usuario
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? firebaseUser = userCredential.user;
      if (firebaseUser == null) throw Exception('Error iniciando sesión');

      // Obtener datos del usuario desde Firestore
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      print('Error en login: ${e.message}');
      rethrow;
    }
  }

  /// Obtener usuario actual desde Firestore
  Future<UserModel?> getCurrentUser() async {
    try {
      User? firebaseUser = currentUser;
      if (firebaseUser == null) return null;

      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error obteniendo usuario: $e');
      return null;
    }
  }

  /// Cerrar sesión
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error cerrando sesión: $e');
      rethrow;
    }
  }

  /// Recuperar contraseña
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Error enviando reset: $e');
      rethrow;
    }
  }

  /// Actualizar perfil de usuario
  Future<void> updateUserProfile(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).update(
        user.copyWith(updatedAt: DateTime.now()).toJson(),
      );
    } catch (e) {
      print('Error actualizando perfil: $e');
      rethrow;
    }
  }
}
