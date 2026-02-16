import 'package:flutter/material.dart';

void main() {
  runApp(const CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: const Calculadora(),
    );
  }
}

class Calculadora extends StatefulWidget {
  const Calculadora({Key? key}) : super(key: key);

  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  String _display = '0';
  String _operacion = '';
  double _primerNumero = 0;
  bool _nuevoNumero = true;

  void _presionarBoton(String valor) {
    setState(() {
      if (valor == 'C') {
        _display = '0';
        _operacion = '';
        _primerNumero = 0;
        _nuevoNumero = true;
      } else if (valor == '+' || valor == '-' || valor == '×' || valor == '÷') {
        _primerNumero = double.parse(_display);
        _operacion = valor;
        _nuevoNumero = true;
      } else if (valor == '=') {
        double segundoNumero = double.parse(_display);
        double resultado = 0;

        switch (_operacion) {
          case '+':
            resultado = _primerNumero + segundoNumero;
            break;
          case '-':
            resultado = _primerNumero - segundoNumero;
            break;
          case '×':
            resultado = _primerNumero * segundoNumero;
            break;
          case '÷':
            resultado = segundoNumero != 0 ? _primerNumero / segundoNumero : 0;
            break;
        }

        _display = resultado.toString();
        if (_display.endsWith('.0')) {
          _display = _display.substring(0, _display.length - 2);
        }
        _operacion = '';
        _nuevoNumero = true;
      } else if (valor == '⌫') {
        if (_display.length > 1) {
          _display = _display.substring(0, _display.length - 1);
        } else {
          _display = '0';
        }
      } else {
        // Números y punto decimal
        if (_nuevoNumero) {
          _display = valor;
          _nuevoNumero = false;
        } else {
          if (valor == '.' && _display.contains('.')) {
            return;
          }
          _display += valor;
        }
      }
    });
  }

  Widget _crearBoton(String texto, {Color? color, Color? textColor}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[800],
            foregroundColor: textColor ?? Colors.white,
            padding: const EdgeInsets.all(24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => _presionarBoton(texto),
          child: Text(
            texto,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Calculadora'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Display
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: Text(
                _display,
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 1,
              ),
            ),
          ),
          // Botones
          Expanded(
            flex: 5,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _crearBoton('C', color: Colors.red[700]),
                      _crearBoton('⌫', color: Colors.orange[700]),
                      _crearBoton('÷', color: Colors.blue[700]),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      _crearBoton('7'),
                      _crearBoton('8'),
                      _crearBoton('9'),
                      _crearBoton('×', color: Colors.blue[700]),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      _crearBoton('4'),
                      _crearBoton('5'),
                      _crearBoton('6'),
                      _crearBoton('-', color: Colors.blue[700]),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      _crearBoton('1'),
                      _crearBoton('2'),
                      _crearBoton('3'),
                      _crearBoton('+', color: Colors.blue[700]),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      _crearBoton('0'),
                      _crearBoton('.'),
                      _crearBoton('=', color: Colors.green[700]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}