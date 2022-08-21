part of 'signIn_bloc.dart';

abstract class SignInEvent {}

class OnSignInClick extends SignInEvent {
  OnSignInClick({@required this.email, @required this.password});
  final String email, password;
}

class OnRegisterClick extends SignInEvent {}

class OnLoading extends SignInEvent {}
