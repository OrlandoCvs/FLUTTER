import 'move_model.dart';

/// Estado completo de una partida almacenado en Firestore -> colección "games"
class GameModel {
  final String gameId;
  final String roomCode;
  final String playerXId;
  final String playerXName;
  final String playerOId;
  final String playerOName;
  final List<String> board;      // 9 posiciones: '', 'X', 'O'
  final String currentTurn;      // 'X' o 'O'
  final String status;           // 'waiting', 'playing', 'finished'
  final String winnerId;         // UID del ganador o '' si empate
  final String winnerSymbol;     // 'X', 'O' o 'draw'
  final List<int> winningLine;   // índices de las celdas ganadoras [0-8]
  final List<MoveModel> moves;   // historial completo de movimientos
  final DateTime createdAt;

  const GameModel({
    required this.gameId,
    required this.roomCode,
    required this.playerXId,
    required this.playerXName,
    this.playerOId = '',
    this.playerOName = '',
    required this.board,
    this.currentTurn = 'X',
    this.status = 'waiting',
    this.winnerId = '',
    this.winnerSymbol = '',
    this.winningLine = const [],
    this.moves = const [],
    required this.createdAt,
  });

  bool get isFull => !board.contains('');
  bool get isWaiting => status == 'waiting';
  bool get isPlaying => status == 'playing';
  bool get isFinished => status == 'finished';

  factory GameModel.fromMap(Map<String, dynamic> map, String gameId) {
    final rawMoves = map['moves'] as List<dynamic>? ?? [];
    return GameModel(
      gameId: gameId,
      roomCode: map['roomCode'] as String? ?? '',
      playerXId: map['playerXId'] as String? ?? '',
      playerXName: map['playerXName'] as String? ?? '',
      playerOId: map['playerOId'] as String? ?? '',
      playerOName: map['playerOName'] as String? ?? '',
      board: List<String>.from(map['board'] as List? ?? List.filled(9, '')),
      currentTurn: map['currentTurn'] as String? ?? 'X',
      status: map['status'] as String? ?? 'waiting',
      winnerId: map['winnerId'] as String? ?? '',
      winnerSymbol: map['winnerSymbol'] as String? ?? '',
      winningLine: List<int>.from(map['winningLine'] as List? ?? []),
      moves: rawMoves
          .map((m) => MoveModel.fromMap(m as Map<String, dynamic>))
          .toList(),
      createdAt: (map['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'roomCode': roomCode,
      'playerXId': playerXId,
      'playerXName': playerXName,
      'playerOId': playerOId,
      'playerOName': playerOName,
      'board': board,
      'currentTurn': currentTurn,
      'status': status,
      'winnerId': winnerId,
      'winnerSymbol': winnerSymbol,
      'winningLine': winningLine,
      'moves': moves.map((m) => m.toMap()).toList(),
      'createdAt': createdAt,
    };
  }
}