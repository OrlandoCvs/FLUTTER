import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Maneja todos los efectos de sonido de la aplicación
class SoundService {
  SoundService._();
  static final SoundService instance = SoundService._();

  final AudioPlayer _player = AudioPlayer();

  Future<void> playPlaceX() => _play('place_x.mp3');
  Future<void> playPlaceO() => _play('place_o.mp3');
  Future<void> playWin()    => _play('win.mp3');
  Future<void> playLose()   => _play('lose.mp3');
  Future<void> playDraw()   => _play('draw.mp3');
  Future<void> playClick()  => _play('click.mp3');

  Future<void> _play(String fileName) async {
    try {
      await _player.stop();
      await _player.play(AssetSource('sounds/$fileName'));
    } catch (e) {
      debugPrint('SoundService: no se pudo reproducir $fileName — $e');
    }
  }

  Future<void> dispose() => _player.dispose();
}