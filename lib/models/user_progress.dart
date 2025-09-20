import 'package:flutter/foundation.dart';

class UserProgress extends ChangeNotifier {
  static final UserProgress _instance = UserProgress._internal();
  factory UserProgress() => _instance;
  UserProgress._internal();

  Map<DateTime, int> _activityData = {};
  int _totalQuizzesTaken = 0;
  int _totalContentRead = 0;
  int _streakDays = 0;

  Map<DateTime, int> get activityData => _activityData;
  int get totalQuizzesTaken => _totalQuizzesTaken;
  int get totalContentRead => _totalContentRead;
  int get streakDays => _streakDays;

  void recordQuizActivity() {
    final today = DateTime.now();
    final dateKey = DateTime(today.year, today.month, today.day);
    
    _activityData[dateKey] = (_activityData[dateKey] ?? 0) + 1;
    _totalQuizzesTaken++;
    _updateStreak();
    notifyListeners();
  }

  void recordContentActivity() {
    final today = DateTime.now();
    final dateKey = DateTime(today.year, today.month, today.day);
    
    _activityData[dateKey] = (_activityData[dateKey] ?? 0) + 1;
    _totalContentRead++;
    _updateStreak();
    notifyListeners();
  }

  void _updateStreak() {
    final today = DateTime.now();
    int streak = 0;
    
    for (int i = 0; i < 365; i++) {
      final checkDate = today.subtract(Duration(days: i));
      final dateKey = DateTime(checkDate.year, checkDate.month, checkDate.day);
      
      if (_activityData.containsKey(dateKey)) {
        streak++;
      } else {
        break;
      }
    }
    
    _streakDays = streak;
  }

  int getActivityLevel(DateTime date) {
    final dateKey = DateTime(date.year, date.month, date.day);
    final activity = _activityData[dateKey] ?? 0;
    
    if (activity == 0) return 0;
    if (activity <= 2) return 1;
    if (activity <= 4) return 2;
    if (activity <= 6) return 3;
    return 4;
  }
}