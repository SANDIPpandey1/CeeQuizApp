import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';
import 'screens/quiz_categories_screen.dart';
import 'screens/syllabus_screen.dart';
import 'screens/content_library_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/about_screen.dart';
import 'widgets/custom_drawer.dart';
import 'models/user_progress.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CEEQuizApp());
}

class CEEQuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeNotifier.instance.isDarkMode,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          title: 'CEE Quiz 2082',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Color(0xFF2196F3),
            scaffoldBackgroundColor: Color(0xFFF5F5F5),
            fontFamily: 'Roboto',
            brightness: Brightness.light,
            appBarTheme: AppBarTheme(
              backgroundColor: Color(0xFF1976D2),
              elevation: 0,
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              iconTheme: IconThemeData(color: Colors.white),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Colors.white,
              selectedItemColor: Color(0xFF1976D2),
              unselectedItemColor: Colors.grey[600],
              elevation: 8,
              type: BottomNavigationBarType.fixed,
            ),
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Color(0xFF2196F3),
            scaffoldBackgroundColor: Color(0xFF121212),
            fontFamily: 'Roboto',
            brightness: Brightness.dark,
            appBarTheme: AppBarTheme(
              backgroundColor: Color(0xFF1F1F1F),
              elevation: 0,
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              iconTheme: IconThemeData(color: Colors.white),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Color(0xFF1F1F1F),
              selectedItemColor: Color(0xFF42A5F5),
              unselectedItemColor: Colors.grey[400],
              elevation: 8,
              type: BottomNavigationBarType.fixed,
            ),
          ),
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: MainScreen(),
        );
      },
    );
  }
}

class ThemeNotifier {
  static final ThemeNotifier instance = ThemeNotifier._internal();
  ThemeNotifier._internal();

  final ValueNotifier<bool> isDarkMode = ValueNotifier<bool>(false);

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _screens = [
    HomeScreen(),
    QuizCategoriesScreen(),
    SyllabusScreen(),
    ContentLibraryScreen(),
    CalendarScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('CEE Quiz 2082'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: ValueListenableBuilder<bool>(
              valueListenable: ThemeNotifier.instance.isDarkMode,
              builder: (context, isDarkMode, child) {
                return Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode);
              },
            ),
            onPressed: () => ThemeNotifier.instance.toggleTheme(),
          ),
        ],
      ),
      drawer: CustomDrawer(
        onSelectTab: (int index) {
          // close drawer first, then switch tab
          setState(() => _currentIndex = index);
        },
      ),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.quiz_outlined),
              activeIcon: Icon(Icons.quiz),
              label: 'Quizzes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined),
              activeIcon: Icon(Icons.book),
              label: 'Syllabus',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books_outlined),
              activeIcon: Icon(Icons.library_books),
              label: 'Content',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              activeIcon: Icon(Icons.calendar_month),
              label: 'Calendar',
            ),
          ],
        ),
      ),
    );
  }
}
