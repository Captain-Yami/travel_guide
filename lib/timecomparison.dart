import 'package:intl/intl.dart';

bool isTimeInRange(String timeRange, String exactTime) {
  final parts = timeRange.split(" - ");
  if (parts.length != 2) return false;

  String startTimeStr = parts[0];
  String endTimeStr = parts[1];

  final timeFormat = DateFormat("h:mm a");
  DateTime startTime = timeFormat.parse(startTimeStr);
  DateTime endTime = timeFormat.parse(endTimeStr);
  DateTime exactTimeDt = timeFormat.parse(exactTime);

  return exactTimeDt.isAfter(startTime) && exactTimeDt.isBefore(endTime) ||
      exactTimeDt.isAtSameMomentAs(startTime) ||
      exactTimeDt.isAtSameMomentAs(endTime);
}
