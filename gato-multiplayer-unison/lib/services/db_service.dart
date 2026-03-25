import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/game_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _uuid = const Uuid();

  // Crear sala
  Future<String> createRoom(String userId, String username) async {
    String roomId = _uuid.v4().substring(0, 6).toUpperCase();
    
    await _firestore.collection('rooms').doc(roomId).set({
      'player1': userId,
      'player1Name': username,
      'player2': null,
      'player2Name': null,
      'board': List.filled(9, ''),
      'turn': 'player1',
      'status': 'waiting',
      'winner': null,
      'moves': [],
      'createdAt': FieldValue.serverTimestamp(),
    });

    return roomId;
  }

  // Unirse a sala
  Future<bool> joinRoom(String roomId, String userId, String username) async {
    DocumentSnapshot room = await _firestore.collection('rooms').doc(roomId).get();
    
    if (!room.exists) return false;
    if (room['player2'] != null) return false;
    if (room['player1'] == userId) return false;

    await _firestore.collection('rooms').doc(roomId).update({
      'player2': userId,
      'player2Name': username,
      'status': 'playing',
    });

    return true;
  }

  // Stream de la sala
  Stream<GameModel?> roomStream(String roomId) {
    return _firestore.collection('rooms').doc(roomId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return GameModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    });
  }

  // Hacer movimiento
  Future<void> makeMove({
    required String roomId,
    required int index,
    required String symbol,
    required String nextTurn,
    required String playerId,
  }) async {
    await _firestore.collection('rooms').doc(roomId).update({
      'board.$index': symbol,
      'turn': nextTurn,
      'moves': FieldValue.arrayUnion([
        {'playerId': playerId, 'cell': index, 'timestamp': FieldValue.serverTimestamp()}
      ]),
    });
  }

  // Terminar partida
  Future<void> finishGame(String roomId, String? winnerId) async {
    await _firestore.collection('rooms').doc(roomId).update({
      'status': 'finished',
      'winner': winnerId,
    });
  }

  // Obtener Top 10
  Stream<List<Map<String, dynamic>>> getTopPlayers() {
    return _firestore
        .collection('users')
        .orderBy('wins', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) {
              final data = doc.data();
              return {'id': doc.id, ...data}; 
               })
            .toList());
  }
}