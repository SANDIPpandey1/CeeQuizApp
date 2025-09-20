// widgets/exam_calendar.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ExamCalendar extends StatefulWidget {
  @override
  _ExamCalendarState createState() => _ExamCalendarState();
}

class _ExamCalendarState extends State<ExamCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<DateTime, List<String>> _examEvents = {
    DateTime(2025, 7, 15): ['MBBS - 11:00 AM – 2:00 PM'],
    DateTime(2025, 7, 16): ['BDS - 11:00 AM – 2:00 PM'],
    DateTime(2025, 7, 17): ['BSc Nursing/Midwifery, BASLP, B Perfusion Technology - 11:00 AM – 2:00 PM'],
    DateTime(2025, 7, 18): ['BAMS, BNS/BMS, BSc MLT, BSc MIT, etc. - 11:00 AM – 2:00 PM'],
    DateTime(2025, 7, 19): ['BPH - 11:00 AM – 2:00 PM'],
  };

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        children: [
          _buildCountdown(),
          TableCalendar<String>(
            firstDay: DateTime.utc(2025, 1, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            eventLoader: (day) => _examEvents[day] ?? [],
            startingDayOfWeek: StartingDayOfWeek.sunday,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              markerDecoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          if (_selectedDay != null && _examEvents[_selectedDay] != null)
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Exam Details:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ..._examEvents[_selectedDay]!.map((event) => 
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text('• $event'),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCountdown() {
    final examDate = DateTime(2025, 7, 15);
    final now = DateTime.now();
    final difference = examDate.difference(now);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Time Remaining for CEE 2082',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          if (difference.isNegative)
            Text(
              'Exam has passed',
              style: TextStyle(color: Colors.white70),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTimeUnit('${difference.inDays}', 'Days'),
                SizedBox(width: 16),
                _buildTimeUnit('${difference.inHours % 24}', 'Hours'),
                SizedBox(width: 16),
                _buildTimeUnit('${difference.inMinutes % 60}', 'Minutes'),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTimeUnit(String value, String unit) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          unit,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}