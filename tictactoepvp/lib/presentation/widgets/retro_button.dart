import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/services/sound_service.dart';

/// Botón estilo pixel/retro con efecto de presión
class RetroButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? color;
  final double fontSize;
  final bool isOutlined;

  const RetroButton({
    super.key,
    required this.label,
    this.onPressed,
    this.color,
    this.fontSize = 14,
    this.isOutlined = false,
  });

  @override
  State<RetroButton> createState() => _RetroButtonState();
}

class _RetroButtonState extends State<RetroButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.94).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _ctrl.forward();
  void _onTapUp(_) {
    _ctrl.reverse();
    SoundService.instance.playClick();
    widget.onPressed?.call();
  }
  void _onTapCancel() => _ctrl.reverse();

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.primary;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: widget.isOutlined ? Colors.transparent : color.withOpacity(0.15),
            border: Border.all(color: color, width: 2),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.35),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: widget.fontSize,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 2,
              shadows: [Shadow(color: color, blurRadius: 6)],
            ),
          ),
        ),
      ),
    );
  }
}