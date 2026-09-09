import 'package:audioplayers/audioplayers.dart';

class SoundService {
  SoundService._();

  static final SoundService instance = SoundService._();

  final AudioPlayer _paddlePlayer = AudioPlayer();
  final AudioPlayer _brickPlayer = AudioPlayer();

  bool soundEnabled = true;

  void setEnabled(bool enabled) {
    soundEnabled = enabled;

    if (!enabled) {
      _paddlePlayer.stop();
      _brickPlayer.stop();
    }
  }

  Future<void> playBrick() async {
    if (!soundEnabled) return;

    try {
      await _brickPlayer.stop();
      await _brickPlayer.play(AssetSource('audio/brik.mp3'));
    } catch (_) {}
  }

  Future<void> playPaddle() async {
    if (!soundEnabled) return;

    try {
      await _paddlePlayer.stop();
      await _paddlePlayer.play(AssetSource('audio/ping.wav'));
    } catch (_) {}
  }

  Future<void> dispose() async {
    await _paddlePlayer.dispose();
    await _brickPlayer.dispose();
  }
}
