part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent {}

class OnSignupClick extends SignupEvent {
  OnSignupClick({
    @required this.password,
    @required this.userDetails,
  });
  final String password;
  final UserDetails userDetails;
}

class OnLoading extends SignupEvent {}
