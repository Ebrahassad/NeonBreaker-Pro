import 'package:shared_preferences/shared_preferences.dart';

class SaveService {
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  int get highScore => _prefs.getInt('high_score') ?? 0;

  int get bestLevel => _prefs.getInt('best_level') ?? 1;

  int get nextLevel => bestLevel;

  // ----------------------------------------------------------
  // EXTRA LIVES
  // ----------------------------------------------------------

  int get extraLives => _prefs.getInt('extra_lives') ?? 0;

  Future<void> addExtraLives(int amount) async {
    if (amount <= 0) return;
    await _prefs.setInt('extra_lives', extraLives + amount);
  }

  Future<void> setExtraLives(int value) async {
    await _prefs.setInt('extra_lives', value < 0 ? 0 : value);
  }

  bool get soundEnabled => _prefs.getBool('sound') ?? true;

  bool get vibrationEnabled => _prefs.getBool('vibration') ?? true;

  // ----------------------------------------------------------
  // BACKGROUND THEME
  // ----------------------------------------------------------

  int get backgroundTheme => _prefs.getInt('background_theme') ?? 0;

  Future<void> setBackgroundTheme(int value) async {
    await _prefs.setInt('background_theme', value);
  }

  int bestScoreForLevel(int level) {
    return _prefs.getInt('level_score_$level') ?? 0;
  }

  // ----------------------------------------------------------
  // BEST COMBO
  // ----------------------------------------------------------

  int bestComboForLevel(int level) {
    return _prefs.getInt('level_combo_$level') ?? 0;
  }

  Future<void> saveLevelCombo(int level, int combo) async {
    final safeCombo = combo < 0 ? 0 : combo;
    final old = bestComboForLevel(level);

    if (safeCombo > old) {
      await _prefs.setInt('level_combo_$level', safeCombo);
    }
  }

  Future<void> saveScore(int value) async {
    if (value > highScore) {
      await _prefs.setInt('high_score', value);
    }
  }

  Future<void> saveLevel(int value) async {
    if (value > bestLevel) {
      await _prefs.setInt('best_level', value);
    }
  }

  Future<void> saveLevelScore(int level, int score) async {
    final old = bestScoreForLevel(level);

    if (score > old) {
      await _prefs.setInt('level_score_$level', score);
    }

    await saveScore(score);
  }

  // ----------------------------------------------------------
  // STARS
  // ----------------------------------------------------------

  int starsForLevel(int level) {
    return _prefs.getInt('level_stars_$level') ?? 0;
  }

  Future<void> saveLevelStars(int level, int stars) async {
    final safeStars = stars.clamp(0, 3);
    final old = starsForLevel(level);

    if (safeStars > old) {
      await _prefs.setInt('level_stars_$level', safeStars);
    }
  }

  int get totalStars {
    var total = 0;

    for (var level = 1; level <= bestLevel; level++) {
      total += starsForLevel(level);
    }

    return total;
  }

  // ----------------------------------------------------------
  // SETTINGS
  // ----------------------------------------------------------

  Future<void> setSound(bool value) async {
    await _prefs.setBool('sound', value);
  }

  Future<void> setVibration(bool value) async {
    await _prefs.setBool('vibration', value);
  }

  // ----------------------------------------------------------
  // RESET
  // ----------------------------------------------------------

  Future<void> reset() async {
    await _prefs.clear();
  }
}
