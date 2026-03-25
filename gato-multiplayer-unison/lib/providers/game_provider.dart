import 'package:flutter/foundation.dart';
import '../models/game_model.dart';
import '../services/db_service.dart';
import '../services/auth_service.dart';

class GameProvider extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  final AuthService _authService = AuthService();
  
  GameModel? _game;
  String? _roomId;
  bool _isLoading = false;

  GameModel? get game => _game;
  String? get roomId => _roomId;
  bool get isLoading => _isLoading;

  String get mySymbol {
    if (_game == null) return '';
    return _authService.currentUserId == _game!.player1Id ? 'X' : 'O';
  }

  bool get isMyTurn {
    if (_game == null) return false;
    String myPlayerKey = _authService.currentUserId == _game!.player1Id 
        ? 'player1' 
        : 'player2';
    return _game!.turn == myPlayerKey;
  }

  Future<String> createRoom() async {
    _isLoading = true;
    notifyListeners();

    _roomId = await _dbService.createRoom(
      _authService.currentUserId!,
      _authService.currentUser!.displayName ?? 'Jugador',
    );

    _isLoading = false;
    notifyListeners();
    return _roomId!;
  }

  Future<bool> joinRoom(String roomId) async {
    _isLoading = true;
    notifyListeners();

    bool success = await _dbService.joinRoom(
      roomId,
      _authService.currentUserId!,
      _authService.currentUser!.displayName ?? 'Jugador',
    );

    if (success) {
      _roomId = roomId;
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  void listenToRoom(String roomId) {
    _roomId = roomId;
    _dbService.roomStream(roomId).listen((game) {
      _game = game;
      notifyListeners();
    });
  }

  Future<void> makeMove(int index) async {
    if (_game == null || _roomId == null) return;
    if (!isMyTurn) return;
    if (_game!.board[index].isNotEmpty) return;

    String nextTurn = _game!.turn == 'player1' ? 'player2' : 'player1';
    
    await _dbService.makeMove(
      roomId: _roomId!,
      index: index,
      symbol: mySymbol,
      nextTurn: nextTurn,
      playerId: _authService.currentUserId!,
    );
  }

  Future<void> finishGame() async {
    if (_roomId == null) return;
    
    String? winnerId;
    if (_game != null) {
      winnerId = _game!.winner;
    }
    
    await _dbService.finishGame(_roomId!, winnerId);
  }

  void resetGame() {
    _game = null;
    _roomId = null;
    notifyListeners();
  }
}