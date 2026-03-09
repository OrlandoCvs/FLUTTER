import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(const LaTriviaApp());

// --- COLORES ---
class TriviaPalette {
  static const Color cream = Color(0xFFFFF7CD);
  static const Color peach = Color(0xFFFDC3A1);
  static const Color coral = Color(0xFFFB9B8F);
  static const Color pink = Color(0xFFF57799);
  
  static const Color correct = Color(0xFF81C784);
  static const Color incorrect = Color(0xFFE57373);
  static const Color text = Color(0xFF5D4037);
}

class LaTriviaApp extends StatelessWidget {
  const LaTriviaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Desafío Búho Unison',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: TriviaPalette.pink),
        scaffoldBackgroundColor: TriviaPalette.cream,
      ),
      home: const InicioView(),
    );
  }
}

// --- LÓGICA ---
class Question {
  final String text;
  final List<String> options;
  final String correct;
  final String topic;

  Question({required this.text, required this.options, required this.correct, required this.topic});
}

class TriviaController {
  final List<Question> _repo = [
    Question(text: "¿Cuál es el país más grande del mundo?", options: ["Rusia", "Canadá", "China", "EE.UU."], correct: "Rusia", topic: "Geografía"),
    Question(text: "¿Cuál es el río más largo del mundo?", options: ["Río Amazonas", "Río Nilo", "Río Yangtsé", "Río Misisipi"], correct: "Río Amazonas", topic: "Geografía"),
    Question(text: "¿En qué continente está Egipto?", options: ["África", "Asia", "Europa", "América"], correct: "África", topic: "Geografía"),
    Question(text: "¿Cuál es la capital de Canadá?", options: ["Ottawa", "Toronto", "Vancouver", "Montreal"], correct: "Ottawa", topic: "Geografía"),
    Question(text: "¿Cuál es el océano más grande?", options: ["Pacífico", "Atlántico", "Índico", "Ártico"], correct: "Pacífico", topic: "Geografía"),
    Question(text: "¿Año en que Colón llegó a América?", options: ["1492", "1498", "1500", "1488"], correct: "1492", topic: "Historia"),
    Question(text: "¿Primer presidente de EE.UU.?", options: ["Washington", "Lincoln", "Jefferson", "Adams"], correct: "Washington", topic: "Historia"),
    Question(text: "¿Año que terminó la 2da Guerra Mundial?", options: ["1945", "1918", "1939", "1950"], correct: "1945", topic: "Historia"),
    Question(text: "¿Civilización que hizo Machu Picchu?", options: ["Incas", "Mayas", "Aztecas", "Egipcios"], correct: "Incas", topic: "Historia"),
    Question(text: "¿Muro que cayó en 1989?", options: ["Berlín", "China", "Adriano", "Lamentaciones"], correct: "Berlín", topic: "Historia"),
    Question(text: "¿Planeta más grande?", options: ["Júpiter", "Saturno", "Marte", "Tierra"], correct: "Júpiter", topic: "Ciencia"),
    Question(text: "¿Gas esencial que respiramos?", options: ["Oxígeno", "Nitrógeno", "CO2", "Hidrógeno"], correct: "Oxígeno", topic: "Ciencia"),
    Question(text: "¿Creador de la relatividad?", options: ["Einstein", "Newton", "Tesla", "Hawking"], correct: "Einstein", topic: "Ciencia"),
    Question(text: "¿Símbolo químico del Oxígeno?", options: ["O", "Ox", "Os", "H"], correct: "O", topic: "Química"),
    Question(text: "¿Huesos en el cuerpo adulto?", options: ["206", "105", "300", "250"], correct: "206", topic: "Anatomía"),
    Question(text: "¿Quién pintó la Mona Lisa?", options: ["Da Vinci", "Picasso", "Van Gogh", "Miguel Ángel"], correct: "Da Vinci", topic: "Arte"),
    Question(text: "¿Autor de Don Quijote?", options: ["Cervantes", "Shakespeare", "Dante", "G. Márquez"], correct: "Cervantes", topic: "Literatura"),
    Question(text: "¿Idioma más hablado (nativo)?", options: ["Mandarín", "Inglés", "Español", "Hindi"], correct: "Mandarín", topic: "Cultura"),
    Question(text: "¿Saga de J.K. Rowling?", options: ["Harry Potter", "ESDLA", "Narnia", "Percy Jackson"], correct: "Harry Potter", topic: "Literatura"),
    Question(text: "¿Qué tocaba Beethoven?", options: ["Piano", "Violín", "Flauta", "Guitarra"], correct: "Piano", topic: "Música"),
    Question(text: "¿Animal terrestre más rápido?", options: ["Guepardo", "León", "Caballo", "Halcón"], correct: "Guepardo", topic: "Zoología"),
    Question(text: "¿Lados de un hexágono?", options: ["6", "5", "8", "4"], correct: "6", topic: "Matemáticas"),
    Question(text: "¿Metal más ligero?", options: ["Litio", "Hierro", "Oro", "Aluminio"], correct: "Litio", topic: "Química"),
    Question(text: "¿País de la Torre Eiffel?", options: ["Francia", "Italia", "España", "Alemania"], correct: "Francia", topic: "Geografía"),
    Question(text: "¿Idioma oficial de Brasil?", options: ["Portugués", "Español", "Francés", "Inglés"], correct: "Portugués", topic: "Cultura"),
    Question(text: "¿Cuántos continentes hay?", options: ["7", "5", "6", "4"], correct: "7", topic: "Geografía"),
    Question(text: "¿El rey de la selva?", options: ["León", "Tigre", "Elefante", "Gorila"], correct: "León", topic: "Zoología"),
    Question(text: "¿El planeta rojo?", options: ["Marte", "Venus", "Mercurio", "Saturno"], correct: "Marte", topic: "Astronomía"),
    Question(text: "¿Minutos en una hora?", options: ["60", "30", "100", "12"], correct: "60", topic: "Matemáticas"),
    Question(text: "¿Órgano que bombea sangre?", options: ["Corazón", "Cerebro", "Pulmones", "Hígado"], correct: "Corazón", topic: "Anatomía"),
  ];

// -- Método para obtener un set de 10 preguntas aleatorias con opciones mezcladas
  List<Question> fetchGameSet() {
    return (_repo..shuffle()).take(10).toList().map((q) {
      q.options.shuffle();
      return q;
    }).toList();
  }
}

