// Enhanced Quiz List Screen with Timer Options
// screens/quiz_list_screen.dart
import 'package:flutter/material.dart';
import '../models/quiz_data.dart';
import 'quiz_webview_screen.dart';

class QuizListScreen extends StatefulWidget {
  final String category;

  QuizListScreen({required this.category});

  @override
  _QuizListScreenState createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  @override
  Widget build(BuildContext context) {
    final quizzes = QuizData.quizSets[widget.category] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Tests'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Choose a test and select timer mode for better practice experience.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ...quizzes.map((quiz) => Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: _buildQuizCard(context, quiz),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizCard(BuildContext context, Map<String, String> quiz) {
    bool isCompleted = QuizData.completedQuizzes.contains(quiz['name']);
    bool isBookmarked = QuizData.bookmarkedQuizzes.contains(quiz['name']);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted ? Colors.green.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (isCompleted)
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(Icons.check, color: Colors.green, size: 16),
                  ),
                if (isCompleted) SizedBox(width: 8),
                Expanded(
                  child: Text(
                    quiz['name']!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: Colors.orange,
                  ),
                  onPressed: () {
                    setState(() {
                      if (isBookmarked) {
                        QuizData.bookmarkedQuizzes.remove(quiz['name']);
                      } else {
                        QuizData.bookmarkedQuizzes.add(quiz['name']!);
                      }
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              quiz['description']!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                _buildInfoChip(Icons.quiz, '${quiz['questions']} Questions'),
                SizedBox(width: 12),
                _buildInfoChip(Icons.timer, '${quiz['duration']} min'),
              ],
            ),
            if (isCompleted && QuizData.quizScores.containsKey(quiz['name']))
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Best Score: ${QuizData.quizScores[quiz['name']]}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizWebViewScreen(
                            quizName: quiz['name']!,
                            quizUrl: quiz['url']!,
                            questions: quiz['questions']!,
                            duration: int.parse(quiz['duration']!),
                            hasTimer: false,
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.play_arrow),
                    label: Text('Start Quiz'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFF1976D2),
                      side: BorderSide(color: Color(0xFF1976D2)),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizWebViewScreen(
                            quizName: quiz['name']!,
                            quizUrl: quiz['url']!,
                            questions: quiz['questions']!,
                            duration: int.parse(quiz['duration']!),
                            hasTimer: true,
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.timer),
                    label: Text('Timed Quiz'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1976D2),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}