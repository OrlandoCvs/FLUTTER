import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_compass/flutter_compass.dart';

class CompassView extends StatefulWidget {
  const CompassView({super.key});

  @override
  State<CompassView> createState() => _CompassViewState();
}

class _CompassViewState extends State<CompassView> {
  double? _heading = 0.0;
  bool _isDarkMode = true;

  @override
  void initState() {
    super.initState();
    // Solo escuchamos el sensor para actualizar la interfaz visual
    FlutterCompass.events?.listen((CompassEvent event) {
      if (mounted) {
        setState(() {
          _heading = event.heading;
        });
      }
    });
  }

  // --- CONFIGURACIÓN DE COLORES ---
  List<Color> get _backgroundGradient {
    return _isDarkMode
        ? [const Color(0xFF000000), const Color(0xFF1A1A1A), const Color(0xFF2C2C2C)]
        : [const Color(0xFFFFFFFF), const Color(0xFFF5F5F5), const Color(0xFFE0E0E0)];
  }

  Color get _primaryColor => _isDarkMode ? Colors.white : Colors.black;
  Color get _secondaryColor => _isDarkMode ? Colors.white54 : Colors.black87;
  Color get _logoColor => _isDarkMode ? Colors.white : Colors.black;

  @override
  Widget build(BuildContext context) {
    // Normalizamos el valor para que siempre sea entre 0 y 360 en la UI
    double direction = (_heading ?? 0 % 360 + 360) % 360;

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _backgroundGradient,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: _primaryColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        'Brújula Unison',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _primaryColor,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isDarkMode ? Icons.wb_sunny : Icons.dark_mode,
                        color: _isDarkMode ? Colors.yellow : Colors.indigo,
                      ),
                      onPressed: () => setState(() => _isDarkMode = !_isDarkMode),
                    ),
                  ],
                ),
              ),

              // Brújula
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedRotation(
                        turns: (direction * -1) / 360,
                        duration: const Duration(milliseconds: 250),
                        child: _buildCompass(direction),
                      ),
                      Image.asset(
                        'assets/logo_unison.png',
                        width: 180,
                        height: 180,
                        color: _logoColor,
                        colorBlendMode: BlendMode.modulate,
                      ),
                    ],
                  ),
                ),
              ),

              _buildInfoPanel(direction),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompass(double currentHeading) {
    return SizedBox(
      width: 350,
      height: 350,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ..._buildDegreeLabels(currentHeading),
          ..._buildTicks(),
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 21),
              child: Icon(Icons.arrow_drop_up, color: Colors.red, size: 30),
            ),
          ),
          ..._buildCardinalPoints(currentHeading),
        ],
      ),
    );
  }

  List<Widget> _buildTicks() {
    List<Widget> ticks = [];
    const int totalTicks = 72;
    const double angleStep = (2 * math.pi) / totalTicks;

    for (int i = 0; i < totalTicks; i++) {
      final bool isMajorCardinal = i % 9 == 0;
      final double tickHeight = isMajorCardinal ? 20.0 : 10.0;
      final double tickWidth = isMajorCardinal ? 3.0 : 1.5;
      final Color tickColor = isMajorCardinal ? _primaryColor : _secondaryColor;

      ticks.add(
        Transform.rotate(
          angle: i * angleStep,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 25),
              height: tickHeight,
              width: tickWidth,
              color: tickColor,
            ),
          ),
        ),
      );
    }
    return ticks;
  }

  List<Widget> _buildDegreeLabels(double currentHeading) {
    List<Widget> labels = [];
    for (int i = 0; i < 360; i += 30) {
      double labelAngle = i * (math.pi / 180);
      labels.add(
        Transform.rotate(
          angle: labelAngle,
          child: Align(
            alignment: Alignment.topCenter,
            child: Transform.rotate(
              angle: -labelAngle + (currentHeading * math.pi / 180),
              child: Text(
                i.toString(),
                style: TextStyle(
                  color: _secondaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return labels;
  }

  List<Widget> _buildCardinalPoints(double currentHeading) {
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    const angles = [0.0, 45.0, 90.0, 135.0, 180.0, 225.0, 270.0, 315.0];

    return List.generate(directions.length, (index) {
      double cardinalAngle = angles[index] * math.pi / 180;
      return Transform.rotate(
        angle: cardinalAngle,
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 55),
            child: Transform.rotate(
              angle: -cardinalAngle + (currentHeading * math.pi / 180),
              child: Text(
                directions[index],
                style: TextStyle(
                  fontSize: directions[index].length > 1 ? 18 : 24,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildInfoPanel(double direction) {
    String getCardinal(double angle) {
      if (angle >= 337.5 || angle < 22.5) return 'Norte';
      if (angle >= 22.5 && angle < 67.5) return 'Noreste';
      if (angle >= 67.5 && angle < 112.5) return 'Este';
      if (angle >= 112.5 && angle < 157.5) return 'Sureste';
      if (angle >= 157.5 && angle < 202.5) return 'Sur';
      if (angle >= 202.5 && angle < 247.5) return 'Suroeste';
      if (angle >= 247.5 && angle < 292.5) return 'Oeste';
      if (angle >= 292.5 && angle < 337.5) return 'Noroeste';
      return 'Norte';
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isDarkMode 
            ? Colors.white.withValues(alpha: 0.1) 
            : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _primaryColor.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildDataRow('Dirección', getCardinal(direction), Icons.explore),
          const SizedBox(height: 10),
          _buildDataRow('Grados', '${direction.toStringAsFixed(1)}°', Icons.explore_outlined),
          const SizedBox(height: 10),
          _buildDataRow('Lugar', 'Hermosillo, Sonora', Icons.location_on),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1976D2), size: 24),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label, 
                style: TextStyle(
                  fontSize: 12, 
                  color: _isDarkMode ? Colors.white70 : Colors.black,
                  fontWeight: _isDarkMode ? FontWeight.normal : FontWeight.bold,
                )
              ),
              Text(
                value, 
                style: TextStyle(
                  fontSize: 17, 
                  fontWeight: FontWeight.bold, 
                  color: _primaryColor
                )
              ),
            ],
          ),
        ),
      ],
    );
  }
}