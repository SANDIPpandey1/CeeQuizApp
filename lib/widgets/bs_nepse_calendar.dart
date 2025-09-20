import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';

/// NEPSE-like BS calendar that:
/// - shows month header (Latin BS month + BS year)
/// - shows AD span chip (e.g., Sep/Oct 2025)
/// - marks ONLY exam start dates with green dot + soft green background
class BsNepseCalendar extends StatefulWidget {
  /// BS dates to mark (format: yyyy-mm-dd)
  final Set<String> examStartDates;

  /// Optional light tints per BS date (format: yyyy-mm-dd -> Color)
  final Map<String, Color> tints;

  const BsNepseCalendar({
    super.key,
    this.examStartDates = const {},
    this.tints = const {},
  });

  @override
  State<BsNepseCalendar> createState() => _BsNepseCalendarState();
}

class _BsNepseCalendarState extends State<BsNepseCalendar> {
  NepaliDateTime _cursor = NepaliDateTime.now();

  static const _tileBorder = Color(0xFFE5E7EB);
  static const _todayBlue = Color(0xFF2563EB);
  static const _todayBlueText = Color(0xFF1D4ED8);
  static const _weekdayGray = Color(0xFF6B7280);
  static const _satRed = Color(0xFFDC2626);
  static const _adChipBg = Color(0xFFEFF6FF);
  static const _adChipBorder = Color(0xFFBFDBFE);
  static const _examSoftGreen = Color(0xFFEFFBF0); // light greenish

  @override
  Widget build(BuildContext context) {
    final first = NepaliDateTime(_cursor.year, _cursor.month, 1);
    final daysInMonth = _cursor.totalDays;
    final leadingEmpty = (first.weekday % 7); // 0..6 (Sun..Sat)
    final today = NepaliDateTime.now();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                _navBtn(Icons.chevron_left, () {
                  setState(() => _cursor = NepaliDateTime(_cursor.year, _cursor.month - 1, 1));
                }),
                Expanded(
                  child: Center(
                    child: Text(
                      '${_bsMonthLatin(_cursor.month)} ${NepaliUnicode.convert(_cursor.year.toString())}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                _navBtn(Icons.chevron_right, () {
                  setState(() => _cursor = NepaliDateTime(_cursor.year, _cursor.month + 1, 1));
                }),
              ],
            ),
            const SizedBox(height: 8),
            _adSpanChip(first, daysInMonth),
            const SizedBox(height: 10),

            // Weekdays
            Row(
              children: const ['आइत','सोम','मंगल','बुध','बिहि','शुक्र','शनि']
                  .map((w) => Expanded(
                        child: Center(
                          child: Text(
                            w,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: w == 'शनि' ? _satRed : _weekdayGray,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 8),

            // Calendar Grid (taller cells to avoid overlap)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 0.85, // <- more vertical space; prevents digit overlap
              ),
              itemCount: leadingEmpty + daysInMonth,
              itemBuilder: (_, i) {
                if (i < leadingEmpty) return const SizedBox.shrink();

                final day = i - leadingEmpty + 1;
                final bs = NepaliDateTime(_cursor.year, _cursor.month, day);
                final ad = bs.toDateTime();

                final key = _key(bs);
                final isToday = (bs.year == today.year && bs.month == today.month && bs.day == today.day);
                final isExamStart = widget.examStartDates.contains(key);

                // background priority: exam green > tint map > white
                final bg = isExamStart
                    ? _examSoftGreen
                    : (widget.tints[key] ?? Colors.white);

                return _dayTile(
                  bsText: NepaliUnicode.convert(day.toString()),
                  adText: DateFormat('d').format(ad),
                  bg: bg,
                  isToday: isToday,
                  isExamStart: isExamStart,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _adSpanChip(NepaliDateTime firstBs, int daysInMonth) {
    final startAd = firstBs.toDateTime();
    final endAd = NepaliDateTime(firstBs.year, firstBs.month, daysInMonth).toDateTime();
    final sameMonth = startAd.month == endAd.month;
    final text = sameMonth
        ? DateFormat('MMM yyyy').format(startAd)
        : '${DateFormat('MMM').format(startAd)}/${DateFormat('MMM yyyy').format(endAd)}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _adChipBg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _adChipBorder),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: _todayBlue)),
    );
  }

  Widget _navBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 22),
      ),
    );
  }

  Widget _dayTile({
    required String bsText,
    required String adText,
    required Color bg,
    required bool isToday,
    required bool isExamStart,
  }) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isToday ? _todayBlue : _tileBorder, width: isToday ? 2 : 1),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.035), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // BS numeral (center, slightly up)
          Align(
            alignment: const Alignment(0, -0.15),
            child: Text(
              bsText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                height: 1.0,
                color: isToday ? _todayBlueText : Colors.black87,
              ),
            ),
          ),
          // AD numeral (bottom-center)
          const Positioned(
            bottom: 6,
            left: 0,
            right: 0,
            child: _AdDay(),
          ),
          // supply AD text through InheritedWidget-ish hack: just replace with a builder
          // Simpler: overlay a second Text at bottom each time:
          Positioned(
            bottom: 6,
            left: 0,
            right: 0,
            child: Text(
              adText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                height: 1.0,
                color: _weekdayGray,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Exam start dot
          if (isExamStart)
            const Positioned(
              top: 6,
              right: 6,
              child: _GreenDot(),
            ),
        ],
      ),
    );
  }

  String _key(NepaliDateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _bsMonthLatin(int m) => const [
        'Baishakh','Jestha','Ashadh','Shrawan','Bhadra','Ashwin',
        'Kartik','Mangsir','Poush','Magh','Falgun','Chaitra',
      ][m - 1];
}

class _GreenDot extends StatelessWidget {
  const _GreenDot();
  @override
  Widget build(BuildContext context) {
    return Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle));
  }
}

class _AdDay extends StatelessWidget {
  const _AdDay();
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
