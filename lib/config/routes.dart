import 'package:fluro/fluro.dart';
import 'package:royaltouch/config/routes_handler.dart';

class AppRouter {
  static FluroRouter fluroRouter = FluroRouter();

  static const String signIn = 'signIn';
  static const String signUp = 'sign_up';
  static const String payment = 'payemnt';
  static const String appointments = 'appointments';
  static const String makeAppointment = 'make_appointment';
  static const String appointmentConfirmation = 'appointment_confirmation';
  static const String profile = 'profile';
  static const String services = 'services';
  static const String contactUs = 'contact_us';
  static const String home = 'home';

  static void congigureRoutes() {
    fluroRouter
      ..notFoundHandler = AppRoutesHandler.signInHandler
      ..define(signIn,
          handler: AppRoutesHandler.signInHandler,
          transitionType: TransitionType.inFromRight)
      ..define(signUp,
          handler: AppRoutesHandler.signUpHandler,
          transitionType: TransitionType.inFromRight)
      ..define(appointmentConfirmation,
          handler: AppRoutesHandler.appointmentConfirmationHandler,
          transitionType: TransitionType.inFromRight)
      ..define(services,
          handler: AppRoutesHandler.servicesHandler,
          transitionType: TransitionType.inFromRight)
      ..define(contactUs,
          handler: AppRoutesHandler.contactUsHandler,
          transitionType: TransitionType.inFromRight)
      ..define(appointments,
          handler: AppRoutesHandler.appointmentsHandler,
          transitionType: TransitionType.inFromRight)
      ..define(makeAppointment,
          handler: AppRoutesHandler.makeAppointmentsHandler,
          transitionType: TransitionType.inFromRight)
      ..define(profile,
          handler: AppRoutesHandler.profileHandler,
          transitionType: TransitionType.inFromRight)
      ..define(home,
          handler: AppRoutesHandler.homeHandler,
          transitionType: TransitionType.inFromRight);
  }
}
