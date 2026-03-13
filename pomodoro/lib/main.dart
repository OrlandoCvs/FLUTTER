import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

const Color kColorDark = Color(0xFF355872);
const Color kColorMedium = Color(0xFF7AAACE);
const Color kColorLight = Color(0xFF9CD5FF);
const Color kColorBg = Color(0xFFF7F8F0);
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PomodoroProvider(),
      child: const PomodoroApp(),
    ),
  );
}

class PomodoroProvider extends ChangeNotifier {
  int workMin = 25;
  int restMin = 5;
  int totalCycles = 4;
  int currentCycle = 1;
  int remainingSec = 0;
  bool isWorkMode = true;
  bool isRunning = false;
  Timer? _timer;
  int totalWorkSec = 0;
  int totalRestSec = 0;
  int messageIndex = 0;
  final List<String> motivations = [
    "¡Buen trabajo! Tómate un respiro.",
    "¡Excelente ritmo! Estira las piernas.",
    "¡Lo estás logrando! Hidrátate.",
    "¡Casi terminas! Disfruta tu pausa.",
  ];
  void startSession() {
    remainingSec = workMin * 60;
    isWorkMode = true;
    currentCycle = 1;
    totalWorkSec = 0;
    totalRestSec = 0;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel(); // 🔴 Cancela cualquier timer anterior

    isRunning = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSec > 0) {
        remainingSec--;

        if (isWorkMode) {
          totalWorkSec++;
        } else {
          totalRestSec++;

          // mensaje cada 10 segundos
          if (remainingSec % 10 == 0) {
            messageIndex = Random().nextInt(motivations.length);
          }
        }

        notifyListeners();
      } else {
        _handleTransition();
      }
    });
  }

  void _handleTransition() {
    _timer?.cancel();
    if (isWorkMode) {
      isWorkMode = false;
      remainingSec = restMin * 60;
      _startTimer();
    } else {
      if (currentCycle < totalCycles) {
        currentCycle++;
        isWorkMode = true;
        remainingSec = workMin * 60;
        _startTimer();
      } else {
        isRunning = false;
      }
    }
    notifyListeners();
  }

  void toggle() {
    if (isRunning) {
      _timer?.cancel();
      isRunning = false;
    } else {
      _startTimer();
    }
    notifyListeners();
  }

  void resetAll() {
    _timer?.cancel();
    isRunning = false;
    notifyListeners();
  }

  String get timeStr =>
      '${(remainingSec ~/ 60).toString().padLeft(2, '0')}:${(remainingSec % 60).toString().padLeft(2, '0')}';

  void setWorkMin(int value) {
    workMin = value;
    notifyListeners();
  }

  void setRestMin(int value) {
    restMin = value;
    notifyListeners();
  }

  void setTotalCycles(int value) {
    totalCycles = value;
    notifyListeners();
  }
}

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.patrickHandTextTheme(),
        scaffoldBackgroundColor: kColorBg,
      ),
      home: const StartScreen(),
    );
  }
}

