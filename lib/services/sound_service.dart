import 'package:audioplayers/audioplayers.dart';

class SoundService {
  SoundService._();

  static final SoundService instance = SoundService._();

  final AudioPlayer _paddlePlayer = AudioPlayer();

  bool soundEnabled = true;

  void setEnabled(bool enabled) {
    soundEnabled = enabled;

    if (!enabled) {
      _paddlePlayer.stop();
    }
  }

  Future<void> playBrick() async {
    if (!soundEnabled) return;

    try {
      // Use a fresh player so rapid brick hits do not cut each other off.
      final player = AudioPlayer();

      await player.play(AssetSource('audio/brik.mp3'));

      player.onPlayerComplete.listen((_) async {
        await player.dispose();
      });
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
  }
}
