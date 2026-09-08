import 'package:audioplayers/audioplayers.dart';

import 'save_service.dart';

/// Centralized sound-effects player for gameplay audio (ball hits, brick
/// breaks). Uses a small rotating pool of players per effect so rapid,
/// overlapping hits (multi-ball, fast combos) never cut each other off.
///
/// Every call is defensive: if audio fails to initialize on a device
/// (missing codec, restricted permissions, etc.) the game keeps working
/// exactly as before — sound is a bonus layer, never a blocker.
class SoundService {
  SoundService._();

  static final SoundService instance = SoundService._();

  static const String _hitAsset = 'audio/hit.wav';
  static const String _breakAsset = 'audio/break.wav';
  static const int _poolSize = 4;

  SaveService? _save;
  bool _ready = false;

  final List<AudioPlayer> _hitPool = [];
  final List<AudioPlayer> _breakPool = [];
  int _hitIndex = 0;
  int _breakIndex = 0;

  bool get _enabled => _save?.soundEnabled ?? true;

  Future<void> init(SaveService save) async {
    _save = save;

    if (_ready) return;

    try {
      for (var i = 0; i < _poolSize; i++) {
        _hitPool.add(AudioPlayer(playerId: 'nb_hit_$i'));
        _breakPool.add(AudioPlayer(playerId: 'nb_break_$i'));
      }
      _ready = true;
    } catch (_) {
      // No audio on this device/build — game stays fully playable in silence.
      _ready = false;
    }
  }

  /// Ball bouncing off the paddle, walls, or a brick.
  void playHit() {
    if (!_ready || !_enabled) return;

    try {
      final player = _hitPool[_hitIndex];
      _hitIndex = (_hitIndex + 1) % _hitPool.length;

      player
          .play(AssetSource(_hitAsset), mode: PlayerMode.lowLatency, volume: .55)
          .catchError((_) {});
    } catch (_) {}
  }

  /// A brick getting fully destroyed.
  void playBreak() {
    if (!_ready || !_enabled) return;

    try {
      final player = _breakPool[_breakIndex];
      _breakIndex = (_breakIndex + 1) % _breakPool.length;

      player
          .play(AssetSource(_breakAsset), mode: PlayerMode.lowLatency, volume: .8)
          .catchError((_) {});
    } catch (_) {}
  }
}
