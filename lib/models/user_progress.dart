// models/user_progress.dart
class UserProgress {
  final Map<String, LevelProgress> categoryProgress;
  final int totalStars;
  final int currentStreak;

  const UserProgress({
    required this.categoryProgress,
    required this.totalStars,
    required this.currentStreak,
  });

  factory UserProgress.empty() {
    return UserProgress(
      categoryProgress: {
        'math': LevelProgress(
          category: 'math',
          currentLevel: 1,
          completedLevels: 0,
          totalStars: 0,
          unlocked: true,
        ),
        'countries': LevelProgress(
          category: 'countries',
          currentLevel: 1,
          completedLevels: 0,
          totalStars: 0,
          unlocked: false,
        ),
        'puzzles': LevelProgress(
          category: 'puzzles',
          currentLevel: 1,
          completedLevels: 0,
          totalStars: 0,
          unlocked: false,
        ),
      },
      totalStars: 0,
      currentStreak: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryProgress': categoryProgress.map((key, value) => MapEntry(key, value.toJson())),
      'totalStars': totalStars,
      'currentStreak': currentStreak,
    };
  }

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      categoryProgress: (json['categoryProgress'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, LevelProgress.fromJson(value)),
      ),
      totalStars: json['totalStars'] ?? 0,
      currentStreak: json['currentStreak'] ?? 0,
    );
  }
}

class LevelProgress {
  final String category;
  int currentLevel;
  int completedLevels;
  int totalStars;
  bool unlocked;

  LevelProgress({
    required this.category,
    required this.currentLevel,
    required this.completedLevels,
    required this.totalStars,
    required this.unlocked,
  });

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'currentLevel': currentLevel,
      'completedLevels': completedLevels,
      'totalStars': totalStars,
      'unlocked': unlocked,
    };
  }

  factory LevelProgress.fromJson(Map<String, dynamic> json) {
    return LevelProgress(
      category: json['category'],
      currentLevel: json['currentLevel'] ?? 1,
      completedLevels: json['completedLevels'] ?? 0,
      totalStars: json['totalStars'] ?? 0,
      unlocked: json['unlocked'] ?? false,
    );
  }
}