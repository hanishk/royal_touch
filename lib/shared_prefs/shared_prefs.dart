import 'dart:convert';

import 'package:royaltouch/firebase/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> saveServices(List<AllServices> allServices) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setStringList('all_services',
        allServices.map((e) => json.encode(e.toJson())).toList());
  }

  Future<List<AllServices>> getServices() async {
    final SharedPreferences prefs = await _prefs;
    final List<String> stringList = prefs.getStringList('all_services');
    return stringList != null
        ? stringList.map((e) => AllServices.fromMap(json.decode(e))).toList()
        : [];
  }

  Future clearCache() async {
    final SharedPreferences prefs = await _prefs;
    prefs.clear();
  }
}
