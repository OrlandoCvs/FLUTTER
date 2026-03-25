import 'package:flutter/material.dart';
import '../config/theme.dart';

class GameCell extends StatelessWidget {
  final String value;
  final VoidCallback? onTap;
  final bool isEnabled;

  const GameCell({
    super.key,
    required this.value,
    this.onTap,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: AnimatedScale(
            scale: value.isEmpty ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.bounceOut,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: value == 'X' 
                    ? AppColors.primary 
                    : AppColors.secondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}