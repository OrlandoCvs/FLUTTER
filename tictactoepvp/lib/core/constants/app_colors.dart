import 'package:flutter/material.dart';

/// Paleta de colores retro inspirada en terminales de los 80s
class AppColors {
  AppColors._();

  // Fondo oscuro tipo CRT
  static const Color background   = Color(0xFF0D0D0D);
  static const Color surface      = Color(0xFF1A1A2E);
  static const Color surfaceLight = Color(0xFF16213E);

  // Verde fosforescente — jugador X
  static const Color primary      = Color(0xFF39FF14);
  // Magenta retro — jugador O
  static const Color secondary    = Color(0xFFFF2079);
  // Amarillo ámbar — detalles
  static const Color accent       = Color(0xFFFFD700);
  // Cyan retro — info
  static const Color info         = Color(0xFF00F5FF);

  // Texto
  static const Color textPrimary  = Color(0xFFE8E8E8);
  static const Color textDim      = Color(0xFF888888);

  // Estados
  static const Color win          = Color(0xFF39FF14);
  static const Color lose         = Color(0xFFFF2079);
  static const Color draw         = Color(0xFFFFD700);

  // Bordes tipo pixel
  static const Color border       = Color(0xFF333366);
  static const Color borderGlow   = Color(0xFF39FF14);
}