// screens/content_library_screen.dart
import 'package:flutter/material.dart';
import 'content_detail_screen.dart';
import '../models/user_progress.dart';

class ContentLibraryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Study Materials',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Comprehensive content for all subjects',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 20),
          _buildContentCategories(context),
        ],
      ),
    );
  }

  Widget _buildContentCategories(BuildContext context) {
    final subjects = [
      {
        'name': 'Physics',
        'icon': Icons.science,
        'color': Colors.red,
        'topics': [
          'Mechanics',
          'Heat and Thermodynamics',
          'Geometrical Optics and Physical Optics',
          'Current Electricity and Magnetism',
          'Sound Waves, Electrostatics, and Capacitors',
          'Modern Physics and Nuclear Physics',
          'Solid and Semiconductor Devices',
          'Particle Physics, Source of Energy, and Universe'
        ]
      },
      {
        'name': 'Chemistry',
        'icon': Icons.biotech,
        'color': Colors.green,
        'topics': [
          'General and Physical Chemistry',
          'Inorganic Chemistry',
          'Organic Chemistry'
        ]
      },
      {
        'name': 'Zoology',
        'icon': Icons.pets,
        'color': Colors.teal,
        'topics': [
          'Biology, Origin, and Evolution of Life',
          'General Characteristics and Classification of Protozoa to Chordata',
          'Plasmodium, Earthworm, and Frog',
          'Human Biology and Human Diseases',
          'Animal Tissues',
          'Environmental Pollution, Adaptation and Animal Behavior, Application of Zoology'
        ]
      },
      {
        'name': 'Botany',
        'icon': Icons.local_florist,
        'color': Colors.green[700]!,
        'topics': [
          'A Basic Component of Life and Biodiversity',
          'Ecology and Environment',
          'Cell Biology and Genetics',
          'Anatomy and Physiology',
          'Developmental and Applied Botany'
        ]
      },
      {
        'name': 'MAT',
        'icon': Icons.psychology,
        'color': Colors.orange,
        'topics': [
          'Verbal Reasoning',
          'Numerical Reasoning',
          'Logical Sequencing',
          'Spatial Relation / Abstract Reasoning'
        ]
      },
    ];

    return Column(
      children: subjects.map((subject) {
        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: _buildSubjectContentCard(context, subject),
        );
      }).toList(),
    );
  }

  Widget _buildSubjectContentCard(BuildContext context, Map<String, dynamic> subject) {
    return Container(
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
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: (subject['color'] as Color).withOpacity(0.1),
          child: Icon(
            subject['icon'] as IconData,
            color: subject['color'] as Color,
          ),
        ),
        title: Text(
          subject['name'] as String,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text('${(subject['topics'] as List).length} Topics'),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: (subject['topics'] as List<String>).map((topic) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.article_outlined,
                      color: subject['color'] as Color,
                      size: 20,
                    ),
                    title: Text(
                      topic,
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, 
                             color: Colors.green.withOpacity(0.3), 
                             size: 16),
                        SizedBox(width: 4),
                        Icon(Icons.chevron_right, size: 16),
                      ],
                    ),
                    onTap: () {
                      // Record content activity when user opens a topic
                      UserProgress().recordContentActivity();
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContentDetailScreen(
                            subject: subject['name'] as String,
                            topic: topic,
                            color: subject['color'] as Color,
                          ),
                        ),
                      );
                    },
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