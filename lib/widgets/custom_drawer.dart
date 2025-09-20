import 'package:flutter/material.dart';
import '../screens/about_screen.dart';
// import '../models/quiz_data.dart'; // Hidden features use this; keep commented for now.

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, required this.onSelectTab});

  /// 0=Home, 1=Quizzes, 2=Syllabus, 3=Content, 4=Calendar
  final ValueChanged<int> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 20,
                bottom: 20,
              ),
              child: const Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.school,
                      size: 40,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'CEE Quiz 2082',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Master Your Entrance Exam',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            // Menu
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  children: [
                    _drawerItem(
                      Icons.home,
                      'Home',
                      () => _switchTab(context, 0),
                    ),
                    _drawerItem(
                      Icons.quiz,
                      'Practice Tests',
                      () => _switchTab(context, 1),
                    ),
                    _drawerItem(
                      Icons.book,
                      'Syllabus',
                      () => _switchTab(context, 2),
                    ),
                    _drawerItem(
                      Icons.library_books,
                      'Study Materials',
                      () => _switchTab(context, 3),
                    ),
                    _drawerItem(
                      Icons.calendar_month,
                      'Exam Calendar',
                      () => _switchTab(context, 4),
                    ),

                    // ----- Hidden for now -----
                    // _drawerItem(
                    //   Icons.bookmark,
                    //   'Bookmarks (${QuizData.bookmarkedQuizzes.length})',
                    //   () => _showBookmarkedQuizzes(context),
                    // ),
                    // _drawerItem(
                    //   Icons.history,
                    //   'Quiz History',
                    //   () => _showQuizHistory(context),
                    // ),
                    // ---------------------------
                    const Divider(height: 30),
                    _drawerItem(Icons.info, 'About', () => _openAbout(context)),
                    _drawerItem(
                      Icons.help,
                      'Help & Support',
                      () => _showHelpDialog(context),
                    ),
                    _drawerItem(
                      Icons.feedback,
                      'Feedback',
                      () => _showFeedbackDialog(context),
                    ),
                    _drawerItem(
                      Icons.settings,
                      'Settings',
                      () => _showSettingsDialog(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Helpers ----------

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF1976D2)),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(25)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }

  void _switchTab(BuildContext context, int index) {
    Navigator.of(context).pop(); // close drawer
    WidgetsBinding.instance.addPostFrameCallback((_) => onSelectTab(index));
  }

  void _openAbout(BuildContext context) {
    Navigator.of(context).pop();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => AboutScreen()));
    });
  }

  // ----- Hidden (Bookmarks/History) -----
  // void _showBookmarkedQuizzes(BuildContext context) { ... }
  // void _showQuizHistory(BuildContext context) { ... }
  // --------------------------------------

  void _showHelpDialog(BuildContext context) {
    Navigator.of(context).pop();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        useRootNavigator: true,
        builder:
            (dialogContext) => AlertDialog(
              title: const Text('Help & Support'),
              content: const SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'How to use CEE Quiz App:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 12),
                    _HelpRow(
                      '🎯',
                      'Choose a quiz category from the Quizzes tab',
                    ),
                    _HelpRow(
                      '⏱️',
                      'Select timed or practice mode for better preparation',
                    ),
                    _HelpRow('📚', 'Access study materials from Content tab'),
                    _HelpRow('📅', 'Check exam dates in Calendar tab'),
                    _HelpRow(
                      '🔖',
                      'Bookmark important quizzes for quick access',
                    ),
                    _HelpRow('📊', 'Track your progress on the Home screen'),
                    SizedBox(height: 16),
                    Text(
                      'Need more help?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Contact us at: contact@ceequiz2082.com'),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Got it!'),
                ),
              ],
            ),
      );
    });
  }

  void _showFeedbackDialog(BuildContext context) {
    Navigator.of(context).pop();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final feedbackController = TextEditingController();
      showDialog(
        context: context,
        useRootNavigator: true,
        builder:
            (dialogContext) => AlertDialog(
              title: const Text('Send Feedback'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Help us improve CEE Quiz 2082. Your feedback is valuable!',
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: feedbackController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Write your feedback here...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    Future.microtask(() {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        const SnackBar(
                          content: Text('Thank you for your feedback!'),
                        ),
                      );
                    });
                  },
                  child: const Text('Send'),
                ),
              ],
            ),
      );
    });
  }

  void _showSettingsDialog(BuildContext context) {
    Navigator.of(context).pop();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        useRootNavigator: true,
        builder:
            (dialogContext) => AlertDialog(
              title: const Text('Settings'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('Notifications'),
                    trailing: Switch(value: true, onChanged: (v) {}),
                  ),
                  ListTile(
                    leading: const Icon(Icons.download),
                    title: const Text('Auto Download Updates'),
                    trailing: Switch(value: false, onChanged: (v) {}),
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('Clear Cache'),
                    onTap: () {
                      Navigator.of(dialogContext).pop();
                      Future.microtask(() {
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          const SnackBar(
                            content: Text('Cache cleared successfully!'),
                          ),
                        );
                      });
                    },
                  ),
                  const ListTile(
                    leading: Icon(Icons.info),
                    title: Text('App Version'),
                    subtitle: Text('1.0.0'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
      );
    });
  }
}

class _HelpRow extends StatelessWidget {
  final String icon;
  final String text;
  const _HelpRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
