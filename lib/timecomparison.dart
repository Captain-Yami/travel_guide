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


// extracting end time


String extractEndTime(String timeRange) {
  // Split the time range using the delimiter " - "
  List<String> times = timeRange.split(" - ");
  
  // Return the second part, which is the end time
  return times.length > 1 ? times[1].trim() : '';
}
