// screens/quiz_categories_screen.dart
import 'package:flutter/material.dart';
import '../models/quiz_data.dart';
import 'quiz_list_screen.dart';

class QuizCategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quiz Categories',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Choose your practice mode and level',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 20),
          _buildCategoryCards(context),
        ],
      ),
    );
  }

  Widget _buildCategoryCards(BuildContext context) {
    final categories = [
      {
        'name': 'Full Test',
        'description': 'Complete CEE practice test (200Q)',
        'icon': Icons.assignment,
        'color': Color(0xFF1976D2),
        'quizCount': QuizData.quizSets['Full Test']?.length ?? 0,
      },
      {
        'name': 'Physics',
        'description': 'Physics practice tests (50Q)',
        'icon': Icons.science,
        'color': Colors.red,
        'quizCount': QuizData.quizSets['Physics']?.length ?? 0,
      },
      {
        'name': 'Chemistry',
        'description': 'Chemistry practice tests (50Q)',
        'icon': Icons.biotech,
        'color': Colors.green,
        'quizCount': QuizData.quizSets['Chemistry']?.length ?? 0,
      },
      {
        'name': 'Zoology',
        'description': 'Zoology practice tests (40Q)',
        'icon': Icons.pets,
        'color': Colors.teal,
        'quizCount': QuizData.quizSets['Zoology']?.length ?? 0,
      },
      {
        'name': 'Botany',
        'description': 'Botany practice tests (40Q)',
        'icon': Icons.local_florist,
        'color': Colors.green[700]!,
        'quizCount': QuizData.quizSets['Botany']?.length ?? 0,
      },
      {
        'name': 'MAT',
        'description': 'MAT practice tests (20Q)',
        'icon': Icons.psychology,
        'color': Colors.orange,
        'quizCount': QuizData.quizSets['MAT']?.length ?? 0,
      },
      {
        'name': 'Mechanics',
        'description': 'Mechanics practice tests (10Q)',
        'icon': Icons.engineering,
        'color': Colors.purple,
        'quizCount': QuizData.quizSets['Mechanics']?.length ?? 0,
      },
    ];

    return Column(
      children: categories.map((category) {
        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: _buildCategoryCard(context, category),
        );
      }).toList(),
    );
  }

  Widget _buildCategoryCard(BuildContext context, Map<String, dynamic> category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizListScreen(category: category['name'] as String),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: (category['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                category['icon'] as IconData,
                color: category['color'] as Color,
                size: 32,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category['name'] as String,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    category['description'] as String,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.quiz, size: 16, color: Colors.grey[500]),
                      SizedBox(width: 4),
                      Text(
                        '${category['quizCount']} Tests',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}