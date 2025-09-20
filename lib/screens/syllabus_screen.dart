// screens/syllabus_screen.dart
import 'package:flutter/material.dart';

class SyllabusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CEE 2082 Syllabus',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Complete syllabus breakdown for entrance preparation',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 20),
          _buildSyllabusOverview(context),
          SizedBox(height: 20),
          _buildSubjectSyllabus(),
        ],
      ),
    );
  }

  Widget _buildSyllabusOverview(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Exam Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          SizedBox(height: 12),
          Table(
            border: TableBorder.all(color: Colors.grey[300]!),
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.grey[100]),
                children: [
                  _buildTableCell('Subject', isHeader: true),
                  _buildTableCell('Questions', isHeader: true),
                  _buildTableCell('Marks', isHeader: true),
                ],
              ),
              TableRow(children: [
                _buildTableCell('Physics'),
                _buildTableCell('50'),
                _buildTableCell('50'),
              ]),
              TableRow(children: [
                _buildTableCell('Chemistry'),
                _buildTableCell('50'),
                _buildTableCell('50'),
              ]),
              TableRow(children: [
                _buildTableCell('Biology'),
                _buildTableCell('80'),
                _buildTableCell('80'),
              ]),
              TableRow(children: [
                _buildTableCell('MAT'),
                _buildTableCell('20'),
                _buildTableCell('20'),
              ]),
              TableRow(
                decoration: BoxDecoration(color: Colors.blue[50]),
                children: [
                  _buildTableCell('Total', isHeader: true),
                  _buildTableCell('200', isHeader: true),
                  _buildTableCell('200', isHeader: true),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSubjectSyllabus() {
    return Column(
      children: [
        _buildPhysicsSyllabus(),
        SizedBox(height: 16),
        _buildChemistrySyllabus(),
        SizedBox(height: 16),
        _buildZoologySyllabus(),
        SizedBox(height: 16),
        _buildBotanySyllabus(),
        SizedBox(height: 16),
        _buildMATSyllabus(),
      ],
    );
  }

  Widget _buildPhysicsSyllabus() {
    final physicsTopics = [
      {'topic': 'Mechanics', 'questions': 10},
      {'topic': 'Heat and thermodynamics', 'questions': 6},
      {'topic': 'Geometrical optics and physical optics', 'questions': 6},
      {'topic': 'Current electricity and magnetism', 'questions': 9},
      {'topic': 'Sound waves, electrostatics, and capacitors', 'questions': 6},
      {'topic': 'Modern physics and nuclear physics', 'questions': 6},
      {'topic': 'Solid and semiconductor devices', 'questions': 4},
      {'topic': 'Particle physics, source of energy, and universe', 'questions': 3},
    ];

    return _buildSyllabusCard(
      'Physics Syllabus',
      'Full Marks: 50',
      physicsTopics,
      Colors.red,
      Icons.science,
    );
  }

  Widget _buildChemistrySyllabus() {
    final chemistryTopics = [
      {'topic': 'General and physical chemistry', 'questions': 18},
      {'topic': 'Inorganic chemistry', 'questions': 14},
      {'topic': 'Organic Chemistry', 'questions': 18},
    ];

    return _buildSyllabusCard(
      'Chemistry Syllabus',
      'Full Marks: 50',
      chemistryTopics,
      Colors.green,
      Icons.biotech,
    );
  }

  Widget _buildZoologySyllabus() {
    final zoologyTopics = [
      {'topic': 'Biology, origin, and evolution of life', 'questions': 4},
      {'topic': 'General characteristics and classification of protozoa to Chordata', 'questions': 8},
      {'topic': 'Plasmodium, earthworm, and frog', 'questions': 8},
      {'topic': 'Human biology and human diseases', 'questions': 14},
      {'topic': 'Animal Tissues', 'questions': 4},
      {'topic': 'Environmental pollution, adaptation and animal behavior, application of Zoology', 'questions': 2},
    ];

    return _buildSyllabusCard(
      'Zoology Syllabus',
      'Full Marks: 40',
      zoologyTopics,
      Colors.teal,
      Icons.pets,
    );
  }

  Widget _buildBotanySyllabus() {
    final botanyTopics = [
      {'topic': 'A basic component of life and biodiversity', 'questions': 11},
      {'topic': 'Ecology and environment', 'questions': 5},
      {'topic': 'Cell biology and genetics', 'questions': 12},
      {'topic': 'Anatomy and physiology', 'questions': 7},
      {'topic': 'Developmental and applied botany', 'questions': 5},
    ];

    return _buildSyllabusCard(
      'Botany Syllabus',
      'Full Marks: 40',
      botanyTopics,
      Colors.green[700]!,
      Icons.local_florist,
    );
  }

  Widget _buildMATSyllabus() {
    final matTopics = [
      {'topic': 'Verbal reasoning', 'questions': 5},
      {'topic': 'Numerical reasoning', 'questions': 5},
      {'topic': 'Logical sequencing', 'questions': 5},
      {'topic': 'Spatial relation / Abstract reasoning', 'questions': 5},
    ];

    return _buildSyllabusCard(
      'MAT Syllabus',
      'Full Marks: 20',
      matTopics,
      Colors.orange,
      Icons.psychology,
    );
  }

  Widget _buildSyllabusCard(String title, String marks, List<Map<String, dynamic>> topics, Color color, IconData icon) {
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
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(marks),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: topics.map((topic) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 24,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            '${topic['questions']}',
                            style: TextStyle(
                              color: color,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          topic['topic'] as String,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}