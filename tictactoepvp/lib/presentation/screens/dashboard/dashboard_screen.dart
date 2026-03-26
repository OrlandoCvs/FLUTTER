import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/game_service.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameService = GameService();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: BackButton(color: AppColors.primary),
        title: Text('RANKING', style: AppTextStyles.pixelSubtitle),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: gameService.watchLeaderboard(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final players = snapshot.data ?? [];

          if (players.isEmpty) {
            return Center(
              child: Text(
                'SIN DATOS AÚN',
                style: AppTextStyles.pixelDim,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: players.length,
            itemBuilder: (context, i) {
              return _LeaderboardRow(
                position: i + 1,
                user: players[i],
              ).animate().fadeIn(delay: (i * 80).ms).slideX(begin: 0.2);
            },
          );
        },
      ),
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  final int position;
  final UserModel user;
  const _LeaderboardRow({required this.position, required this.user});

  Color get _positionColor {
    if (position == 1) return AppColors.accent;           // Oro
    if (position == 2) return const Color(0xFFC0C0C0);   // Plata
    if (position == 3) return const Color(0xFFCD7F32);   // Bronce
    return AppColors.textDim;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(
          color: position <= 3 ? _positionColor.withOpacity(0.5) : AppColors.border,
        ),
        color: position <= 3
            ? _positionColor.withOpacity(0.05)
            : AppColors.surfaceLight,
        boxShadow: position <= 3
            ? [BoxShadow(color: _positionColor.withOpacity(0.15), blurRadius: 10)]
            : null,
      ),
      child: Row(
        children: [
          // Posición
          SizedBox(
            width: 36,
            child: Text(
              '#$position',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _positionColor,
              ),
            ),
          ),
          // Nombre
          Expanded(
            child: Text(
              user.username.toUpperCase(),
              style: AppTextStyles.pixelBody,
            ),
          ),
          // Victorias
          _StatChip(label: 'W', value: user.wins,       color: AppColors.win),
          const SizedBox(width: 8),
          _StatChip(label: 'G', value: user.totalGames, color: AppColors.info),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _StatChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.5)),
        color: color.withOpacity(0.08),
      ),
      child: Text(
        '$label:$value',
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}