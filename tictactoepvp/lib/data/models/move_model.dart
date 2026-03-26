/// Representa un movimiento individual dentro de una partida
class MoveModel {
  final String playerId;   // UID del jugador
  final String playerSymbol; // "X" o "O"
  final int row;           // 0-2
  final int col;           // 0-2
  final int moveNumber;    // orden del movimiento (1, 2, 3...)

  const MoveModel({
    required this.playerId,
    required this.playerSymbol,
    required this.row,
    required this.col,
    required this.moveNumber,
  });

  factory MoveModel.fromMap(Map<String, dynamic> map) {
    return MoveModel(
      playerId: map['playerId'] as String,
      playerSymbol: map['playerSymbol'] as String,
      row: map['row'] as int,
      col: map['col'] as int,
      moveNumber: map['moveNumber'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'playerId': playerId,
      'playerSymbol': playerSymbol,
      'row': row,
      'col': col,
      'moveNumber': moveNumber,
    };
  }
}