part of 'appointments_bloc.dart';

@immutable
abstract class MakeAppointmentsEvent {}

class OnSelectDate extends MakeAppointmentsEvent {
  OnSelectDate(this.selectedDate);
  final DateTime selectedDate;
}

class OnFetchFreeBusy extends MakeAppointmentsEvent {
  OnFetchFreeBusy({this.technician, this.selectedDate});
  final Technician technician;
  final DateTime selectedDate;
}

class OnChangeCalendar extends MakeAppointmentsEvent {
  OnChangeCalendar(this.technician);
  final Technician technician;
}

class OnAddEvent extends MakeAppointmentsEvent {
  // OnAddEvent(this.eventDetails, this.technician);
  // final Technician technician;
  // final EventDetailsReq eventDetails;
}

class OnSelectTimeSlot extends MakeAppointmentsEvent {
  OnSelectTimeSlot(this.selectedIndex, this.eventDetails, this.timeSlot);
  final EventDetailsReq eventDetails;
  final TimeSlot timeSlot;
  final int selectedIndex;
}
