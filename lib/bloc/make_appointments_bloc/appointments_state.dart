part of 'appointments_bloc.dart';

class MakeAppointmentsState {
  MakeAppointmentsState({
    this.calendarFreeBusy,
    this.selectedDate,
    this.technician,
    this.eventDetailsReq,
    this.selectedTimeSlotIndex,
    this.timeSlot,
  });
  Technician technician;
  CalendarFreeBusy calendarFreeBusy;
  DateTime selectedDate;
  EventDetailsReq eventDetailsReq;
  int selectedTimeSlotIndex;
  TimeSlot timeSlot;
}

class Fetching extends MakeAppointmentsState {}
