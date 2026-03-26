import 'dart:math';

/// Genera códigos de sala únicos de 6 caracteres alfanuméricos en mayúsculas
class RoomCodeGenerator {
  RoomCodeGenerator._();

  static const String _chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  static final Random _rng = Random.secure();

  static String generate() {
    return List.generate(6, (_) => _chars[_rng.nextInt(_chars.length)]).join();
  }
}