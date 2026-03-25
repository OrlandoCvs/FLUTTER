import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/auth_provider.dart';
import '../providers/game_provider.dart';
import '../widgets/custom_button.dart';
import 'game_view.dart';
import 'dashboard_view.dart';
import 'login_view.dart';

class LobbyView extends StatefulWidget {
  const LobbyView({super.key});

  @override
  State<LobbyView> createState() => _LobbyViewState();
}

class _LobbyViewState extends State<LobbyView> {
  final _roomCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Sala de Espera'),
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DashboardView()),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              '¡Hola, ${auth.user?.username ?? "Jugador"}!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 40),
            Consumer<GameProvider>(
              builder: (context, game, _) => CustomButton(
                text: 'Crear Partida',
                isLoading: game.isLoading,
                onPressed: () async {
                  String roomId = await game.createRoom();
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Sala Creada'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Comparte este código:'),
                            const SizedBox(height: 8),
                            Text(
                              roomId,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                    game.listenToRoom(roomId);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GameView()),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _roomCodeController,
              textAlign: TextAlign.center,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'Código de sala',
                prefixIcon: Icon(Icons.gamepad),
              ),
            ),
            const SizedBox(height: 16),
            Consumer<GameProvider>(
              builder: (context, game, _) => CustomButton(
                text: ' Unirse a Partida',
                isLoading: game.isLoading,
                onPressed: () async {
                  bool success = await game.joinRoom(_roomCodeController.text);
                  if (success && context.mounted) {
                    game.listenToRoom(_roomCodeController.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GameView()),
                    );
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sala no encontrada o llena')),
                    );
                  }
                },
              ),
            ),
            const Spacer(),
            CustomButton(
              text: ' Cerrar Sesión',
              color: AppColors.error,
              onPressed: () async {
                await auth.signOut();
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
    );
  }
}