// --- VISTAS ---

class InicioView extends StatelessWidget {
  const InicioView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [TriviaPalette.pink, TriviaPalette.coral], begin: Alignment.topCenter),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(tag: 'logo', child: Image.asset('images/logo_unison.png', height: 150, errorBuilder: (c, e, s) => const Icon(Icons.school, size: 100, color: Colors.white70))),
            const SizedBox(height: 20),
            const Text('LA TRIVIA', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 30),
            const Text('EQUIPO:', style: TextStyle(color: TriviaPalette.cream, fontWeight: FontWeight.bold)),
            ...['Saul Filiberto Espinoza Rivera', 'Lilian Yeitnaletzi Álvarez portillo', 'María Yamile Valencia Loroña', 'Orlando Cervantes Sousa', 'Hugo Alan Hinojoza Lopez', 'Sebastián Molina Pérez']
                .map((n) => Text(n, style: const TextStyle(color: Colors.white, fontSize: 16))),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const DificultadView())),
              style: ElevatedButton.styleFrom(backgroundColor: TriviaPalette.cream, foregroundColor: TriviaPalette.pink, padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15)),
              child: const Text('INICIAR', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class DificultadView extends StatelessWidget {
  const DificultadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dificultad'), backgroundColor: TriviaPalette.peach),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _btn(context, 'Fácil (10s)', Colors.green.shade300, 10),
            const SizedBox(height: 20),
            _btn(context, 'Intermedio (5s)', Colors.orange.shade300, 5),
            const SizedBox(height: 20),
            _btn(context, 'Difícil (3s)', Colors.red.shade300, 3),
          ],
        ),
      ),
    );
  }

  Widget _btn(BuildContext context, String t, Color c, int s) => SizedBox(
    width: 250, height: 60,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: c, foregroundColor: Colors.white),
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => JuegoView(seconds: s))),
      child: Text(t, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    ),
  );
}

class JuegoView extends StatefulWidget {
  final int seconds;
  const JuegoView({super.key, required this.seconds});

  @override
  State<JuegoView> createState() => _JuegoViewState();
}

class _JuegoViewState extends State<JuegoView> with SingleTickerProviderStateMixin {
  late List<Question> gameQuestions;
  int currentIdx = 0;
  int score = 0;
  bool isAnswered = false;
  String? selected;
  List<String> toStudy = [];
  
  late AnimationController _timerController;

