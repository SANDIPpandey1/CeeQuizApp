// Enhanced Quiz WebView Screen with Timer
// screens/quiz_webview_screen.dart
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import '../models/quiz_data.dart';
import '../models/user_progress.dart';

class QuizWebViewScreen extends StatefulWidget {
  final String quizName;
  final String quizUrl;
  final String questions;
  final int duration; // in minutes
  final bool hasTimer;

  QuizWebViewScreen({
    required this.quizName,
    required this.quizUrl,
    required this.questions,
    required this.duration,
    this.hasTimer = false,
  });

  @override
  _QuizWebViewScreenState createState() => _QuizWebViewScreenState();
}

class _QuizWebViewScreenState extends State<QuizWebViewScreen> {
  late WebViewController controller;
  bool isLoading = true;
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isTimerActive = false;

  @override
  void initState() {
    super.initState();
    if (widget.hasTimer) {
      _remainingSeconds = widget.duration * 60;
      _startTimer();
    }
    _initializeWebView();
  }

  void _initializeWebView() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress == 100) {
              setState(() {
                isLoading = false;
              });
            }
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.quizUrl));
  }

  void _startTimer() {
    _isTimerActive = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
          _showTimeUpDialog();
        }
      });
    });
  }

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Time\'s Up!'),
          content: Text('The quiz time has ended. Please submit your answers.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _markQuizCompleted();
                Navigator.pop(context); // Exit quiz
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              widget.quizName,
              style: TextStyle(fontSize: 16),
            ),
            if (widget.hasTimer && _isTimerActive)
              Text(
                _formatTime(_remainingSeconds),
                style: TextStyle(
                  fontSize: 14,
                  color: _remainingSeconds < 300 ? Colors.red : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        centerTitle: true,
        backgroundColor: widget.hasTimer && _remainingSeconds < 300 
            ? Colors.red[700] 
            : Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              controller.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1976D2)),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading ${widget.quizName}...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${widget.questions} Questions • ${widget.duration} min',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _showExitDialog(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: Color(0xFF1976D2)),
                  ),
                  child: Text('Exit Quiz'),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _markQuizCompleted();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Quiz completed successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Submit Quiz',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exit Quiz?'),
          content: Text('Are you sure you want to exit? Your progress may not be saved.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _timer?.cancel();
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Exit quiz
              },
              child: Text('Exit', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _markQuizCompleted() {
    _timer?.cancel();
    QuizData.completedQuizzes.add(widget.quizName);
    UserProgress().recordQuizActivity();
  }
}
