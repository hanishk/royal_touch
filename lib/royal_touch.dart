import 'package:flutter/material.dart';
import 'package:royaltouch/config/routes.dart';
import 'package:royaltouch/config/themes.dart';
import 'package:royaltouch/firebase/app_firebase_auth.dart';

class RoyalTouch extends StatefulWidget {
  @override
  _RoyalTouchState createState() => _RoyalTouchState();
}

class _RoyalTouchState extends State<RoyalTouch> {
  String env;
  @override
  void initState() {
    super.initState();
    env = const String.fromEnvironment('env', defaultValue: 'dev');
    AppRouter.congigureRoutes();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.getLightThemeData(),
      darkTheme: AppTheme.getDarkThemeData(),
      initialRoute:
          AppFirebaseAuth.checkLoggedIn() ? AppRouter.home : AppRouter.signIn,
      onGenerateRoute: AppRouter.fluroRouter.generator,
      debugShowCheckedModeBanner: !(env == 'prod'),
    );
  }
}
