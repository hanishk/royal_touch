part of 'signup_bloc.dart';

@immutable
abstract class SignupState {}

class SignupInitial extends SignupState {}

class SigningUp extends SignupState {}

class SignupSuccess extends SignupState {}

class SignupFailed extends SignupState {
  SignupFailed(this.message);
  final String message;
}
