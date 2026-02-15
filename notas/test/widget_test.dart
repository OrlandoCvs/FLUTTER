import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notas/main.dart';

void main() {
  testWidgets('Prueba de inicio de la aplicación de notas', (WidgetTester tester) async {
    // 1. Carga la aplicación usando el nombre correcto de la clase: NotasApp
    await tester.pumpWidget(const NotasApp());

    // 2. Verifica que aparezca el texto del nombre de la app o del autor
    // (Asegúrate de que coincida con lo que pusiste en tu VistaInicio)
    expect(find.textContaining('UNISON'), findsOneWidget);

    // 3. Verifica que el botón para navegar a la siguiente vista esté presente
    expect(find.text('Iniciar'), findsOneWidget);

    // 4. Simula presionar el botón "Iniciar"
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle(); // Espera a que termine la animación de navegación

    // 5. Verifica que después de presionar, estemos en la vista de Notas
    expect(find.text('Mis Notas'), findsOneWidget);
  });
}