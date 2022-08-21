import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:royaltouch/bloc/make_appointments_bloc/appointments_bloc.dart';
import 'package:royaltouch/firebase/models.dart';
import 'package:royaltouch/widgets/buttons.dart';
import 'package:royaltouch/config/colors.dart';

Widget dateChip(
  BuildContext context, {
  @required DateTime date,
  @required MakeAppointmentsState state,
  @required MakeAppointmentsBloc bloc,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0).copyWith(left: onlyHorizontal.left),
    child: RaisedButton(
      onPressed: state.technician == null
          ? null
          : () => bloc.add(
                OnFetchFreeBusy(
                  technician: state.technician,
                  selectedDate: date,
                ),
              ),
      elevation: 0.0,
      color: state.selectedDate == date ? Theme.of(context).primaryColor : null,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Text(
          DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY).format(date),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: state.selectedDate == date
                ? Theme.of(context).canvasColor
                : Colors.black,
          ),
        ),
      ),
    ),
  );
}

Widget technicianDropdown({
  @required MakeAppointmentsState state,
  @required MakeAppointmentsBloc bloc,
  @required Function(Technician technician) onChanged,
}) {
  return DropdownButton<Technician>(
    underline: Container(),
    hint: const Align(
      child: Text('Choose Location :'),
      alignment: Alignment.centerLeft,
    ),
    icon: const Center(child: Icon(Icons.location_on, color: statusBarColor)),
    selectedItemBuilder: (_) => bloc.technicians
        .map<Widget>(
          (technician) => Align(
            alignment: Alignment.centerLeft,
            child: Text.rich(
              //Remove according to design
              TextSpan(
                text: 'Location : ',
                style: const TextStyle(fontWeight: FontWeight.w400),
                children: [
                  TextSpan(
                    text: technician.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList(),
    items: bloc.technicians
        .map<DropdownMenuItem<Technician>>(
          (technician) => DropdownMenuItem<Technician>(
            child: Text(technician.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            value: technician,
          ),
        )
        .toList(),
    isExpanded: true,
    onChanged: onChanged,
    value: state.technician,
    dropdownColor: white,
    focusColor: bluePrimary,
    // onTap: ,
  );
}
