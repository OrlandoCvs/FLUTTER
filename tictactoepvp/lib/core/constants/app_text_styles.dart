import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle pixelTitle = TextStyle(
    fontFamily: 'monospace',
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    letterSpacing: 6,
    shadows: [
      Shadow(color: AppColors.primary, blurRadius: 12),
      Shadow(color: AppColors.primary, blurRadius: 24),
    ],
  );

  static const TextStyle pixelSubtitle = TextStyle(
    fontFamily: 'monospace',
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.accent,
    letterSpacing: 3,
  );

  static const TextStyle pixelBody = TextStyle(
    fontFamily: 'monospace',
    fontSize: 14,
    color: AppColors.textPrimary,
    letterSpacing: 1,
  );

  static const TextStyle pixelDim = TextStyle(
    fontFamily: 'monospace',
    fontSize: 12,
    color: AppColors.textDim,
    letterSpacing: 1,
  );

  static const TextStyle playerX = TextStyle(
    fontFamily: 'monospace',
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    shadows: [Shadow(color: AppColors.primary, blurRadius: 16)],
  );

  static const TextStyle playerO = TextStyle(
    fontFamily: 'monospace',
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.secondary,
    shadows: [Shadow(color: AppColors.secondary, blurRadius: 16)],
  );
}