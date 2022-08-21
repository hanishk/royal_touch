import 'package:timezone/standalone.dart';
import 'package:timezone/timezone.dart' as tz;

String timezoneNewYork = 'America/New_York';

class CalendarFreeBusy {
  CalendarFreeBusy({this.kind, this.timeMin, this.timeMax, this.calendars});

  CalendarFreeBusy.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    timeMin = json['timeMin'];
    timeMax = json['timeMax'];
    calendars = json['calendars'] != null
        ? Calendars.fromJson(json['calendars'])
        : null;
  }
  String kind;
  String timeMin;
  String timeMax;
  Calendars calendars;
}

class Calendars {
  Calendars({this.busyMap});
  Calendars.fromJson(Map<String, dynamic> json) {
    for (String key in json.keys) {
      busyMap[key] = BusyList.fromJson(json[key]);
    }
  }
  Map<String, BusyList> busyMap = {};
}

class BusyList {
  BusyList({this.busyList});

  BusyList.fromJson(Map<String, dynamic> json) {
    for (Object obj in json['busy']) {
      busyList.add(Busy.fromJson(obj));
    }
  }
  List<Busy> busyList = [];
}

class Busy {
  Busy({this.start, this.end});

  Busy.fromJson(Map<String, dynamic> json) {
    final DateTime s = DateTime.parse(json['start']);
    final DateTime e = DateTime.parse(json['end']);
    // start = s.toLocal();
    // end = e.toLocal();
    start = TZDateTime.from(s, tz.getLocation(timezoneNewYork));
    end = TZDateTime.from(e, tz.getLocation(timezoneNewYork));
  }
  // DateTime start, end;
  TZDateTime start;
  TZDateTime end;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start'] = start;
    data['end'] = end;
    return data;
  }
}
