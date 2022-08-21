import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:royaltouch/auto_gen_models/cal_freebusy.dart';
import 'package:royaltouch/auto_gen_models/event_req.dart';
import 'package:royaltouch/bloc/make_appointments_bloc/appointments_bloc.dart';
import 'package:royaltouch/config/routes.dart';
import 'package:royaltouch/firebase/models.dart';
import 'package:royaltouch/pages/makeAppointments/appointments_scaffold.dart';
import 'package:royaltouch/pages/makeAppointments/appointments_widgets.dart';
import 'package:royaltouch/utils/appointments.dart';
import 'package:royaltouch/utils/double_time_to_duration.dart';
import 'package:royaltouch/widgets/buttons.dart';
import 'package:royaltouch/widgets/scaffold.dart';
import 'package:royaltouch/widgets/service_details.dart';

class MakeAppointmentPage extends StatefulWidget {
  @override
  _MakeAppointmentPageState createState() => _MakeAppointmentPageState();
}

class _MakeAppointmentPageState extends State<MakeAppointmentPage> {
  int busyCount = 0;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MakeAppointmentsBloc>(context);

    return MainScaffold(
      body: BlocConsumer<MakeAppointmentsBloc, MakeAppointmentsState>(
        listener: (context, state) {},
        builder: (context, state) {
          busyCount = 0;
          return Stack(
            children: [
              AppointmentsScaffold(
                bloc.service,
                <Widget>[
                  const SizedBox(height: 10.0),
                  serviceDetails(bloc.service, asTitle: true),
                  serviceDesc(bloc.service),
                  const Divider(),
                  Padding(
                    padding: onlyHorizontal,
                    child: technicianDropdown(
                      state: state,
                      bloc: bloc,
                      onChanged: (Technician technician) =>
                          bloc.add(OnChangeCalendar(technician)),
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: bothHorAndVertical,
                    child: Text('Choose Date :',
                        style: Theme.of(context).textTheme.subtitle1),
                  ),
                  Container(
                    height: size(context).height * 0.07,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) => dateChip(
                        context,
                        date: getDateWithStartTime(initialSelectedDate)
                            .add(Duration(days: index)),
                        state: state,
                        bloc: bloc,
                      ),
                      itemCount: 60,
                    ),
                  ),
                  ...!(state is Fetching) &&
                          (state.technician != null &&
                              state.selectedDate != null)
                      ? [
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5.0),
                            child: Text(
                              'Choose Time :',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              final List<Busy> busyList = state
                                  .calendarFreeBusy
                                  .calendars
                                  .busyMap[state.technician.calendarId]
                                  .busyList;
                              final DateTime startTimeLocal = state.selectedDate
                                  .add(const Duration(hours: 8));
                              // final TZDateTime startTime = TZDateTime.from(
                              //     startTimeLocal,
                              //     tz.getLocation(timezoneNewYork));
                              final DateTime serviceTimeStartLocal =
                                  startTimeLocal
                                      .add(Duration(minutes: 30 * index));
                              // final TZDateTime serviceTimeStart =
                              //     TZDateTime.from(serviceStartTimeLocal,
                              //         tz.getLocation(timezoneNewYork));
                              final DateTime serviceTimeEndLocal =
                                  serviceTimeStartLocal.add(
                                      serviceTimeToDuration(bloc.service.time));
                              // final TZDateTime serviceTimeEnd = TZDateTime.from(
                              //     serviceTimeEndLocal,
                              //     tz.getLocation(timezoneNewYork));

                              final bool busy = checkIfTimeSlotIsBusy(
                                  serviceTimeStartLocal,
                                  serviceTimeEndLocal,
                                  busyList);

                              if (busy) {
                                busyCount += 1;
                                if (busyCount == 14) {
                                  return const Center(
                                      child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text('No free slots for this day'),
                                  ));
                                }
                              }
                              final EventDetailsReq eventDetailsReq =
                                  EventDetailsReq(
                                description: 'From App',
                                end: EventTimeInfo(
                                  dateTime:
                                      serviceTimeEndLocal.toIso8601String(),
                                  timeZone: timezoneNewYork,
                                ),
                                start: EventTimeInfo(
                                  dateTime:
                                      serviceTimeStartLocal.toIso8601String(),
                                  timeZone: timezoneNewYork,
                                ),
                                location: timezoneNewYork,
                                summary: 'From App',
                                sendNotification: true,
                              );
                              return busy
                                  ? Container()
                                  : RadioListTile<int>(
                                      title: Text(
                                        onlyTime.format(serviceTimeStartLocal) +
                                            ' - ' +
                                            onlyTime
                                                .format(serviceTimeEndLocal),
                                      ),
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                      groupValue: state.selectedTimeSlotIndex,
                                      onChanged: (_) =>
                                          bloc.add(OnSelectTimeSlot(
                                              index,
                                              eventDetailsReq,
                                              TimeSlot(
                                                Timestamp.fromDate(
                                                    serviceTimeStartLocal),
                                                Timestamp.fromDate(
                                                    serviceTimeEndLocal),
                                              ))),
                                      value: index,
                                    );
                            },
                            itemCount: 14,
                          ),
                          const SizedBox(
                              height: kBottomNavigationBarHeight * 1.5),
                        ]
                      : [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ],
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Material(
                  elevation: 20.0,
                  child: Container(
                    color: Colors.white,
                    height: kBottomNavigationBarHeight * 1.5,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: kBottomNavigationBarHeight * 0.35),
                      child: FlatButton(
                        color: state.selectedTimeSlotIndex == null
                            ? Colors.white
                            : Theme.of(context).primaryColor,
                        disabledColor: Colors.grey,
                        shape:
                            RoundedRectangleBorder(borderRadius: borderRadius),
                        onPressed: state.selectedTimeSlotIndex == null
                            ? null
                            : () {
                                Navigator.of(context).pushNamed(
                                  AppRouter.appointmentConfirmation,
                                  arguments: PaymentConfirmationModel(
                                    services: bloc.service,
                                    state: state,
                                  ),
                                );
                                // bloc.add(OnAddEvent());
                              },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Continue'.toUpperCase(),
                              style: TextStyle(
                                color: state.selectedTimeSlotIndex == null
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
