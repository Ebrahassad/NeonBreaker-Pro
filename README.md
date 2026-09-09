# NeonBreaker Pro

Professional neon brick breaker game built with Flutter.

## Features

- Neon UI with a real branded app icon on the home screen
- Brick breaker gameplay across 50 procedurally-built levels
- 6 stage themes (Classic, Neon, Cyber, Reactor, Void, Galaxy) with unique
  patterns, stage challenges and stage mechanics
- Progressive difficulty with a gentle per-level ball speed ramp
- Power-ups: multi-ball, fireball, wide paddle, shield, laser, double paddle
- Lives, score, combo tracking, star rating per level
- Best score, best level, stars and per-level score persistence
- Settings (sound / vibration toggles, progress reset)
- Touch controls with smoothed paddle movement
- Particle-style neon effects (sparks, glow, trails)
- GitHub Actions Android release build

## Monetization

Unity Ads (LevelPlay) is integrated as an isolated service
(`lib/services/ad_service.dart`):

- **Banner** ads on the Home and Levels screens
- **Interstitial** ads at natural break points (returning home, finishing a
  level, retrying), throttled so they never interrupt play too often
- **Rewarded video** ads offering an optional extra life on Game Over and a
  double score bonus on Level Clear

Ad loading/showing is fully defensive — if the SDK can't initialize or an ad
fails to load, the game keeps working exactly as before with no ads shown.

Placement configuration lives at the top of `AdService`:
Game ID `800363462`, placements `Banner_Android`, `Interstitial_Android`,
`Rewarded_Android`. `AdService.testMode` follows debug/release builds
automatically — flip it manually if you need to force test ads.

## Build

GitHub Actions builds the release APK automatically on every push to `main`.

## Package name

The app ships under `com.neonbreaker.pro` (the previous `com.example.*`
placeholder is not accepted by the Play Store).
