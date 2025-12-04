// lib/services/local_storage_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  static SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Sauvegarder la progression (version simplifiée sans JSON)
  Future<void> saveProgress({
    required String category,
    required int niveau,
    required int score,
    required bool niveauTermine,
  }) async {
    await init();

    // 1. Sauvegarder le dernier niveau atteint
    final lastLevelKey = '${category}_last_level';
    final currentLastLevel = _prefs!.getInt(lastLevelKey) ?? 1;
    if (niveau > currentLastLevel) {
      await _prefs!.setInt(lastLevelKey, niveau);
    }

    // 2. Sauvegarder le meilleur score pour ce niveau
    final scoreKey = '${category}_score_$niveau';
    final currentScore = _prefs!.getInt(scoreKey) ?? 0;
    if (score > currentScore) {
      await _prefs!.setInt(scoreKey, score);
    }

    // 3. Marquer le niveau comme terminé si score >= 3
    if (niveauTermine && score >= 3) {
      final completedKey = '${category}_completed_$niveau';
      await _prefs!.setBool(completedKey, true);
    }

    print('✅ Progression sauvegardée: $category - Niveau $niveau - Score $score');
  }

  // Récupérer le dernier niveau débloqué
  Future<int> getLastLevel(String category) async {
    await init();
    return _prefs!.getInt('${category}_last_level') ?? 1;
  }

  // Récupérer le meilleur score d'un niveau
  Future<int> getBestScore(String category, int niveau) async {
    await init();
    return _prefs!.getInt('${category}_score_$niveau') ?? 0;
  }

  // Vérifier si un niveau est terminé (score >= 3)
  Future<bool> isLevelCompleted(String category, int niveau) async {
    await init();
    return _prefs!.getBool('${category}_completed_$niveau') ?? false;
  }

  // Vérifier si un niveau est débloqué
  Future<bool> isLevelUnlocked(String category, int niveau) async {
    final lastLevel = await getLastLevel(category);
    return niveau <= lastLevel;
  }

  // Récupérer tous les niveaux terminés d'une catégorie
  Future<List<int>> getCompletedLevels(String category) async {
    await init();
    List<int> completedLevels = [];

    for (int i = 1; i <= 25; i++) {
      if (await isLevelCompleted(category, i)) {
        completedLevels.add(i);
      }
    }

    return completedLevels;
  }

  // Récupérer tous les scores d'une catégorie
  Future<Map<int, int>> getAllScores(String category) async {
    await init();
    Map<int, int> scores = {};

    for (int i = 1; i <= 25; i++) {
      scores[i] = await getBestScore(category, i);
    }

    return scores;
  }

  // Réinitialiser la progression d'une catégorie
  Future<void> resetCategory(String category) async {
    await init();

    // Supprimer tous les clés de cette catégorie
    final keys = _prefs!.getKeys();
    for (String key in keys) {
      if (key.startsWith('${category}_')) {
        await _prefs!.remove(key);
      }
    }

    print('✅ Progression réinitialisée pour: $category');
  }

  // Effacer toutes les données (pour le débogage)
  Future<void> clearAllData() async {
    await init();
    await _prefs!.clear();
    print('✅ Toutes les données locales effacées');
  }
}