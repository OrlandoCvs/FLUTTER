import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'vistas/home_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Forzar orientación vertical
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const BrujulaApp());
}

class BrujulaApp extends StatelessWidget {
  const BrujulaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brújula Unison',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
        fontFamily: 'Arial',
      ),
      home: const HomeView(),
    );
  }
}