  @override
  void initState() {
    super.initState();
    gameQuestions = TriviaController().fetchGameSet();
    _timerController = AnimationController(vsync: this, duration: Duration(seconds: widget.seconds))
      ..addStatusListener((status) { if (status == AnimationStatus.completed) _checkAnswer(null); });
    _timerController.forward();
  }
  // Método para verificar respuesta, actualizar estado y avanzar a la siguiente pregunta o resultado
  void _checkAnswer(String? opt) {
    if (isAnswered) return;
    _timerController.stop();
    setState(() {
      isAnswered = true;
      selected = opt;
      if (opt == gameQuestions[currentIdx].correct) score++;
      else toStudy.add(gameQuestions[currentIdx].topic);
    });
    // Avanzar a la siguiente pregunta o resultado después de una breve pausa para mostrar feedback
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        if (currentIdx < 9) {
          setState(() {
            currentIdx++; isAnswered = false; selected = null;
            _timerController.reset(); _timerController.forward();
          });
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (c) => ResultadoView(
              score: score, 
              topics: toStudy, 
              difficultySeconds: widget.seconds
            )
          ));
        }
      }
    });
  }

  @override
  void dispose() { _timerController.dispose(); super.dispose(); }
  
  @override
  Widget build(BuildContext context) {
    final q = gameQuestions[currentIdx];
    return Scaffold(
      appBar: AppBar(title: Text('Q${currentIdx + 1}/10 | Puntos: $score'), backgroundColor: TriviaPalette.peach, automaticallyImplyLeading: false),
      body: Column(
        children: [
          AnimatedBuilder(
            animation: _timerController,
            builder: (c, child) => LinearProgressIndicator(
              value: 1 - _timerController.value,
              minHeight: 12,
              color: _timerController.value > 0.7 ? Colors.red : TriviaPalette.pink,
              backgroundColor: TriviaPalette.peach.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Padding(
                key: ValueKey<int>(currentIdx),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(q.text, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: TriviaPalette.text), textAlign: TextAlign.center),
                    const SizedBox(height: 30),
                    ...q.options.map((opt) {
                      Color color = Colors.white;
                      if (isAnswered) {
                        if (opt == q.correct) color = TriviaPalette.correct;
                        else if (opt == selected) color = TriviaPalette.incorrect;
                      }
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)]),
                          child: InkWell(
                            onTap: () => _checkAnswer(opt),
                            borderRadius: BorderRadius.circular(15),
                            child: Padding(
                              padding: const EdgeInsets.all(18),
                              child: Center(child: Text(opt, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: color == Colors.white ? TriviaPalette.text : Colors.white))),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// Vista de resultado que muestra el puntaje, un mensaje personalizado y los temas a reforzar
class ResultadoView extends StatelessWidget {
  final int score;
  final List<String> topics;
  final int difficultySeconds;

  const ResultadoView({
    super.key, 
    required this.score, 
    required this.topics, 
    required this.difficultySeconds
  });
  // Método para obtener un mensaje personalizado basado en el puntaje y la dificultad
  String _getPersonalizedMessage() {
    // Caso especial: Dificultad Difícil (3 segundos) y 10 buenas el super easter egg
    if (difficultySeconds == 3 && score == 10) {
      return "Eres una bestia de la cultura general, pero... ¿Qué tal vas en la carrera...?";
    }

    // Mensajes generales para todas las dificultades
    if (score <= 3) return "Estas en el hoyo";
    if (score <= 5) return "Peor es nada... ¿no?";
    if (score <= 7) return "vas por buen camino, pero pudo salir mejor";
    if (score <= 9) return "Eres bueno, pero no tanto";
    return "Intenta el modo Dificil";
  }
  // Método para construir la vista de resultado con puntaje, mensaje personalizado y temas a reforzar
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TriviaPalette.cream,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.stars, size: 100, color: TriviaPalette.pink),
              Text('$score / 10', style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: TriviaPalette.pink)),
              const SizedBox(height: 10),
              // Mensaje Personalizado
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  _getPersonalizedMessage(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: TriviaPalette.text, fontStyle: FontStyle.italic),
                ),
              ),
              const SizedBox(height: 30),
              if (topics.isNotEmpty) ...[
                const Text('REFORZAR TEMAS:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Wrap(spacing: 8, children: topics.toSet().map((t) => Chip(label: Text(t), backgroundColor: TriviaPalette.peach)).toList()),
              ],
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                style: ElevatedButton.styleFrom(backgroundColor: TriviaPalette.pink, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                child: const Text('REINICIAR JUEGO'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}