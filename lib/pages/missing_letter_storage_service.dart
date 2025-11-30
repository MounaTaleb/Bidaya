import 'package:shared_preferences/shared_preferences.dart';

class MissingLetterStorageService {
  static const String _highScoreKey = 'missing_letter_high_score';
  static const String _totalScoreKey = 'missing_letter_total_score';
  static const String _gamesPlayedKey = 'missing_letter_games_played';
  static const String _correctAnswersKey = 'missing_letter_correct_answers';
  static const String _wordsCompletedKey = 'missing_letter_words_completed';

  static Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  // Sauvegarder le score
  static Future<void> saveScore(int score) async {
    final prefs = await _prefs;

    // Mettre à jour le meilleur score
    final currentHighScore = await getHighScore();
    if (score > currentHighScore) {
      await prefs.setInt(_highScoreKey, score);
    }

    // Mettre à jour le score total
    final totalScore = await getTotalScore();
    await prefs.setInt(_totalScoreKey, totalScore + score);

    // Incrémenter le compteur de parties
    final gamesPlayed = await getGamesPlayed();
    await prefs.setInt(_gamesPlayedKey, gamesPlayed + 1);
  }

  // Incrémenter les réponses correctes
  static Future<void> incrementCorrectAnswers() async {
    final prefs = await _prefs;
    final current = await getCorrectAnswers();
    await prefs.setInt(_correctAnswersKey, current + 1);
  }

  // Incrémenter les mots complétés
  static Future<void> incrementWordsCompleted() async {
    final prefs = await _prefs;
    final current = await getWordsCompleted();
    await prefs.setInt(_wordsCompletedKey, current + 1);
  }

  // Getters
  static Future<int> getHighScore() async {
    final prefs = await _prefs;
    return prefs.getInt(_highScoreKey) ?? 0;
  }

  static Future<int> getTotalScore() async {
    final prefs = await _prefs;
    return prefs.getInt(_totalScoreKey) ?? 0;
  }

  static Future<int> getGamesPlayed() async {
    final prefs = await _prefs;
    return prefs.getInt(_gamesPlayedKey) ?? 0;
  }

  static Future<int> getCorrectAnswers() async {
    final prefs = await _prefs;
    return prefs.getInt(_correctAnswersKey) ?? 0;
  }

  static Future<int> getWordsCompleted() async {
    final prefs = await _prefs;
    return prefs.getInt(_wordsCompletedKey) ?? 0;
  }

  // Réinitialiser les statistiques
  static Future<void> resetStats() async {
    final prefs = await _prefs;
    await prefs.remove(_highScoreKey);
    await prefs.remove(_totalScoreKey);
    await prefs.remove(_gamesPlayedKey);
    await prefs.remove(_correctAnswersKey);
    await prefs.remove(_wordsCompletedKey);
  }

  // Obtenir toutes les statistiques
  static Future<Map<String, dynamic>> getAllStats() async {
    return {
      'highScore': await getHighScore(),
      'totalScore': await getTotalScore(),
      'gamesPlayed': await getGamesPlayed(),
      'correctAnswers': await getCorrectAnswers(),
      'wordsCompleted': await getWordsCompleted(),
      'accuracy': await _calculateAccuracy(),
    };
  }

  static Future<double> _calculateAccuracy() async {
    final correctAnswers = await getCorrectAnswers();
    final wordsCompleted = await getWordsCompleted();
    return wordsCompleted > 0 ? (correctAnswers / wordsCompleted) * 100 : 0;
  }
}