class HandDrawnBorder extends CustomPainter {
  final Color color;
  HandDrawnBorder(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    final drawingPath = Path();
    drawingPath.moveTo(5.0, 2.0);
    drawingPath.quadraticBezierTo(
      size.width * 0.5,
      -5.0,
      size.width - 5.0,
      3.0,
    );
    drawingPath.quadraticBezierTo(
      size.width + 4.0,
      size.height * 0.5,
      size.width - 2.0,
      size.height - 4.0,
    );
    drawingPath.quadraticBezierTo(
      size.width * 0.5,
      size.height + 5.0,
      3.0,
      size.height - 2.0,
    );
    drawingPath.quadraticBezierTo(-3.0, size.height * 0.5, 5.0, 2.0);
    canvas.drawPath(drawingPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/logo_unison.png', height: 140),
              const SizedBox(height: 30),
              Text(
                "Pomo-UNISON",
                style: GoogleFonts.indieFlower(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: kColorDark,
                ),
              ),
              const SizedBox(height: 25),

              /// 👥 Integrantes
              const Text(
                "Integrantes:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Saul Filiberto Espinoza Rivera\n"
                "Lilian Yeitnaletzi Álvarez Portillo\n"
                "María Yamile Valencia Loroña\n"
                "Orlando Cervantes Sousa\n"
                "Hugo Alan Hinojoza Lopez\n"
                "Sebastián Molina Pérez",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 40),

              /// ▶ Botón
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const ConfigScreen()),
                  );
                },
                child: CustomPaint(
                  painter: HandDrawnBorder(kColorDark),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                    child: Text(
                      "INICIAR ESTUDIO",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final p = Provider.of<PomodoroProvider>(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const Icon(Icons.backpack, size: 60, color: kColorDark),
              Text(
                "Pomo-UNISON",
                style: GoogleFonts.indieFlower(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: kColorDark,
                ),
              ),
              const SizedBox(height: 25),
              CustomPaint(
                painter: HandDrawnBorder(kColorDark),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildSlider(
                        "Trabajo (min)",
                        p.workMin.toDouble(),
                        1,
                        60,
                        (v) => p.setWorkMin(v.toInt()),
                      ),

                      _buildSlider(
                        "Descanso (min)",
                        p.restMin.toDouble(),
                        1,
                        30,
                        (v) => p.setRestMin(v.toInt()),
                      ),

                      _buildSlider(
                        "Ciclos totales",
                        p.totalCycles.toDouble(),
                        1,
                        8,
                        (v) => p.setTotalCycles(v.toInt()),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              InkWell(
                onTap: () {
                  p.startSession();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TimerScreen()),
                  );
                },
                child: CustomPaint(
                  painter: HandDrawnBorder(kColorDark),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    child: Text(
                      "INICIAR",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Que sea un dia productivo, ¡tú puedes!",
                style: TextStyle(fontSize: 16, color: kColorDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlider(
    String label,
    double val,
    double min,
    double max,
    Function(double) onChanged,
  ) {
    return Column(
      children: [
        Text("$label: ${val.toInt()}", style: const TextStyle(fontSize: 18)),
        Slider(
          value: val,
          min: min,
          max: max,
          onChanged: onChanged,
          activeColor: kColorMedium,
          inactiveColor: kColorLight,
        ),
      ],
    );
  }
}

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final p = Provider.of<PomodoroProvider>(context);
    final themeColor = p.isWorkMode
        ? const Color.fromARGB(255, 93, 130, 158)
        : kColorMedium;
    if (!p.isRunning &&
        p.remainingSec == 0 &&
        p.currentCycle == p.totalCycles &&
        !p.isWorkMode) {
      Future.microtask(
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SummaryScreen()),
        ),
      );
    }
    return Scaffold(
      backgroundColor: p.isWorkMode
          ? kColorBg
          : const Color.fromARGB(255, 188, 227, 255).withOpacity(0.45),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              p.isWorkMode ? "¡Enfócate!" : "¡Descansa!",
              style: GoogleFonts.caveat(fontSize: 55, color: themeColor),
            ),
            if (!p.isWorkMode)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  p.motivations[p.messageIndex],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            const SizedBox(height: 40),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 270,
                  height: 270,
                  child: CircularProgressIndicator(
                    value: (p.isWorkMode ? p.workMin * 60 : p.restMin * 60) > 0
                        ? p.remainingSec /
                              (p.isWorkMode ? p.workMin * 60 : p.restMin * 60)
                        : 0,
                    strokeWidth: 12,
                    color: themeColor,
                    backgroundColor: kColorLight.withOpacity(0.2),
                  ),
                ),
                Text(
                  p.timeStr,
                  style: const TextStyle(
                    fontSize: 75,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Text(
              "Ciclo ${p.currentCycle} de ${p.totalCycles}",
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: PhosphorIcon(
                    p.isRunning
                        ? PhosphorIconsRegular.pause
                        : PhosphorIconsRegular.play,
                    size: 50,
                    color: themeColor,
                  ),
                  onPressed: p.toggle,
                ),
                const SizedBox(width: 40),
                IconButton(
                  icon: PhosphorIcon(
                    PhosphorIconsRegular.stop,
                    size: 50,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (c) => AlertDialog(
                        title: const Text("¿Abandonar sesión?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(c),
                            child: const Text("No"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(c);
                              Navigator.pop(context);
                            },
                            child: const Text("Sí"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final p = Provider.of<PomodoroProvider>(context, listen: false);
    String feedback = p.totalCycles <= 2
        ? "¡Buen inicio!"
        : p.totalCycles <= 5
        ? "¡Gran esfuerzo!"
        : "¡Maestro de la productividad!";
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "¡Sesión Finalizada!",
              style: GoogleFonts.indieFlower(
                fontSize: 40,
                color: kColorDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            CustomPaint(
              painter: HandDrawnBorder(kColorMedium),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    Text(
                      "Ciclos completados: ${p.totalCycles}",
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      "Tiempo Trabajo: ${p.totalWorkSec ~/ 60} min",
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      "Tiempo Descanso: ${p.totalRestSec ~/ 60} min",
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      feedback,
                      style: GoogleFonts.caveat(
                        fontSize: 32,
                        color: kColorDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kColorDark,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                p.resetAll();
                Navigator.pop(context);
              },
              child: const Text("NUEVA SESIÓN", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
