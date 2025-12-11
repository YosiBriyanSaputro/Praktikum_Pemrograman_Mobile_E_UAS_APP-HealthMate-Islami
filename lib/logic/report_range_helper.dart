import 'package:intl/intl.dart';

enum ReportRange { today, week, twoWeeks }

class ReportRangeHelper {
  static String startDate(ReportRange range) {
    final now = DateTime.now();
    late DateTime start;

    switch (range) {
      case ReportRange.today:
        start = DateTime(now.year, now.month, now.day);
        break;
      case ReportRange.week:
        start = now.subtract(const Duration(days: 6));
        break;
      case ReportRange.twoWeeks:
        start = now.subtract(const Duration(days: 13));
        break;
    }

    return DateFormat('yyyy-MM-dd').format(start);
  }

  static List<String> rangeDates(ReportRange range) {
    final now = DateTime.now();
    final start = DateTime.parse(startDate(range));

    final days = now.difference(start).inDays;
    final list = <String>[];

    for (int i = 0; i <= days; i++) {
      final d = start.add(Duration(days: i));
      list.add(DateFormat('yyyy-MM-dd').format(d));
    }
    return list;
  }
}
