import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// Clase de configuración centralizada de Firebase
class FirebaseConfig {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final FirebaseStorage storage = FirebaseStorage.instance;

  /// Verificar si el usuario está autenticado
  static User? get currentUser => auth.currentUser;

  /// Verificar si hay sesión activa
  static bool get isUserLoggedIn => auth.currentUser != null;

  /// Obtener el ID del usuario actual
  static String? get currentUserId => auth.currentUser?.uid;

  /// Cerrar sesión
  static Future<void> logout() async {
    await auth.signOut();
  }
}
