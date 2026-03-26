import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/game_model.dart';
import '../../../data/services/auth_service.dart';
import '../../widgets/retro_button.dart';
import '../lobby/lobby_screen.dart';
import '../auth/auth_screen.dart'; // Importamos para la navegación directa

class ResultsScreen extends StatelessWidget {
  final GameModel game;
  final String currentUserId;

  const ResultsScreen({
    super.key,
    required this.game,
    required this.currentUserId,
  });

  bool get _iWon  => game.winnerId == currentUserId;
  bool get _isDraw => game.winnerSymbol == 'draw';

  Color get _resultColor {
    if (_isDraw) return AppColors.draw;
    if (_iWon)   return AppColors.win;
    return AppColors.lose;
  }

  String get _resultLabel {
    if (_isDraw) return 'EMPATE';
    if (_iWon)   return '¡VICTORIA!';
    return 'DERROTA';
  }

  String get _resultEmoji {
    if (_isDraw) return '🤝';
    if (_iWon)   return '🏆';
    return '💀';
  }

  // ── Lógica de Cierre de Sesión ─────────────────────────────────────────────
  Future<void> _handleSignOut(BuildContext context) async {
    final authService = AuthService();
    
    // 1. Cerramos sesión en Firebase
    await authService.signOut();

    // 2. Limpiamos TODA la pila de navegación y mandamos al Login
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AuthScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _resultColor;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Resultado principal
              Text(_resultEmoji, style: const TextStyle(fontSize: 80))
                  .animate()
                  .scale(duration: 600.ms, curve: Curves.elasticOut)
                  .fadeIn(),

              const SizedBox(height: 24),

              Text(
                _resultLabel,
                style: AppTextStyles.pixelTitle.copyWith(
                  color: color,
                  fontSize: 42,
                  shadows: [Shadow(color: color, blurRadius: 24)],
                ),
              )
                  .animate()
                  .fadeIn(delay: 300.ms)
                  .slideY(begin: 0.3),

              const SizedBox(height: 40),

              // Resumen
              _SummaryCard(game: game),

              const SizedBox(height: 48),

              // Botones de acción
              RetroButton(
                label: '▶   VOLVER A JUGAR',
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LobbyScreen()),
                  (_) => false,
                ),
                color: AppColors.primary,
                fontSize: 15,
              ),

              const SizedBox(height: 16),

              // Botón de Cerrar sesión corregido
              RetroButton(
                label: 'CERRAR SESIÓN',
                onPressed: () => _handleSignOut(context), // Nueva función segura
                color: AppColors.textDim,
                isOutlined: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final GameModel game;
  const _SummaryCard({required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border, width: 1),
        color: AppColors.surfaceLight,
      ),
      child: Column(
        children: [
          Text('RESUMEN', style: AppTextStyles.pixelSubtitle),
          const SizedBox(height: 16),
          _Row(label: 'JUGADOR X', value: game.playerXName),
          _Row(label: 'JUGADOR O', value: game.playerOName),
          const Divider(color: AppColors.border, height: 24),
          _Row(
            label: 'GANADOR',
            value: game.winnerSymbol == 'draw'
                ? 'EMPATE'
                : (game.winnerId == game.playerXId
                    ? game.playerXName
                    : game.playerOName),
          ),
          _Row(label: 'MOVIMIENTOS', value: '${game.moves.length}'),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2);
  }
}

class _Row extends StatelessWidget {
  final String label, value;
  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.pixelDim),
          Text(value.toUpperCase(), style: AppTextStyles.pixelBody),
        ],
      ),
    );
  }
}