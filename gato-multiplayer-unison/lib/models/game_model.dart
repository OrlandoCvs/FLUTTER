class GameModel {
  final String roomId;
  final String player1Id;
  final String player1Name;
  final String? player2Id;
  final String? player2Name;
  final List<String> board;
  final String turn;
  final String status;
  final String? winner;
  final List<Map<String, dynamic>> moves;

  GameModel({
    required this.roomId,
    required this.player1Id,
    required this.player1Name,
    this.player2Id,
    this.player2Name,
    required this.board,
    required this.turn,
    required this.status,
    this.winner,
    this.moves = const [],
  });

  factory GameModel.fromMap(Map<String, dynamic> map, String roomId) {
    return GameModel(
      roomId: roomId,
      player1Id: map['player1'] ?? '',
      player1Name: map['player1Name'] ?? '',
      player2Id: map['player2'],
      player2Name: map['player2Name'],
      board: List<String>.from(map['board'] ?? List.filled(9, '')),
      turn: map['turn'] ?? 'player1',
      status: map['status'] ?? 'waiting',
      winner: map['winner'],
      moves: List<Map<String, dynamic>>.from(map['moves'] ?? []),
    );
  }

  String get mySymbol {
    // Se determina en el provider según si soy player1 o player2
    return '';
  }
}