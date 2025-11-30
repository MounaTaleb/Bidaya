// services/progress_service.dart
import '../models/user_progress.dart';

class ProgressService {
  static UserProgress _currentProgress = UserProgress.empty();

  static Future<UserProgress> loadProgress() async {
    return _currentProgress;
  }

  static Future<void> saveProgress(UserProgress progress) async {
    _currentProgress = progress;
  }

  static Future<void> updateLevelProgress(
      String category,
      int level,
      int starsEarned
      ) async {
    final progress = await loadProgress();

    final updatedProgress = UserProgress(
      categoryProgress: progress.categoryProgress,
      totalStars: progress.totalStars + starsEarned,
      currentStreak: progress.currentStreak,
    );

    await saveProgress(updatedProgress);
  }

  static Future<void> resetProgress() async {
    _currentProgress = UserProgress.empty();
  }
}