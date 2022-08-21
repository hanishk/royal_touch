import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:http/http.dart' as http;
import 'package:royaltouch/api/api_const.dart';
import 'package:royaltouch/auto_gen_models/cal_freebusy.dart';
import 'package:royaltouch/auto_gen_models/event_req.dart';
import 'package:royaltouch/auto_gen_models/event_res.dart';

class ApiCalls {
  static Future<CalendarFreeBusy> getFreeBusy(
      {@required AutoRefreshingAuthClient httpClient,
      @required String calendarId,
      @required String timeMin,
      @required String timeMax}) async {
    CalendarFreeBusy calendarFreeBusy;

    final body = {
      'items': [
        {'id': calendarId}
      ],
      'timeMin': timeMin,
      'timeMax': timeMax,
    };
    await httpClient
        .post(ApiConst.calendarFreeBusy, body: jsonEncode(body))
        .then((http.Response response) {
      calendarFreeBusy = CalendarFreeBusy.fromJson(jsonDecode(response.body));
    });
    return calendarFreeBusy;
  }

  static Future<EventDetailsRes> addEventToCalendar({
    @required AutoRefreshingAuthClient httpClient,
    @required String calendarId,
    @required EventDetailsReq eventDetails,
  }) async {
    EventDetailsRes res;

    await httpClient
        .post(
      ApiConst.calendarInsertEvents(calendarId),
      body: jsonEncode(eventDetails.toJson()),
    )
        .then((http.Response response) {
      res = EventDetailsRes.fromJson(jsonDecode(response.body));
    });
    return res;
  }
}
