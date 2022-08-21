import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:either_option/either_option.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:royaltouch/firebase/app_firebase_auth.dart';
import 'package:royaltouch/firebase/models.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitial());

  @override
  Stream<SignupState> mapEventToState(
    SignupEvent event,
  ) async* {
    if (event is OnLoading) {
      yield SigningUp();
    } else if (event is OnSignupClick) {
      yield* signupUser(event);
    } else {
      yield SignupInitial();
    }
  }

  Stream<SignupState> signupUser(OnSignupClick event) async* {
    yield SigningUp();
    final Either<StateError, User> response =
        await AppFirebaseAuth.createUserWithEmailAndPassword(
      email: event.userDetails.email,
      password: event.password,
      userDetails: event.userDetails,
    );
    bool isError;
    String errorMsg;
    response.fold((StateError error) async {
      isError = true;
      errorMsg = error.message;
    }, (user) async {
      if (user != null) {
        isError = false;
        user.sendEmailVerification();
      } else {
        isError = true;
        errorMsg =
            'There was a unknown problem signing up. Please try again later.';
      }
    });
    if (isError && errorMsg != null) {
      yield SignupFailed(errorMsg);
    } else if (!isError) {
      yield SignupSuccess();
    }
  }
}
