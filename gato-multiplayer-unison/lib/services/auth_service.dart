import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  String? get currentUserId => _auth.currentUser?.uid;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserModel?> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel user = UserModel(
        uid: credential.user!.uid,
        username: username,
        email: email,
      );

      await _firestore.collection('users').doc(user.uid).set(user.toMap());

      return user;
    } catch (e) {
      debugPrint('Error en registro: $e');
      return null;
    }
  }

  Future<UserModel?> signIn({
  required String email,
  required String password,
}) async {
  try {
    debugPrint(' [LOGIN] Iniciando sesión con: $email');
    
    // 1. Autenticar
    UserCredential credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    debugPrint('[AUTH] UID: ${credential.user!.uid}');
    
    // 2. Buscar en Firestore
    String uid = credential.user!.uid;
    DocumentSnapshot doc = await _firestore
        .collection('users')
        .doc(uid)
        .get();

    debugPrint('[FIRESTORE] Documento existe: ${doc.exists}');

    if (doc.exists) {
      debugPrint('[FIRESTORE] Usuario encontrado');
      return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    } else {
      debugPrint(' [FIRESTORE] Documento NO existe - Creándolo...');
      
      // Crear el documento si no existe
      UserModel newUser = UserModel(
        uid: uid,
        username: credential.user!.displayName ?? 'Usuario',
        email: email,
        wins: 0,
        games: 0,
      );
      
      await _firestore.collection('users').doc(uid).set(newUser.toMap());
      debugPrint(' [FIRESTORE] Usuario creado');
      return newUser;
    }
  } on FirebaseAuthException catch (e) {
    debugPrint(' [FIREBASE ERROR] ${e.code}: ${e.message}');
    return null;
  } on FirebaseException catch (e) {
    debugPrint(' [FIRESTORE ERROR] ${e.code}: ${e.message}');
    return null;
  } catch (e) {
    debugPrint('[ERROR] $e');
    return null;
  }
}

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> updateStats(String userId, bool won) async {
    await _firestore.collection('users').doc(userId).update({
      'games': FieldValue.increment(1),
      'wins': won ? FieldValue.increment(1) : 0,
    });
  }
}