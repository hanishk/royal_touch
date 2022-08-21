class EventDetailsReq {
  EventDetailsReq(
      {this.summary,
      this.location,
      this.description,
      this.start,
      this.end,
      this.sendNotification});

  EventDetailsReq.fromJson(Map<String, dynamic> json) {
    summary = json['summary'];
    location = json['location'];
    description = json['description'];
    sendNotification = json['sendNotification'] ?? false;
    start =
        json['start'] != null ? EventTimeInfo.fromJson(json['start']) : null;
    end = json['end'] != null ? EventTimeInfo.fromJson(json['end']) : null;
  }
  String summary;
  String location;
  String description;
  EventTimeInfo start;
  EventTimeInfo end;
  bool sendNotification;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['summary'] = summary;
    data['location'] = location;
    data['description'] = description;
    data['sendNotification'] = sendNotification ?? false;
    if (start != null) {
      data['start'] = start.toJson();
    }
    if (end != null) {
      data['end'] = end.toJson();
    }
    return data;
  }
}

class EventTimeInfo {
  EventTimeInfo({this.dateTime, this.timeZone});

  EventTimeInfo.fromJson(Map<String, dynamic> json) {
    dateTime = json['dateTime'];
    timeZone = json['timeZone'];
  }
  String dateTime;
  String timeZone;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dateTime'] = dateTime;
    data['timeZone'] = timeZone;
    return data;
  }
}
