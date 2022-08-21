class EventDetailsRes {
  EventDetailsRes(
      {this.kind,
      this.etag,
      this.summary,
      this.updated,
      this.timeZone,
      this.accessRole,
      this.nextSyncToken,
      this.items});

  EventDetailsRes.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    etag = json['etag'];
    summary = json['summary'];
    updated = json['updated'];
    timeZone = json['timeZone'];
    accessRole = json['accessRole'];
    nextSyncToken = json['nextSyncToken'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((dynamic v) {
        items.add(Items.fromJson(v));
      });
    }
  }
  String kind;
  String etag;
  String summary;
  String updated;
  String timeZone;
  String accessRole;
  String nextSyncToken;
  List<Items> items;
}

class Items {
  Items(
      {this.kind,
      this.etag,
      this.id,
      this.status,
      this.htmlLink,
      this.created,
      this.updated,
      this.summary,
      this.description,
      this.location,
      this.creator,
      this.organizer,
      this.start,
      this.end,
      this.recurrence,
      this.iCalUID,
      this.sequence,
      this.reminders,
      this.recurringEventId,
      this.originalStartTime});

  Items.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    etag = json['etag'];
    id = json['id'];
    status = json['status'];
    htmlLink = json['htmlLink'];
    created = json['created'];
    updated = json['updated'];
    summary = json['summary'];
    description = json['description'];
    location = json['location'];
    creator =
        json['creator'] != null ? Creator.fromJson(json['creator']) : null;
    organizer = json['organizer'] != null
        ? Organizer.fromJson(json['organizer'])
        : null;
    start = json['start'] != null ? Start.fromJson(json['start']) : null;
    end = json['end'] != null ? Start.fromJson(json['end']) : null;
    recurrence =
        json['recurrence'] != null ? json['recurrence'].cast<String>() : null;
    iCalUID = json['iCalUID'];
    sequence = json['sequence'];
    reminders = json['reminders'] != null
        ? Reminders.fromJson(json['reminders'])
        : null;
    recurringEventId = json['recurringEventId'];
    originalStartTime = json['originalStartTime'] != null
        ? Start.fromJson(json['originalStartTime'])
        : null;
  }
  String kind;
  String etag;
  String id;
  String status;
  String htmlLink;
  String created;
  String updated;
  String summary;
  String description;
  String location;
  Creator creator;
  Organizer organizer;
  Start start;
  Start end;
  List<String> recurrence;
  String iCalUID;
  int sequence;
  Reminders reminders;
  String recurringEventId;
  Start originalStartTime;
}

class Creator {
  Creator({this.email});

  Creator.fromJson(Map<String, dynamic> json) {
    email = json['email'];
  }
  String email;
}

class Organizer {
  Organizer({this.email, this.displayName, this.self});

  Organizer.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    displayName = json['displayName'];
    self = json['self'];
  }
  String email;
  String displayName;
  bool self;
}

class Start {
  Start({this.dateTime, this.timeZone});

  Start.fromJson(Map<String, dynamic> json) {
    dateTime = json['dateTime'];
    timeZone = json['timeZone'];
  }
  String dateTime;
  String timeZone;
}

class Reminders {
  Reminders({this.useDefault});

  Reminders.fromJson(Map<String, dynamic> json) {
    useDefault = json['useDefault'];
  }
  bool useDefault;
}
