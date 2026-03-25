import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/game_provider.dart';
import '../widgets/game_cell.dart';
import 'result_view.dart';

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Juego del Gato'),
        centerTitle: true,
      ),
      body: Consumer<GameProvider>(
        builder: (context, game, _) {
          if (game.game == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final gameState = game.game!;
          final isFinished = gameState.status == 'finished';

          if (isFinished) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ResultView(game: gameState, mySymbol: game.mySymbol),
                ),
              );
            });
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Info del juego
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Text('Tú', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                  game.mySymbol.isEmpty ? '-' : game.mySymbol,
                                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Text('Oponente', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                  game.mySymbol.isEmpty ? '-' : (game.mySymbol == 'X' ? 'O' : 'X'),
                                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: game.isMyTurn ? AppColors.success : AppColors.textLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            game.isMyTurn ? ' Tu turno' : ' Turno del oponente',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Tablero 3x3
                AspectRatio(
                  aspectRatio: 1,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      return GameCell(
                        value: gameState.board[index],
                        isEnabled: game.isMyTurn && gameState.board[index].isEmpty && !isFinished,
                        onTap: () => game.makeMove(index),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}