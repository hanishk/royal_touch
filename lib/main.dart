import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:royaltouch/royal_touch.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'config/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  tz.initializeTimeZones();
  const String env = String.fromEnvironment('env', defaultValue: 'dev');
  const String sandboxSquareApplicationId =
      'sandbox-sq0idb-wS5AdI9n1BL8FQ01x9BeaA';
  const String prodSquareApplicationId = 'sq0idp-PzKFEtehvPCfNsOP_2iPDQ';
  if (env == 'prod') {
    print('Using prod square id');
    InAppPayments.setSquareApplicationId(prodSquareApplicationId);
  } else {
    print('Using sandbox square id');
    InAppPayments.setSquareApplicationId(sandboxSquareApplicationId);
  }

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: statusBarColor,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(RoyalTouch());
}
