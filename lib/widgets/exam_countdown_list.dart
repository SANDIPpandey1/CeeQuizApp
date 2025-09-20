import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nepali_utils/nepali_utils.dart';

class ExamItem {
  final String program;
  final String bsDate;    // "2082/07/15"
  final String timeRange; // "11:00 AM – 2:00 PM"
  const ExamItem({required this.program, required this.bsDate, required this.timeRange});
}

class ExamCountdownList extends StatefulWidget {
  final List<ExamItem> items;
  const ExamCountdownList({super.key, required this.items});

  @override
  State<ExamCountdownList> createState() => _ExamCountdownListState();
}

class _ExamCountdownListState extends State<ExamCountdownList> {
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }
  @override
  void dispose() { _timer.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Text('Exam Countdowns', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          ),
          ...widget.items.map(_tile).toList(),
        ],
      ),
    );
  }

  Widget _tile(ExamItem item) {
    final now = DateTime.now();

    // Parse BS date
    final p = item.bsDate.split('/');
    final y = int.parse(p[0]), m = int.parse(p[1]), d = int.parse(p[2]);

    // Parse time range
    final parts = item.timeRange.split('–');
    final start = _parseTime(parts.first.trim());
    final end = _parseTime(parts.last.trim());

    final bsStart = NepaliDateTime(y, m, d, start.$1, start.$2);
    final bsEnd = NepaliDateTime(y, m, d, end.$1, end.$2);

    final adStart = bsStart.toDateTime();
    final adEnd = bsEnd.toDateTime();

    String badge; Color color;
    if (now.isBefore(adStart)) {
      badge = _fmt(adStart.difference(now)); color = Colors.blue;
    } else if (now.isAfter(adEnd)) {
      badge = 'Completed'; color = Colors.grey;
    } else {
      badge = 'LIVE • ${_fmt(adEnd.difference(now))} left'; color = Colors.red;
    }

    final prettyBs = NepaliUnicode.convert(
      NepaliDateFormat('yyyy/MM/dd (EEE)').format(NepaliDateTime(y, m, d)),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey[200]!, width: 0.6))),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.schedule, color: Colors.blue[600]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.program, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text('$prettyBs • ${item.timeRange}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ]),
          ),
          _badge(badge, color),
        ],
      ),
    );
  }

  (int,int) _parseTime(String t) {
    final seg = t.split(' ');
    final hm = seg[0]; final ap = seg[1].toUpperCase();
    final parts = hm.split(':');
    int h = int.parse(parts[0]); final m = int.parse(parts[1]);
    if (ap == 'AM') { if (h == 12) h = 0; } else { if (h != 12) h += 12; }
    return (h, m);
  }

  String _two(int v) => v.toString().padLeft(2, '0');
  String _fmt(Duration d) {
    final days = d.inDays, hrs = d.inHours % 24, mins = d.inMinutes % 60;
    if (days > 0) return '${days}d ${_two(hrs)}h ${_two(mins)}m';
    if (d.inHours > 0) return '${_two(d.inHours)}h ${_two(mins)}m';
    return '${_two(d.inMinutes)}m ${_two(d.inSeconds % 60)}s';
  }

  Widget _badge(String text, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: color.withOpacity(0.08),
      border: Border.all(color: color),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12)),
  );
}
