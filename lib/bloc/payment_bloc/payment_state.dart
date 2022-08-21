part of 'payment_bloc.dart';

@immutable
abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class Processing extends PaymentState {}

class StartCardEntryFlow extends PaymentState {
  StartCardEntryFlow({@required this.model});
  final PaymentConfirmationModel model;
}

class FailureCardEntryFlow extends PaymentState {
  FailureCardEntryFlow(this.errorMsg);
  final String errorMsg;
}

class CancelCardEntryFlow extends PaymentState {}

class CompleteCardEntryFlow extends PaymentState {}
