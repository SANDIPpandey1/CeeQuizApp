// models/quiz_data.dart
class QuizData {
  static Map<String, List<Map<String, String>>> quizSets = {
    'Full Test': [
      {
        'name': 'Full CEE Mock Test 1',
        'description': 'Complete practice test with all subjects',
        'url': 'https://docs.google.com/forms/d/e/1FAIpQLSc9z17fcrI_lIewSCTrOfpPe7JVa6wZgnA0JUOes9qruxxIWQ/viewform',
        'questions': '200',
        'duration': '180'
      },
      // Add more tests...
    ],
    'Physics': [
      {
        'name': 'Physics Complete Test 1',
        'description': 'All physics topics combined',
        'url': 'https://docs.google.com/forms/d/e/1FAIpQLSc9z17fcrI_lIewSCTrOfpPe7JVa6wZgnA0JUOes9qruxxIWQ/viewform',
        'questions': '50',
        'duration': '45'
      },
    ],
    // Add other subjects...
  };

  static Set<String> completedQuizzes = {};
  static Set<String> bookmarkedQuizzes = {};
  static Map<String, int> quizScores = {};
}