import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:royaltouch/bloc/make_appointments_bloc/appointments_bloc.dart';
import 'package:royaltouch/bloc/payment_bloc/payment_bloc.dart';
import 'package:royaltouch/bloc/signIn_bloc/signIn_bloc.dart';
import 'package:royaltouch/bloc/services_bloc/services_bloc.dart';
import 'package:royaltouch/bloc/signup_bloc/signup_bloc.dart';
import 'package:royaltouch/firebase/models.dart';
import 'package:royaltouch/pages/appointments/appointments.dart';
import 'package:royaltouch/pages/contactUs/contact_us.dart';
import 'package:royaltouch/pages/home/home.dart';
import 'package:royaltouch/pages/makeAppointments/appointments.dart';
import 'package:royaltouch/pages/payment/payment.dart';
import 'package:royaltouch/pages/signIn/sign_in.dart';
import 'package:royaltouch/pages/profile/profile.dart';
import 'package:royaltouch/pages/services/services.dart';
import 'package:royaltouch/pages/signUp/sign_up.dart';

class AppRoutesHandler {
  static final homeHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        Home(),
  );
  static final signInHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        BlocProvider<SignInBloc>(
      create: (context) => SignInBloc(),
      child: SignInPage(),
    ),
  );
  static final signUpHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        BlocProvider<SignupBloc>(
      create: (context) => SignupBloc(),
      child: SignUpPage(),
    ),
  );
  static final servicesHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return servicesWidget(context);
    },
  );
  static Widget servicesWidget(BuildContext context) =>
      BlocProvider<ServicesBloc>(
        create: (_) => ServicesBloc(),
        child: ServicesPage(),
        // child: ServicesPage2(),
      );
  static final contactUsHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return ContactUs();
    },
  );

  static final makeAppointmentsHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return BlocProvider<MakeAppointmentsBloc>(
        create: (_) =>
            MakeAppointmentsBloc(context.settings.arguments as AllServices),
        child: MakeAppointmentPage(),
      );
    },
  );
  static final appointmentsHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return appointmentsWidget(context);
    },
  );

  static Widget appointmentsWidget(BuildContext context) =>
      BlocProvider<PaymentBloc>(
        create: (_) => PaymentBloc(),
        child: AppointmentsPage(),
      );
  static final appointmentConfirmationHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return BlocProvider<PaymentBloc>(
        create: (_) => PaymentBloc(),
        child: PaymentsWidget(),
      );
    },
  );

  static final profileHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return profileWidget(context);
    },
  );
  static Widget profileWidget(BuildContext context) =>
      BlocProvider<MakeAppointmentsBloc>(
        create: (_) =>
            MakeAppointmentsBloc(context.settings.arguments as AllServices),
        child: ProfilePage(),
      );
}
