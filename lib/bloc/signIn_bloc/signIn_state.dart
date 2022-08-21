part of 'signIn_bloc.dart';

abstract class SignInState {}

class SignInInitial extends SignInState {}

class SigningIn extends SignInState {}

class SignInSuccess extends SignInState {}

class SignInFailed extends SignInState {
  SignInFailed(this.errorMsg);
  final String errorMsg;
}
