import 'package:audioplayers/audioplayers.dart';

class SoundService {
  SoundService._();

  static final SoundService instance = SoundService._();

  final AudioPlayer _brickPlayer = AudioPlayer();
  final AudioPlayer _paddlePlayer = AudioPlayer();

  bool soundEnabled = true;

  void setEnabled(bool enabled) {
    soundEnabled = enabled;

    if (!enabled) {
      _brickPlayer.stop();
      _paddlePlayer.stop();
    }
  }

  Future<void> playBrick() async {
    if (!soundEnabled) return;
    try {
      await _brickPlayer.stop();
      await _brickPlayer.play(
        AssetSource('audio/brik.mp3'),
      );
    } catch (_) {}
  }

  Future<void> playPaddle() async {
    if (!soundEnabled) return;
    try {
      await _paddlePlayer.stop();
      await _paddlePlayer.play(
        AssetSource('audio/ping.wav'),
      );
    } catch (_) {}
  }

  Future<void> dispose() async {
    await _brickPlayer.dispose();
    await _paddlePlayer.dispose();
  }
}
