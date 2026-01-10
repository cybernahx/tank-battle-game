import 'package:flame_audio/flame_audio.dart';

class AudioManager {
  static bool _initialized = false;
  static bool _musicPlaying = false;
  static double _sfxVolume = 0.7;
  static double _musicVolume = 0.5;

  static Future<void> init() async {
    if (_initialized) return;
    
    // Preload common sounds
    await FlameAudio.audioCache.loadAll([
      'shoot.mp3',
      'explosion.mp3',
      'hit.mp3',
    ]);
    _initialized = true;
  }

  static void playShoot() {
    FlameAudio.play('shoot.mp3', volume: _sfxVolume);
  }

  static void playExplosion() {
    FlameAudio.play('explosion.mp3', volume: _sfxVolume);
  }

  static void playHit() {
    FlameAudio.play('hit.mp3', volume: _sfxVolume);
  }

  static void startBackgroundMusic() {
    if (!_musicPlaying) {
      FlameAudio.bgm.play('bgm.mp3', volume: _musicVolume);
      _musicPlaying = true;
    }
  }

  static void stopBackgroundMusic() {
    FlameAudio.bgm.stop();
    _musicPlaying = false;
  }

  static void setSfxVolume(double volume) {
    _sfxVolume = volume.clamp(0.0, 1.0);
  }

  static void setMusicVolume(double volume) {
    _musicVolume = volume.clamp(0.0, 1.0);
    if (_musicPlaying) {
      FlameAudio.bgm.stop();
      FlameAudio.bgm.play('bgm.mp3', volume: _musicVolume);
    }
  }
}
