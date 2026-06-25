import 'package:intl/intl.dart';

final DateFormat _monthFormat = DateFormat('MMMM');
final DateFormat _timeFormat = DateFormat('hh:mm a');

String getGreetingMessage() {
  final hour = DateTime.now().hour;

  if (hour >= 12 && hour < 16) {
    return 'Good Afternoon ';
  } else if (hour >= 16 && hour < 20) {
    return 'Good Evening ';
  } else {
    return 'Good Morning ';
  }
}

String getCurrentDate() {
  final now = DateTime.now();
  final month = _monthFormat.format(now);
  final day = now.day;
  final year = now.year;

  return '$month $day, $year';
}

String getCurrentTime() {
  final now = DateTime.now();
  return _timeFormat.format(now);
}
