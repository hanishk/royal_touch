import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_option/either_option.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:meta/meta.dart';
import 'package:royaltouch/api/api_calls.dart';
import 'package:royaltouch/creds/credentials.dart';
import 'package:royaltouch/firebase/app_cloud_firestore.dart';
import 'package:royaltouch/firebase/app_firebase_auth.dart';
import 'package:royaltouch/firebase/models.dart';
import 'package:royaltouch/pages/payment/models/create_customer_card_req.dart';
import 'package:royaltouch/pages/payment/models/create_pay_failure_res.dart';
import 'package:royaltouch/pages/payment/models/create_pay_success_res.dart';
import 'package:royaltouch/api/square_api.dart';
import 'package:square_in_app_payments/models.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(PaymentInitial());
  // : assert(model != null),

  // final PaymentConfirmationModel model;
  final int downPayment = 30;
  @override
  Stream<PaymentState> mapEventToState(
    PaymentEvent event,
  ) async* {
    if (event is OnStartCardEntryPaymentFlow) {
      yield* onStartCardEntryPaymentFlow(event);
    } else if (event is OnCancelCardEntryFlow) {
      yield CancelCardEntryFlow();
    } else if (event is OnSuccessCardEntryFlow) {
      yield* onSuccessCardEntryFlow(event);
    } else if (event is OnCompleteCardEntryPaymentFlow) {
      yield CompleteCardEntryFlow();
    } else if (event is OnAddEvent) {
      yield* addEvent(event);
    } else if (event is OnPaymentFailureFlow) {
      yield FailureCardEntryFlow(event.errorMsg);
    } else if (event is OnStartCompleteRemainingPayment) {
      yield* onRemainingPaymentSuccessCardEntryFlow(event);
    } else if (event is OnChargeCardOnFile) {
      yield* chargeCardOnFile(event);
    } else {
      PaymentInitial();
    }
  }

  Stream<PaymentState> chargeCardOnFile(OnChargeCardOnFile event) async* {
    yield Processing();
    final String appointmentsCollectionPath = AppCloudFirestore.allUsers +
        '/' +
        AppFirebaseAuth.auth.currentUser.email +
        '/appointments';
    final DocumentReference _appointmentDocRef =
        await AppCloudFirestore.makeNewDoc(appointmentsCollectionPath);
    final DocumentReference _paymentDocRef = await AppCloudFirestore.makeNewDoc(
        _appointmentDocRef.path + '/payments');
    await SquareApi()
        .makeCharge(
      userDetails: event.userDetails,
      amount: event.toPay,
      idempotencyKey: _paymentDocRef.id,
      sourceId: event.userDetails.sqCardOnFile.card.id,
    )
        .then((Either<CreatePaymentErrorResponse, CreatePaymentSuccessResponse>
            response) async {
      response.fold<dynamic>(
        (CreatePaymentErrorResponse createPaymentErrorResponse) {
          // failure payment
          print('Payment Failure');
          add(OnPaymentFailureFlow(
              createPaymentErrorResponse.errors.first.code +
                  '\n' +
                  createPaymentErrorResponse.errors.first.detail));
        },
        (CreatePaymentSuccessResponse createPaymentSuccessResponse) async {
          await Future.wait<void>([
            AppCloudFirestore.updateDoc(
              _paymentDocRef.path,
              <String, dynamic>{
                'square_payment_response':
                    createPaymentSuccessResponse.toJson(),
              },
            ),
            AppCloudFirestore.updateDoc(
              _appointmentDocRef.path,
              <String, dynamic>{
                'initial_payment': {
                  'paid': event.toPay,
                  'created_at': Timestamp.now(),
                },
                'appointment_details': {
                  'date': Timestamp.fromDate(event.model.state.selectedDate),
                  'timeslot': event.model.state.timeSlot.toMap(),
                },
                'status': 'PENDING',
                'service': {
                  'name': event.model.services.name,
                  'time': event.model.services.time,
                  'price': event.model.services.price,
                  'path': AppCloudFirestore.allServices +
                      '/' +
                      event.model.services.uuid,
                },
                'technician': {
                  'name': event.model.state.technician.name,
                  'calendar_id': event.model.state.technician.calendarId,
                  'path': AppCloudFirestore.allTechnicians +
                      '/' +
                      event.model.state.technician.docId,
                },
                'address': event.address,
                'phone': event.contact,
                'created_at': Timestamp.now(),
              },
            ),
          ]).then((value) => print('Payment Details Saved to firestore'));
          add(OnAddEvent(
            model: event.model,
            address: event.address,
            phone: event.contact,
            userDetails: event.userDetails,
          ));
        },
      );
    });
  }

  Stream<PaymentState> onSuccessCardEntryFlow(
      OnSuccessCardEntryFlow event) async* {
    yield Processing();
    final String appointmentsCollectionPath = AppCloudFirestore.allUsers +
        '/' +
        AppFirebaseAuth.auth.currentUser.email +
        '/appointments';
    final DocumentReference _appointmentDocRef =
        await AppCloudFirestore.makeNewDoc(appointmentsCollectionPath);
    final DocumentReference _paymentDocRef = await AppCloudFirestore.makeNewDoc(
        _appointmentDocRef.path + '/payments');
    if (event.saveCard) {
      print('Saving card on file');
      await SquareApi()
          .makeCustomerCard(
        customerId: event.userDetails.sqCustomer.customer.id,
        cardRequest: CreateCustomerCardRequest(
          cardNonce: event.cardDetails.nonce,
          cardholderName: event.userDetails.name,
        ),
      )
          .then((response) {
        response.fold<dynamic>((error) {
          print('Save card on file failure');
          add(OnPaymentFailureFlow(
              error.errors.first.code + '\n' + error.errors.first.detail));
        }, (success) async {
          print('Save card on file success');
          await AppCloudFirestore.updateDoc(
            AppCloudFirestore.allUsers + '/' + event.userDetails.email,
            <String, dynamic>{
              'sq_card_on_file': success.toJson(),
            },
          ).then((value) => print('saved card to firebase'));
        });
      });
      yield* chargeCardOnFile(
        OnChargeCardOnFile(
          model: event.model,
          toPay: event.toPay,
          address: event.address,
          contact: event.contact,
          userDetails:
              await AppCloudFirestore.getUserDetails(event.userDetails.email),
        ),
      );
    } else {
      // make createPaymentApi call to square api to make the payment
      SquareApi()
          .makeCharge(
        userDetails: event.userDetails,
        amount: event.toPay,
        idempotencyKey: _paymentDocRef.id,
        sourceId: event.cardDetails.nonce,
      )
          .then(
              (Either<CreatePaymentErrorResponse, CreatePaymentSuccessResponse>
                  response) async {
        response.fold<dynamic>(
          (CreatePaymentErrorResponse createPaymentErrorResponse) {
            // failure payment
            print('Payment Failure');
            add(OnPaymentFailureFlow(
                createPaymentErrorResponse.errors.first.code +
                    '\n' +
                    createPaymentErrorResponse.errors.first.detail));
          },
          (CreatePaymentSuccessResponse createPaymentSuccessResponse) async {
            await Future.wait<void>([
              AppCloudFirestore.updateDoc(
                _paymentDocRef.path,
                <String, dynamic>{
                  'square_payment_response':
                      createPaymentSuccessResponse.toJson(),
                },
              ),
              AppCloudFirestore.updateDoc(
                _appointmentDocRef.path,
                <String, dynamic>{
                  'initial_payment': {
                    'paid': event.toPay,
                    'created_at': Timestamp.now(),
                  },
                  'appointment_details': {
                    'date': Timestamp.fromDate(event.model.state.selectedDate),
                    'timeslot': event.model.state.timeSlot.toMap(),
                  },
                  'status': 'PENDING',
                  'service': {
                    'name': event.model.services.name,
                    'time': event.model.services.time,
                    'price': event.model.services.price,
                    'path': AppCloudFirestore.allServices +
                        '/' +
                        event.model.services.uuid,
                  },
                  'technician': {
                    'name': event.model.state.technician.name,
                    'calendar_id': event.model.state.technician.calendarId,
                    'path': AppCloudFirestore.allTechnicians +
                        '/' +
                        event.model.state.technician.docId,
                  },
                  'address': event.address,
                  'phone': event.contact,
                  'created_at': Timestamp.now(),
                },
              ),
            ]).then((value) => print('Payment Details Saved to firestore'));
            add(OnAddEvent(
              model: event.model,
              address: event.address,
              phone: event.contact,
              userDetails: event.userDetails,
            ));
          },
        );
      });
    }
  }

  Stream<PaymentState> addEvent(OnAddEvent event) async* {
    yield Processing();
    final httpClient = await clientViaServiceAccount(
      credentials,
      CalendarEventsScope,
    );
    // final EventDetailsRes eventDetailsRes =
    await ApiCalls.addEventToCalendar(
      httpClient: httpClient,
      eventDetails: event.model.state.eventDetailsReq
        ..summary = event.model.services.name +
            ' \$' +
            event.model.services.price.toString()
        ..location = event.address
        ..description =
            'Name - ${event.userDetails.name}\nPhone - ${event.phone}\nEvent added from the app',
      calendarId: event.model.state.technician.calendarId,
    ).then((value) {
      print('Appointment Added to google calendar');
      add(OnCompleteCardEntryPaymentFlow());
    });
  }

  Stream<PaymentState> onStartCardEntryPaymentFlow(
      OnStartCardEntryPaymentFlow event) async* {
    yield StartCardEntryFlow(model: event.model);
  }

  Stream<PaymentState> onRemainingPaymentSuccessCardEntryFlow(
      OnStartCompleteRemainingPayment event) async* {
    yield Processing();
    final DocumentReference _paymentDocRef =
        await AppCloudFirestore.makeNewDoc(event.appointmentPath + '/payments');
    SquareApi()
        .makeCharge(
      userDetails: event.userDetails,
      amount: event.amount,
      idempotencyKey: _paymentDocRef.id,
      sourceId: event.sourceId,
    )
        .then((Either<CreatePaymentErrorResponse, CreatePaymentSuccessResponse>
            response) async {
      response.fold<dynamic>(
        (CreatePaymentErrorResponse createPaymentErrorResponse) {
          // failure payment
          print('Payment Failure');
          add(OnPaymentFailureFlow(
              createPaymentErrorResponse.errors.first.code +
                  '\n' +
                  createPaymentErrorResponse.errors.first.detail));
        },
        (CreatePaymentSuccessResponse createPaymentSuccessResponse) async {
          await Future.wait<void>([
            AppCloudFirestore.updateDoc(
              _paymentDocRef.path,
              <String, dynamic>{
                'square_payment_response':
                    createPaymentSuccessResponse.toJson(),
              },
            ),
            AppCloudFirestore.updateDoc(
              event.appointmentPath,
              <String, dynamic>{
                'remaining_payment': {
                  'paid': event.amount,
                  'created_at': Timestamp.now(),
                },
                'status': 'PAID_FULL',
                'updated_at': Timestamp.now(),
              },
            ),
          ]).then((value) => print('Payment Details Saved to firestore'));
        },
      );
    });
    add(OnCompleteCardEntryPaymentFlow());
  }

  Stream<PaymentState> saveCardOnFile(
      OnSaveCardOnFile onSaveCardOnFile) async* {}
}
