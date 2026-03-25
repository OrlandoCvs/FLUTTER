import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../models/game_model.dart';
import '../providers/game_provider.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';
import '../widgets/custom_button.dart';
import 'lobby_view.dart';
import 'login_view.dart';

class ResultView extends StatelessWidget {
  final GameModel game;
  final String mySymbol;

  const ResultView({super.key, required this.game, required this.mySymbol});

  @override
  Widget build(BuildContext context) {
    bool isWin = game.winner != null && 
        ((mySymbol == 'X' && game.winner == 'player1') ||
         (mySymbol == 'O' && game.winner == 'player2'));
    bool isDraw = game.winner == null;

    String resultText = isWin ? ' ¡Ganaste!' : (isDraw ? ' Empate' : ' Perdiste');
    Color resultColor = isWin ? AppColors.success : (isDraw ? AppColors.textLight : AppColors.error);

    // Guardar estadísticas
    AuthService().updateStats(
      Provider.of<AuthProvider>(context, listen: false).user!.uid,
      isWin,
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: resultColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      resultText,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: resultColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${game.player1Name} vs ${game.player2Name}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              CustomButton(
                text: 'Volver a Jugar',
                onPressed: () {
                  Provider.of<GameProvider>(context, listen: false).resetGame();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LobbyView()),
                  );
                },
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: ' Cerrar Sesión',
                color: AppColors.error,
                onPressed: () async {
                  await Provider.of<AuthProvider>(context, listen: false).signOut();
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginView()),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}