// lib/presentation/screens/game/game_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/game_model.dart';
import '../../../data/services/game_service.dart';
import '../../../data/services/sound_service.dart';
import '../../../data/services/auth_service.dart';
import '../../widgets/board_cell.dart';
import '../results/results_screen.dart';

class GameScreen extends StatefulWidget {
  final String gameId;
  final String currentUserId;

  const GameScreen({
    super.key,
    required this.gameId,
    required this.currentUserId,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final _gameService = GameService();
  final _authService = AuthService();
  final _sound       = SoundService.instance;

  GameModel? _game;
  String? _mySymbol;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _gameService.watchGame(widget.gameId).listen(_onGameUpdate);
  }

  void _onGameUpdate(GameModel? game) {
    if (game == null || !mounted) return;
    _mySymbol ??= game.playerXId == widget.currentUserId ? 'X' : 'O';
    setState(() => _game = game);

    if (game.isFinished && !_navigated) {
      _navigated = true;
      _playEndSound(game);
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResultsScreen(
              game: game,
              currentUserId: widget.currentUserId,
            ),
          ),
        );
      });
    }
  }

  void _playEndSound(GameModel game) {
    // Envolvemos en un try-catch interno por si el archivo sigue dando error de formato
    try {
      if (game.winnerSymbol == 'draw') {
        _sound.playDraw();
      } else if (game.winnerId == widget.currentUserId) {
        _sound.playWin();
      } else {
        _sound.playLose();
      }
    } catch (e) {
      debugPrint('Error al reproducir sonido final: $e');
    }
  }

  Future<void> _handleSignOut() async {
    await _authService.signOut();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    }
  }

  Future<void> _onCellTap(int index) async {
    if (_game == null || _mySymbol == null) return;
    if (_game!.currentTurn != _mySymbol) return;

    try {
      if (_mySymbol == 'X') {
        _sound.playPlaceX();
      } else {
        _sound.playPlaceO();
      }
    } catch (e) {
      debugPrint('Error de audio: $e');
    }

    await _gameService.makeMove(
      game:         _game!,
      cellIndex:    index,
      playerId:     widget.currentUserId,
      playerSymbol: _mySymbol!,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_game == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    final game         = _game!;
    final mySymbol     = _mySymbol ?? 'X';
    final isMyTurn     = game.currentTurn == mySymbol && game.isPlaying;
    final opponentName = mySymbol == 'X' ? game.playerOName : game.playerXName;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.textDim),
            onPressed: () => _showExitDialog(),
          ),
        ],
      ),
      // Agregamos SingleChildScrollView para evitar el error de RenderFlex overflow
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 10),
                _GameHeader(
                  mySymbol:     mySymbol,
                  opponentName: opponentName,
                  isMyTurn:     isMyTurn,
                  currentTurn:  game.currentTurn,
                ),

                const SizedBox(height: 40), // Espacio fijo en lugar de Spacer

                // El tablero
                AspectRatio(
                  aspectRatio: 1,
                  child: _Board(
                    board:       game.board,
                    winningLine: game.winningLine,
                    isMyTurn:     isMyTurn,
                    onCellTap:   _onCellTap,
                  ),
                ),

                const SizedBox(height: 40), // Espacio fijo en lugar de Spacer

                _TurnIndicator(isMyTurn: isMyTurn, mySymbol: mySymbol),
                
                const SizedBox(height: 30), // Espacio al final para que no pegue con el borde
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        title: Text('¿SALIR?', style: AppTextStyles.pixelSubtitle),
        content: Text('Se cerrará tu sesión actual.', style: AppTextStyles.pixelDim),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR', style: TextStyle(color: AppColors.textDim)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _handleSignOut();
            },
            child: const Text('CERRAR SESIÓN', style: TextStyle(color: AppColors.lose)),
          ),
        ],
      ),
    );
  }
}

// ── Subwidgets ──────────────────────────────────────────────────────────────

class _GameHeader extends StatelessWidget {
  final String mySymbol, opponentName, currentTurn;
  final bool isMyTurn;

  const _GameHeader({
    required this.mySymbol,
    required this.opponentName,
    required this.isMyTurn,
    required this.currentTurn,
  });

  @override
  Widget build(BuildContext context) {
    final playerStyle = mySymbol == 'X'
        ? AppTextStyles.playerX
        : AppTextStyles.playerO;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Tú
        Column(
          children: [
            Text('TÚ', style: AppTextStyles.pixelDim),
            Text(mySymbol, style: playerStyle),
          ],
        ),
        // VS
        Text('VS', style: AppTextStyles.pixelSubtitle),
        // Oponente
        Column(
          children: [
            Text(opponentName.toUpperCase(), style: AppTextStyles.pixelDim),
            Text(
              mySymbol == 'X' ? 'O' : 'X',
              style: mySymbol == 'X'
                  ? AppTextStyles.playerO
                  : AppTextStyles.playerX,
            ),
          ],
        ),
      ],
    );
  }
}

class _Board extends StatelessWidget {
  final List<String> board;
  final List<int> winningLine;
  final bool isMyTurn;
  final Future<void> Function(int) onCellTap;

  const _Board({
    required this.board,
    required this.winningLine,
    required this.isMyTurn,
    required this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: 9,
      itemBuilder: (_, i) => BoardCell(
        value:     board[i],
        isWinning: winningLine.contains(i),
        isEnabled: isMyTurn && board[i].isEmpty,
        onTap:     () => onCellTap(i),
      ),
    );
  }
}

class _TurnIndicator extends StatelessWidget {
  final bool isMyTurn;
  final String mySymbol;
  const _TurnIndicator({required this.isMyTurn, required this.mySymbol});

  @override
  Widget build(BuildContext context) {
    final color = isMyTurn ? AppColors.primary : AppColors.secondary;
    final label = isMyTurn ? '▶  TU TURNO' : '⏳ TURNO DEL OPONENTE';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1),
        boxShadow: [BoxShadow(color: color.withOpacity(0.25), blurRadius: 12)],
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 2,
          shadows: [Shadow(color: color, blurRadius: 8)],
        ),
      ),
    )
        .animate(onPlay: (c) => isMyTurn ? c.repeat() : null)
        .shimmer(duration: 1200.ms, color: color.withOpacity(0.6));
  }
}