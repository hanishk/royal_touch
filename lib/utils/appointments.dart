import 'package:intl/intl.dart';
import 'package:royaltouch/auto_gen_models/cal_freebusy.dart';

final DateTime initialSelectedDate =
    DateTime.now().add(const Duration(days: 2));

final DateFormat onlyTime = DateFormat('hh:mm a');

DateTime getDateWithStartTime(DateTime dateTime) =>
    DateTime(dateTime.year, dateTime.month, dateTime.day);

bool checkIfTimeSlotIsBusy(
    DateTime serviceTimeStart, DateTime serviceTimeEnd, List<Busy> busyList) {
  for (Busy busy in busyList) {
    if (busy.start.isAtSameMomentAs(serviceTimeStart) ||
        busy.end.isAtSameMomentAs(serviceTimeEnd) ||
        (busy.start.isAfter(serviceTimeStart) &&
            busy.start.isBefore(serviceTimeEnd)) ||
        (busy.end.isAfter(serviceTimeStart) &&
            busy.end.isBefore(serviceTimeEnd))) {
      return true;
    }
    if (busy.start.isBefore(serviceTimeStart) &&
        busy.end.isAfter(serviceTimeEnd)) {
      return true;
    }
  }
  return false;
}
