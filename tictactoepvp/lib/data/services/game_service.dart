import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/game_model.dart';
import '../models/move_model.dart';
import '../models/user_model.dart';
import '../../core/utils/room_code_generator.dart';

/// Maneja toda la lógica de partidas: crear, unirse, jugar y registrar resultados
class GameService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Crear sala ────────────────────────────────────────────────────────────

  Future<GameModel> createGame(UserModel host) async {
    final code = RoomCodeGenerator.generate();
    final ref  = _db.collection('games').doc();

    final game = GameModel(
      gameId: ref.id,
      roomCode: code,
      playerXId: host.uid,
      playerXName: host.username,
      board: List.filled(9, ''),
      createdAt: DateTime.now(),
    );

    await ref.set(game.toMap());
    return game;
  }

  // ── Unirse a sala ─────────────────────────────────────────────────────────

  Future<GameModel?> joinGame(String roomCode, UserModel joiner) async {
    final query = await _db
        .collection('games')
        .where('roomCode', isEqualTo: roomCode.toUpperCase())
        .where('status', isEqualTo: 'waiting')
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;

    final doc  = query.docs.first;
    final game = GameModel.fromMap(doc.data(), doc.id);

    // No se puede unir a su propia sala
    if (game.playerXId == joiner.uid) {
      throw Exception('No puedes unirte a tu propia sala.');
    }

    // Actualizar sala con el segundo jugador
    await doc.reference.update({
      'playerOId':   joiner.uid,
      'playerOName': joiner.username,
      'status':      'playing',
    });

    return game;
  }

  // ── Escuchar partida en tiempo real ───────────────────────────────────────

  Stream<GameModel?> watchGame(String gameId) {
    return _db
        .collection('games')
        .doc(gameId)
        .snapshots()
        .map((snap) {
          if (!snap.exists) return null;
          return GameModel.fromMap(snap.data()!, snap.id);
        });
  }

  // ── Realizar movimiento ───────────────────────────────────────────────────

  Future<void> makeMove({
    required GameModel game,
    required int cellIndex,
    required String playerId,
    required String playerSymbol,
  }) async {
    if (game.board[cellIndex].isNotEmpty) return;
    if (game.currentTurn != playerSymbol)  return;
    if (!game.isPlaying)                   return;

    final newBoard   = List<String>.from(game.board);
    newBoard[cellIndex] = playerSymbol;

    final moveNumber = game.moves.length + 1;
    final newMove    = MoveModel(
      playerId:     playerId,
      playerSymbol: playerSymbol,
      row:          cellIndex ~/ 3,
      col:          cellIndex % 3,
      moveNumber:   moveNumber,
    );

    final newMoves = [...game.moves.map((m) => m.toMap()), newMove.toMap()];

    // Evaluar resultado
    final winLine   = _checkWinner(newBoard);
    final isDraw    = winLine == null && !newBoard.contains('');
    final isWin     = winLine != null;

    String newStatus      = 'playing';
    String winnerId       = '';
    String winnerSymbol   = '';
    List<int> winningLine = [];

    if (isWin) {
      newStatus    = 'finished';
      winnerId     = playerId;
      winnerSymbol = playerSymbol;
      winningLine  = winLine;
    } else if (isDraw) {
      newStatus    = 'finished';
      winnerSymbol = 'draw';
    }

    await _db.collection('games').doc(game.gameId).update({
      'board':       newBoard,
      'currentTurn': playerSymbol == 'X' ? 'O' : 'X',
      'status':      newStatus,
      'winnerId':    winnerId,
      'winnerSymbol': winnerSymbol,
      'winningLine': winningLine,
      'moves':       newMoves,
    });

    // Si terminó, actualizar estadísticas de los jugadores
    if (newStatus == 'finished') {
      await _updateStats(game, winnerId, winnerSymbol);
    }
  }

  // ── Actualizar estadísticas ───────────────────────────────────────────────

  Future<void> _updateStats(
      GameModel game, String winnerId, String winnerSymbol) async {
    final batch = _db.batch();
    final xRef  = _db.collection('users').doc(game.playerXId);
    final oRef  = _db.collection('users').doc(game.playerOId);

    if (winnerSymbol == 'draw') {
      batch.update(xRef, {
        'draws':      FieldValue.increment(1),
        'totalGames': FieldValue.increment(1),
      });
      batch.update(oRef, {
        'draws':      FieldValue.increment(1),
        'totalGames': FieldValue.increment(1),
      });
    } else {
      final loserId = winnerId == game.playerXId
          ? game.playerOId
          : game.playerXId;
      final winnerRef = _db.collection('users').doc(winnerId);
      final loserRef  = _db.collection('users').doc(loserId);

      batch.update(winnerRef, {
        'wins':       FieldValue.increment(1),
        'totalGames': FieldValue.increment(1),
      });
      batch.update(loserRef, {
        'losses':     FieldValue.increment(1),
        'totalGames': FieldValue.increment(1),
      });
    }

    await batch.commit();
  }

  // ── Top 10 jugadores ──────────────────────────────────────────────────────

  Stream<List<UserModel>> watchLeaderboard() {
    return _db
        .collection('users')
        .orderBy('wins', descending: true)
        .limit(10)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => UserModel.fromMap(d.data(), d.id))
            .toList());
  }

  // ── Lógica de victoria ────────────────────────────────────────────────────

  /// Retorna los índices de la línea ganadora o null si no hay ganador
  List<int>? _checkWinner(List<String> board) {
    const lines = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // filas
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // columnas
      [0, 4, 8], [2, 4, 6],             // diagonales
    ];

    for (final line in lines) {
      final a = board[line[0]];
      if (a.isNotEmpty && a == board[line[1]] && a == board[line[2]]) {
        return line;
      }
    }
    return null;
  }
}