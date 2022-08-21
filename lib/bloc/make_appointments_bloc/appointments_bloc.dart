import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:meta/meta.dart';
import 'package:royaltouch/api/api_calls.dart';
import 'package:royaltouch/auto_gen_models/cal_freebusy.dart';
import 'package:royaltouch/auto_gen_models/event_req.dart';
import 'package:royaltouch/creds/credentials.dart';
import 'package:royaltouch/firebase/app_cloud_firestore.dart';
import 'package:royaltouch/firebase/app_firebase_auth.dart';
import 'package:royaltouch/firebase/models.dart';
import 'package:royaltouch/utils/appointments.dart';

part 'appointments_event.dart';
part 'appointments_state.dart';

class MakeAppointmentsBloc
    extends Bloc<MakeAppointmentsEvent, MakeAppointmentsState> {
  MakeAppointmentsBloc(this.service) : super(MakeAppointmentsState()) {
    getAllTech();
  }
  final AllServices service;
  List<Technician> technicians = [];

  @override
  Stream<MakeAppointmentsState> mapEventToState(
    MakeAppointmentsEvent event,
  ) async* {
    if (event is OnFetchFreeBusy) {
      yield* getFreeBusy(event);
    } else if (event is OnChangeCalendar) {
      yield* getFreeBusy(OnFetchFreeBusy(
        technician: event.technician,
        selectedDate: state.selectedDate,
      ));
    } else if (event is OnSelectTimeSlot) {
      yield MakeAppointmentsState(
        calendarFreeBusy: state.calendarFreeBusy,
        eventDetailsReq: event.eventDetails,
        selectedTimeSlotIndex: event.selectedIndex,
        selectedDate: state.selectedDate,
        technician: state.technician,
        timeSlot: event.timeSlot,
      );
    }
  }

  Stream<MakeAppointmentsState> getFreeBusy(OnFetchFreeBusy event) async* {
    yield Fetching();
    final httpClient = await clientViaServiceAccount(
      credentials,
      CalendarEventsScope,
    );
    final CalendarFreeBusy calendarFreeBusy = await ApiCalls.getFreeBusy(
        httpClient: httpClient,
        calendarId: event.technician.calendarId,
        timeMin: event.selectedDate.toIso8601String() + 'Z',
        timeMax:
            event.selectedDate.add(const Duration(days: 1)).toIso8601String() +
                'Z');
    yield MakeAppointmentsState(
      calendarFreeBusy: calendarFreeBusy,
      selectedDate: event.selectedDate,
      technician: event.technician,
    );
  }

  void getAllTech() async {
    final List<Technician> listTech = await AppCloudFirestore.getAllTech();
    technicians = listTech ?? [];
    await AppCloudFirestore.getUserDetails(
            AppFirebaseAuth.auth.currentUser.email)
        .then((UserDetails userDetails) async {
      final Technician technician =
          await AppCloudFirestore.getTechByPath(userDetails.location);
      add(OnFetchFreeBusy(
        technician: technicians
            .where((element) => element.docId == technician.docId)
            .first,
        selectedDate: getDateWithStartTime(initialSelectedDate),
      ));
    });
  }
}
