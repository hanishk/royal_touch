import 'package:either_option/either_option.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:royaltouch/firebase/app_cloud_firestore.dart';
import 'package:royaltouch/firebase/models.dart';

class AppFirebaseAuth {
  static final FirebaseAuth auth = FirebaseAuth.instance;

  static bool checkLoggedIn() {
    if (auth.currentUser != null) {
      return true;
    }
    return false;
  }

  static Future<User> signInWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    if (auth.currentUser != null) {
      return auth.currentUser;
    }
    UserCredential userCredential;
    try {
      userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('${userCredential.user.email} signed in');
      return userCredential.user;
    } catch (e) {
      print('Failed to sign in with Email & Password ' + e.toString());
    }
    return null;
  }

  static Future<Either<StateError, User>> createUserWithEmailAndPassword({
    @required String email,
    @required String password,
    @required UserDetails userDetails,
  }) async {
    UserCredential userCredential;
    try {
      userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await AppCloudFirestore.saveUserDetails(userDetails);
      print('${userCredential.user.email} signed up');
      return Right(userCredential.user);
    } on FirebaseAuthException catch (e) {
      print('Failed to sign up with Email & Password ' + e.message);
      return Left(StateError(e.message));
    }
  }

  static void signOut() => auth.signOut();
}
