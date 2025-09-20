import 'package:flutter/material.dart';
import '../models/user_progress.dart';

class ProgressTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          Row(
            children: [
              Icon(Icons.timeline, color: Colors.green),
              SizedBox(width: 8),
              Text(
                'Activity Progress',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildActivityGrid(),
          SizedBox(height: 12),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildActivityGrid() {
    final userProgress = UserProgress();
    final today = DateTime.now();
    
    return Container(
      height: 100,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 1,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemCount: 105, // 15 weeks
        itemBuilder: (context, index) {
          final date = today.subtract(Duration(days: 104 - index));
          final level = userProgress.getActivityLevel(date);
          
          return Container(
            decoration: BoxDecoration(
              color: _getColorForLevel(level),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      children: [
        Text('Less', style: TextStyle(fontSize: 12)),
        SizedBox(width: 8),
        Row(
          children: List.generate(5, (index) {
            return Container(
              width: 10,
              height: 10,
              margin: EdgeInsets.only(right: 2),
              decoration: BoxDecoration(
                color: _getColorForLevel(index),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ),
        SizedBox(width: 8),
        Text('More', style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Color _getColorForLevel(int level) {
    switch (level) {
      case 0: return Colors.grey[200]!;
      case 1: return Colors.green[200]!;
      case 2: return Colors.green[400]!;
      case 3: return Colors.green[600]!;
      case 4: return Colors.green[800]!;
      default: return Colors.grey[200]!;
    }
  }
}
