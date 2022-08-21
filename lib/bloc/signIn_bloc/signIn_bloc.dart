import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:royaltouch/firebase/app_firebase_auth.dart';

part 'signIn_event.dart';
part 'signIn_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(SignInInitial());

  @override
  Stream<SignInState> mapEventToState(
    SignInEvent event,
  ) async* {
    if (event is OnLoading) {
      yield SigningIn();
    } else if (event is OnSignInClick) {
      yield* signInUser(event);
    } else {
      yield SignInInitial();
    }
  }

  Stream<SignInState> signInUser(OnSignInClick event) async* {
    yield SigningIn();
    final User user = await AppFirebaseAuth.signInWithEmailAndPassword(
        email: event.email, password: event.password);

    if (user != null) {
      yield SignInSuccess();
    } else {
      yield SignInFailed(
          'The password is invalid or the user does not have a password.');
    }
  }
}
