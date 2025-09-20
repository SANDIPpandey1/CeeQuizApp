import 'package:flutter/material.dart';
import 'package:nepali_utils/nepali_utils.dart';
import '../widgets/bs_nepse_calendar.dart';
import '../widgets/exam_countdown_list.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Exam list (BS)
    final exams = <ExamItem>[
      const ExamItem(
        program: 'MBBS',
        bsDate: '2082/07/15',
        timeRange: '11:00 AM – 2:00 PM',
      ),
      const ExamItem(
        program: 'BDS',
        bsDate: '2082/07/16',
        timeRange: '11:00 AM – 2:00 PM',
      ),
      const ExamItem(
        program: 'BSc Nursing / BSc Midwifery, BASLP, B Perfusion Technology',
        bsDate: '2082/07/17',
        timeRange: '11:00 AM – 2:00 PM',
      ),
      const ExamItem(
        program:
            'BAMS, BNS/BMS, BSc MLT, BSc MIT, BSc Radiotherapy Technology, BPT, B Pharm, B Optometry',
        bsDate: '2082/07/18',
        timeRange: '11:00 AM – 2:00 PM',
      ),
      const ExamItem(
        program: 'BPH',
        bsDate: '2082/07/19',
        timeRange: '11:00 AM – 2:00 PM',
      ),
    ];

    // Build BS start-date markers for calendar
    final startDates =
        exams.map((e) {
          final p = e.bsDate.split('/');
          final bs = NepaliDateTime(
            int.parse(p[0]),
            int.parse(p[1]),
            int.parse(p[2]),
          );
          return '${bs.year.toString().padLeft(4, '0')}-${bs.month.toString().padLeft(2, '0')}-${bs.day.toString().padLeft(2, '0')}';
        }).toSet();

    return Container(
      color: const Color(0xFFF7F7FB),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'CEE Calendar',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            Text(
              'Important dates & countdown',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),

            // Notice
            const _NoticeCard(
              title: 'Notice',
              message:
                  'All dates shown are in Bikram Sambat (BS). Best of luck!',
            ),
            const SizedBox(height: 16),

            // Calendar (ONLY start dates marked; soft green + green dot)
            BsNepseCalendar(
              examStartDates: startDates,
              // You can also tint arbitrary days here if you want:
              // tints: {'2082-07-21': const Color(0xFFFFEEF0), '2082-07-23': const Color(0xFFEFFBF0)},
            ),

            const SizedBox(height: 20),

            // Live countdowns
            ExamCountdownList(items: exams),
          ],
        ),
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  final String title;
  final String message;
  const _NoticeCard({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF7E6), Color(0xFFFFFBF2)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFE6B3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.campaign, color: Color(0xFFFB923C)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: Color(0xFFEA580C),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
