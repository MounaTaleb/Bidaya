import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _highScoresKey = 'puzzle_high_scores';
  static const String _totalScoreKey = 'puzzle_total_score';
  static const String _gamesPlayedKey = 'puzzle_games_played';

  static Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  // Sauvegarder le score pour un puzzle spécifique
  static Future<void> savePuzzleScore(int puzzleId, int score) async { // Changé String en int
    final prefs = await _prefs;
    final highScores = await getHighScores();

    // Convertir l'ID du puzzle en String pour le stockage
    final puzzleIdString = puzzleId.toString();

    // Garder seulement le meilleur score
    if (!highScores.containsKey(puzzleIdString) || score > highScores[puzzleIdString]!) {
      highScores[puzzleIdString] = score;

      final scoresString = highScores.entries
          .map((e) => '${e.key}:${e.value}')
          .join(';');

      await prefs.setString(_highScoresKey, scoresString);
    }

    // Mettre à jour le score total
    final totalScore = await getTotalScore();
    await prefs.setInt(_totalScoreKey, totalScore + score);

    // Incrémenter le compteur de parties jouées
    final gamesPlayed = await getGamesPlayed();
    await prefs.setInt(_gamesPlayedKey, gamesPlayed + 1);
  }

  // Récupérer tous les meilleurs scores
  static Future<Map<String, int>> getHighScores() async {
    final prefs = await _prefs;
    final scoresString = prefs.getString(_highScoresKey) ?? '';

    if (scoresString.isEmpty) return {};

    final scores = <String, int>{};
    final pairs = scoresString.split(';');

    for (final pair in pairs) {
      final parts = pair.split(':');
      if (parts.length == 2) {
        scores[parts[0]] = int.tryParse(parts[1]) ?? 0;
      }
    }

    return scores;
  }

  // Récupérer le score pour un puzzle spécifique
  static Future<int> getPuzzleScore(int puzzleId) async { // Changé String en int
    final highScores = await getHighScores();
    final puzzleIdString = puzzleId.toString();
    return highScores[puzzleIdString] ?? 0;
  }

  // Récupérer le score total
  static Future<int> getTotalScore() async {
    final prefs = await _prefs;
    return prefs.getInt(_totalScoreKey) ?? 0;
  }

  // Récupérer le nombre de parties jouées
  static Future<int> getGamesPlayed() async {
    final prefs = await _prefs;
    return prefs.getInt(_gamesPlayedKey) ?? 0;
  }

  // Réinitialiser toutes les statistiques
  static Future<void> resetAllStats() async {
    final prefs = await _prefs;
    await prefs.remove(_highScoresKey);
    await prefs.remove(_totalScoreKey);
    await prefs.remove(_gamesPlayedKey);
  }

  // Nouvelle méthode pour obtenir les statistiques globales
  static Future<Map<String, dynamic>> getGlobalStats() async {
    final totalScore = await getTotalScore();
    final gamesPlayed = await getGamesPlayed();
    final highScores = await getHighScores();

    return {
      'totalScore': totalScore,
      'gamesPlayed': gamesPlayed,
      'highScores': highScores,
      'averageScore': gamesPlayed > 0 ? totalScore / gamesPlayed : 0,
    };
  }
}