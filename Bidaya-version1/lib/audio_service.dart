import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();
  static bool _isPlaying = false;
  static bool _isPausedByVideo = false;
  static bool _musicEnabled = true; // ✅ Nouveau: état activé/désactivé

  // ✅ Nouveau: Getter pour l'état de la musique
  static bool get isMusicEnabled => _musicEnabled;

  // ✅ Nouveau: Activer/désactiver la musique
  static Future<void> setMusicEnabled(bool enabled) async {
    _musicEnabled = enabled;
    if (!enabled) {
      await stopBackgroundMusic();
    } else {
      await startBackgroundMusic();
    }
  }

  static Future<void> startBackgroundMusic() async {
    try {
      if (!_isPlaying && _musicEnabled) {
        // ✅ Vérifier si la musique est activée
        await _player.setReleaseMode(ReleaseMode.loop);
        await _player.play(AssetSource('audio/bg_music.mp3'));
        _isPlaying = true;
        _isPausedByVideo = false;
        print("🎵 Musique de fond démarrée avec succès");
      }
    } catch (e) {
      print("❌ Erreur lecture musique: $e");
    }
  }

  static Future<void> stopBackgroundMusic() async {
    try {
      await _player.stop();
      _isPlaying = false;
      _isPausedByVideo = false;
      print("⏹️ Musique de fond arrêtée");
    } catch (e) {
      print("❌ Erreur arrêt musique: $e");
    }
  }

  static Future<void> pauseMusic() async {
    await _player.pause();
  }

  static Future<void> resumeMusic() async {
    if (_isPlaying) {
      await _player.resume();
    }
  }

  // ✅ Pause pour la vidéo (seulement si la musique est activée)
  static Future<void> pauseForVideo() async {
    try {
      if (_isPlaying && _musicEnabled) {
        await _player.pause();
        _isPausedByVideo = true;
        print("⏸️ Musique mise en pause pour la vidéo");
      }
    } catch (e) {
      print("❌ Erreur pause musique: $e");
    }
  }

  // ✅ Reprise après vidéo (seulement si la musique est activée)
  static Future<void> resumeAfterVideo() async {
    try {
      if (_isPausedByVideo && _musicEnabled) {
        await _player.resume();
        _isPausedByVideo = false;
        print("▶️ Musique reprise après la vidéo");
      }
    } catch (e) {
      print("❌ Erreur reprise musique: $e");
    }
  }

  // Getter pour vérifier l'état
  static bool get isPausedByVideo => _isPausedByVideo;
}
