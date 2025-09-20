// Enhanced Home Screen with Complete Progress Tracking
// screens/home_screen.dart
import 'package:flutter/material.dart';
import '../models/quiz_data.dart';
import '../models/user_progress.dart';
import '../widgets/progress_tracker.dart';
import 'quiz_list_screen.dart';
import 'quiz_webview_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeCard(),
          SizedBox(height: 20),
          ProgressTracker(),
          SizedBox(height: 20),
          _buildQuickStats(),
          SizedBox(height: 20),
          Text(
            'Quick Start',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          SizedBox(height: 16),
          _buildQuickActions(context),
          SizedBox(height: 20),
          Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          SizedBox(height: 16),
          _buildRecentQuizzes(context),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.wb_sunny, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text(
                'Ready for CEE 2082?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Continue your preparation journey',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Track your progress and stay consistent',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    int completedCount = QuizData.completedQuizzes.length;
    int totalQuizzes = QuizData.quizSets.values.fold(
      0,
      (sum, list) => sum + list.length,
    );
    int bookmarkedCount = QuizData.bookmarkedQuizzes.length;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Completed',
            '$completedCount',
            Icons.check_circle,
            Colors.green,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Total Tests',
            '$totalQuizzes',
            Icons.quiz,
            Colors.orange,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Bookmarked',
            '$bookmarkedCount',
            Icons.bookmark,
            Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Full Test',
                'Complete 200Q Practice',
                Icons.assignment,
                Color(0xFF1976D2),
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => QuizListScreen(category: 'Full Test'),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                'Physics',
                'Practice Physics',
                Icons.science,
                Colors.red,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizListScreen(category: 'Physics'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Chemistry',
                'Practice Chemistry',
                Icons.biotech,
                Colors.green,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => QuizListScreen(category: 'Chemistry'),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                'Biology',
                'Practice Biology',
                Icons.local_florist,
                Colors.teal,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizListScreen(category: 'Zoology'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentQuizzes(BuildContext context) {
    List<String> recentQuizzes = QuizData.completedQuizzes.take(3).toList();

    if (recentQuizzes.isEmpty) {
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(Icons.quiz_outlined, size: 48, color: Colors.grey[400]),
            SizedBox(height: 12),
            Text(
              'No quizzes completed yet',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              'Start your first quiz to see progress here',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children:
            recentQuizzes.map((quizName) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green.withOpacity(0.1),
                  child: Icon(Icons.check, color: Colors.green, size: 20),
                ),
                title: Text(
                  quizName,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  'Completed - Score: ${QuizData.quizScores[quizName] ?? 'N/A'}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        QuizData.bookmarkedQuizzes.contains(quizName)
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        color: Colors.orange,
                        size: 20,
                      ),
                      onPressed: () {
                        if (QuizData.bookmarkedQuizzes.contains(quizName)) {
                          QuizData.bookmarkedQuizzes.remove(quizName);
                        } else {
                          QuizData.bookmarkedQuizzes.add(quizName);
                        }
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        // Find and retake quiz
                        for (var category in QuizData.quizSets.keys) {
                          var quiz = QuizData.quizSets[category]?.firstWhere(
                            (q) => q['name'] == quizName,
                            orElse: () => {},
                          );
                          if (quiz != null && quiz.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => QuizWebViewScreen(
                                      quizName: quiz['name']!,
                                      quizUrl: quiz['url']!,
                                      questions: quiz['questions']!,
                                      duration: int.parse(quiz['duration']!),
                                    ),
                              ),
                            );
                            break;
                          }
                        }
                      },
                      child: Text('Retake'),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }
}
