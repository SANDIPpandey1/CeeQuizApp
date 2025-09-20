// services/firebase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all active quizzes grouped by category
  static Future<Map<String, List<Map<String, dynamic>>>> getQuizzesByCategory() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('quizzes')
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      Map<String, List<Map<String, dynamic>>> categorizedQuizzes = {};

      for (var doc in snapshot.docs) {
        final quiz = doc.data() as Map<String, dynamic>;
        quiz['id'] = doc.id;
        
        final category = quiz['category'] as String;
        
        if (!categorizedQuizzes.containsKey(category)) {
          categorizedQuizzes[category] = [];
        }
        
        categorizedQuizzes[category]!.add({
          'name': quiz['name'],
          'description': quiz['description'],
          'url': quiz['url'],
          'questions': quiz['questions'].toString(),
          'duration': quiz['duration'].toString(),
        });
      }

      return categorizedQuizzes;
    } catch (e) {
      print('Error fetching quizzes: $e');
      return {};
    }
  }

  // Add new quiz (for admin use)
  static Future<void> addQuiz(Map<String, dynamic> quizData) async {
    try {
      await _firestore.collection('quizzes').add({
        ...quizData,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding quiz: $e');
      throw e;
    }
  }

  // Update quiz
  static Future<void> updateQuiz(String quizId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('quizzes').doc(quizId).update({
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating quiz: $e');
      throw e;
    }
  }

  // Delete quiz
  static Future<void> deleteQuiz(String quizId) async {
    try {
      await _firestore.collection('quizzes').doc(quizId).delete();
    } catch (e) {
      print('Error deleting quiz: $e');
      throw e;
    }
  }

  // Toggle quiz active status
  static Future<void> toggleQuizStatus(String quizId, bool isActive) async {
    try {
      await _firestore.collection('quizzes').doc(quizId).update({
        'isActive': isActive,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error toggling quiz status: $e');
      throw e;
    }
  }

  // Save user progress
  static Future<void> saveUserProgress({
    required String userId,
    required String quizId,
    required int score,
    required int timeTaken,
    required Map<String, dynamic> answers,
  }) async {
    try {
      await _firestore.collection('user_progress').add({
        'userId': userId,
        'quizId': quizId,
        'score': score,
        'timeTaken': timeTaken,
        'answers': answers,
        'completedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving user progress: $e');
      throw e;
    }
  }

  // Get user statistics
  static Future<Map<String, dynamic>> getUserStats(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('user_progress')
          .where('userId', isEqualTo: userId)
          .get();

      int totalQuizzes = snapshot.size;
      int totalScore = 0;
      int totalTime = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        totalScore += (data['score'] as int? ?? 0);
        totalTime += (data['timeTaken'] as int? ?? 0);
      }

      double averageScore = totalQuizzes > 0 ? totalScore / totalQuizzes : 0;
      int averageTime = totalQuizzes > 0 ? totalTime ~/ totalQuizzes : 0;

      return {
        'totalQuizzes': totalQuizzes,
        'averageScore': averageScore,
        'averageTime': averageTime,
        'totalTimeSpent': totalTime,
      };
    } catch (e) {
      print('Error fetching user stats: $e');
      return {
        'totalQuizzes': 0,
        'averageScore': 0.0,
        'averageTime': 0,
        'totalTimeSpent': 0,
      };
    }
  }
}

