import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

/// Maneja el registro, inicio y cierre de sesión con Firebase Auth
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ── Registro ──────────────────────────────────────────────────────────────

  /// Registra un nuevo usuario con email, password y username
  Future<UserModel> register({
    required String email,
    required String password,
    required String username,
  }) async {
    // 1. Crear cuenta en Firebase Auth primero
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // 2. Ya autenticado, guardar perfil en Firestore
    final user = UserModel(
      uid: credential.user!.uid,
      username: username,
      email: email,
    );

    await _db
        .collection('users')
        .doc(user.uid)
        .set(user.toMap());

    return user;
  }

  // ── Inicio de sesión ──────────────────────────────────────────────────────

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final doc = await _db
        .collection('users')
        .doc(credential.user!.uid)
        .get();

    return UserModel.fromMap(doc.data()!, doc.id);
  }

  // ── Cierre de sesión ──────────────────────────────────────────────────────

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ── Obtener perfil ────────────────────────────────────────────────────────

  Future<UserModel?> getUserProfile(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (!doc.exists) return null;
      return UserModel.fromMap(doc.data()!, doc.id);
    } catch (e) {
      return null;
    }
  }
}