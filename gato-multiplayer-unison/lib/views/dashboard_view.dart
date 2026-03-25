import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../services/db_service.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Top 10 Jugadores'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: DatabaseService().getTopPlayers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final players = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: index < 3 ? AppColors.accent : AppColors.primary,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    player['username'] ?? 'Sin nombre',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${player['games'] ?? 0} partidas jugadas'),
                  trailing: Text(
                    ' ${player['wins'] ?? 0}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}