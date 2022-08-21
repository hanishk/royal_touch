import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:royaltouch/bloc/payment_bloc/payment_bloc.dart';
import 'package:royaltouch/firebase/app_cloud_firestore.dart';
import 'package:royaltouch/firebase/app_firebase_auth.dart';
import 'package:royaltouch/firebase/models.dart';
import 'package:royaltouch/pages/appointments/model.dart';
import 'package:royaltouch/pages/payment/widget.dart';
import 'package:royaltouch/utils/appointments.dart';
import 'package:royaltouch/widgets/appbar.dart';
import 'package:royaltouch/widgets/buttons.dart';
import 'package:royaltouch/widgets/scaffold.dart';
import 'package:royaltouch/widgets/service_details.dart';
import 'package:square_in_app_payments/in_app_payments.dart' as iap;
import 'package:square_in_app_payments/models.dart' as iap;

class AppointmentsPage extends StatefulWidget {
  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  UserDetails userDetails;

  @override
  void initState() {
    super.initState();
    AppCloudFirestore.getUserDetails(AppFirebaseAuth.auth.currentUser.email)
        .then((UserDetails value) {
      setState(() => userDetails = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final PaymentBloc paymentBloc = BlocProvider.of<PaymentBloc>(context);
    final String path = AppCloudFirestore.allUsers +
        '/' +
        AppFirebaseAuth.auth.currentUser.email +
        '/appointments';

    Widget getTrailing(AppointmentModel model, PaymentState state) {
      final String status = model.status;
      if (status == 'PAID_FULL') {
        return null;
      } else if (userDetails == null) {
        return const Center(child: CircularProgressIndicator());
      } else if (userDetails != null &&
          userDetails.sqCardOnFile != null &&
          userDetails.sqCardOnFile.card != null) {
        return payUsingSavedCard(context, userDetails: userDetails, onPay: () {
          paymentBloc.add(
            OnStartCompleteRemainingPayment(
              sourceId: userDetails.sqCardOnFile.card.id,
              amount: model.service.price.toInt() -
                  model.initialPayment.paid.toInt(),
              appointmentPath: model.docPath,
              userDetails: userDetails,
            ),
          );
        });
      } else {
        return Container(
          width: double.infinity,
          child: FlatButton(
            color: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
            child: Text(
              'PAY UP',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).canvasColor),
            ),
            onPressed: () {
              // print(model.docPath);
              iap.InAppPayments.startCardEntryFlow(
                collectPostalCode: true,
                onCardEntryCancel: () {
                  // TODO(Aman-Malhote): Ask Graham
                  // what happens if the card entry flow was cancelled
                  paymentBloc.add(OnCancelCardEntryFlow());
                },
                onCardNonceRequestSuccess: (iap.CardDetails cardDetails) =>
                    paymentBloc.add(
                  OnStartCompleteRemainingPayment(
                    sourceId: cardDetails.nonce,
                    amount: model.service.price.toInt() -
                        model.initialPayment.paid.toInt(),
                    appointmentPath: model.docPath,
                    userDetails: userDetails,
                  ),
                ),
              );
            },
          ),
        );
      }
    }

    Color getColor(String status) {
      if (status == 'PAID_FULL') {
        return Colors.green;
      } else if (status == 'PENDING') {
        return Colors.red;
      } else {
        return Colors.red;
      }
    }

    String getStatusText(AppointmentModel model) {
      if (model.status == 'PAID_FULL') {
        return 'Payment Completed';
      } else if (model.status == 'PENDING') {
        return 'Pending payment \$${model.service.price.toInt() - model.initialPayment.paid.toInt()}';
      } else {
        return model.status;
      }
    }

    return BlocConsumer<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state is CancelCardEntryFlow) {
          // card entry cancelled
          // InAppPayments.showCardNonceProcessingError();
        } else if (state is CompleteCardEntryFlow) {
          if (userDetails != null &&
              userDetails.sqCardOnFile != null &&
              userDetails.sqCardOnFile.card != null) {
            Flushbar<void>(
              messageText: const Text(
                'Payment successful',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              flushbarStyle: FlushbarStyle.GROUNDED,
              duration: const Duration(seconds: 4),
              backgroundColor: Colors.green,
            ).show(context);
          } else {
            iap.InAppPayments.completeCardEntry(
              onCardEntryComplete: () {
                Flushbar<void>(
                  messageText: const Text(
                    'Payment successful',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  flushbarStyle: FlushbarStyle.GROUNDED,
                  duration: const Duration(seconds: 4),
                  backgroundColor: Colors.green,
                ).show(context);
              },
            );
          }
        } else if (state is FailureCardEntryFlow) {
          iap.InAppPayments.showCardNonceProcessingError(state.errorMsg);
        }
      },
      builder: (context, state) {
        return MainScaffold(
          appBar: mainAppBar(context, title: 'Appointments'),
          body: state is Processing
              ? const Center(child: CircularProgressIndicator())
              : StreamBuilder<QuerySnapshot>(
                  stream: AppCloudFirestore.getAppointmentsStream(path),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    List<AppointmentModel> list =
                        snapshot.data.docs.map<AppointmentModel>((e) {
                      {
                        final Map map = e.data();
                        map.addAll(
                            <String, dynamic>{'doc_path': path + '/' + e.id});
                        return AppointmentModel.fromJson(map);
                      }
                    }).toList();
                    list = list
                        .where((element) => element.createdAt != null)
                        .toList();
                    list.sort((a, b) =>
                        a.createdAt.toDate().compareTo(b.createdAt.toDate()));

                    list = list.reversed.toList();
                    if (list.isEmpty) {
                      return const Center(
                        child: Text('No previous appointments.'),
                      );
                    }
                    return ListView.builder(
                      itemBuilder: (c, i) {
                        final AppointmentModel model = list[i];
                        final String status = model.status;
                        if (model.service == null) {
                          return Container();
                        }
                        final Widget trailing = getTrailing(model, state);
                        return Card(
                          elevation: 12.0,
                          shadowColor: Colors.black12,
                          margin: bothHorAndVertical,
                          shape: RoundedRectangleBorder(
                              borderRadius: borderRadius),
                          child: ListTile(
                            contentPadding: bothHorAndVertical,
                            title: Text(
                              model.service.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18
                                  // color: Theme.of(context).primaryColor,
                                  ),
                            ),
                            dense: false,
                            visualDensity: VisualDensity.standard,
                            isThreeLine: true,
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(children: [
                                    TextSpan(
                                      text: getServiceTimeText(
                                          model.service.time),
                                    ),
                                    const TextSpan(
                                      text: ' | ',
                                    ),
                                    TextSpan(
                                      text:
                                          '\$' + model.service.price.toString(),
                                    )
                                  ]),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Booking time : ' +
                                      DateFormat('hh:mm aa DD-MM-yy')
                                          .format(model.createdAt.toDate())
                                          .toString(),
                                  style: const TextStyle(fontSize: 12.0),
                                ),
                                ListTile(
                                  visualDensity: VisualDensity.compact,
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    // 'Payment Status:',
                                    getStatusText(model),
                                    style: TextStyle(
                                      color: getColor(status),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                ExpansionTile(
                                  tilePadding: EdgeInsets.zero,
                                  title: const Text(
                                    'Tap for more details',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  children: [
                                    ListTile(
                                      visualDensity: VisualDensity.compact,
                                      contentPadding: EdgeInsets.zero,
                                      title: const Text(
                                        'Date:',
                                      ),
                                      subtitle: Text(
                                        DateFormat(DateFormat
                                                .YEAR_ABBR_MONTH_WEEKDAY_DAY)
                                            .format(model
                                                .appointmentDetails.date
                                                .toDate()),
                                      ),
                                    ),
                                    ListTile(
                                      visualDensity: VisualDensity.compact,
                                      contentPadding: EdgeInsets.zero,
                                      title: const Text(
                                        'Timeslot:',
                                      ),
                                      subtitle: Text(
                                        onlyTime.format(model.appointmentDetails
                                                .timeslot.startTime
                                                .toDate()) +
                                            ' - ' +
                                            onlyTime.format(model
                                                .appointmentDetails
                                                .timeslot
                                                .endTime
                                                .toDate()),
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  child:
                                      //  false ?
                                      trailing,
                                  // : Container(),
                                  alignment: Alignment.centerRight,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: list.length,
                    );
                  },
                ),
        );
      },
    );
  }
}
