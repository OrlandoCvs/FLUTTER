import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';

/// Celda individual del tablero 3x3 con animaciones retro
class BoardCell extends StatelessWidget {
  final String value;       // '', 'X', 'O'
  final bool isWinning;
  final bool isEnabled;
  final VoidCallback? onTap;

  const BoardCell({
    super.key,
    required this.value,
    this.isWinning = false,
    this.isEnabled = false,
    this.onTap,
  });

  Color get _symbolColor {
    if (value == 'X') return AppColors.primary;
    if (value == 'O') return AppColors.secondary;
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled && value.isEmpty ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isWinning
              ? _symbolColor.withOpacity(0.12)
              : AppColors.surface,
          border: Border.all(
            color: isWinning ? _symbolColor : AppColors.border,
            width: isWinning ? 2 : 1,
          ),
          boxShadow: isWinning
              ? [BoxShadow(color: _symbolColor, blurRadius: 18, spreadRadius: 2)]
              : null,
        ),
        child: Center(
          child: value.isEmpty
              ? _HoverIndicator(isEnabled: isEnabled)
              : _SymbolWidget(symbol: value, color: _symbolColor),
        ),
      ),
    );
  }
}

// Símbolo X u O con animación de entrada
class _SymbolWidget extends StatelessWidget {
  final String symbol;
  final Color color;
  const _SymbolWidget({required this.symbol, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      symbol,
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: color,
        shadows: [Shadow(color: color, blurRadius: 20)],
      ),
    )
        .animate()
        .scale(
          duration: 250.ms,
          curve: Curves.elasticOut,
          begin: const Offset(0.3, 0.3),
        )
        .fadeIn(duration: 150.ms);
  }
}

// Indicador sutil cuando la celda está disponible
class _HoverIndicator extends StatelessWidget {
  final bool isEnabled;
  const _HoverIndicator({required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    if (!isEnabled) return const SizedBox.shrink();
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.textDim.withOpacity(0.3),
      ),
    );
  }
}