part of 'payment_bloc.dart';

@immutable
abstract class PaymentEvent {}

class OnStartCardEntryPaymentFlow extends PaymentEvent {
  OnStartCardEntryPaymentFlow({
    @required this.address,
    @required this.model,
  });
  final String address;
  final PaymentConfirmationModel model;
}

class OnCancelCardEntryFlow extends PaymentEvent {}

class OnSuccessCardEntryFlow extends PaymentEvent {
  OnSuccessCardEntryFlow({
    @required this.model,
    @required this.cardDetails,
    @required this.toPay,
    @required this.address,
    @required this.contact,
    @required this.userDetails,
    @required this.saveCard,
  });
  final PaymentConfirmationModel model;
  final CardDetails cardDetails;
  final String address;
  final String contact;
  final int toPay;
  final UserDetails userDetails;
  final bool saveCard;
}

class OnCompleteCardEntryPaymentFlow extends PaymentEvent {}

class OnPaymentFailureFlow extends PaymentEvent {
  OnPaymentFailureFlow(this.errorMsg);
  final String errorMsg;
}

class OnAddEvent extends PaymentEvent {
  OnAddEvent({
    @required this.model,
    @required this.address,
    @required this.phone,
    @required this.userDetails,
  });
  final String address, phone;
  final PaymentConfirmationModel model;
  final UserDetails userDetails;
}

class OnStartCompleteRemainingPayment extends PaymentEvent {
  OnStartCompleteRemainingPayment({
    @required this.appointmentPath,
    @required this.amount,
    @required this.userDetails,
    @required this.sourceId,
  });
  final String appointmentPath, sourceId;
  final UserDetails userDetails;
  final int amount;
}

class OnSaveCardOnFile extends PaymentEvent {}

class OnChargeCardOnFile extends PaymentEvent {
  OnChargeCardOnFile({
    @required this.userDetails,
    @required this.model,
    @required this.toPay,
    @required this.address,
    @required this.contact,
  });
  final UserDetails userDetails;
  final PaymentConfirmationModel model;
  final String address;
  final String contact;
  final int toPay;
}
