import 'package:flutter/material.dart';
import 'package:royaltouch/config/routes_handler.dart';
import 'package:royaltouch/pages/home/bottom_nav_item.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<BottomNavItem> bottomNav;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    bottomNav = [
      BottomNavItem(
          AppRoutesHandler.servicesWidget(context), Icons.home, 'Services'),
      BottomNavItem(AppRoutesHandler.appointmentsWidget(context), Icons.list,
          'Appointments'),
      BottomNavItem(
          AppRoutesHandler.profileWidget(context), Icons.person, 'Profile'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bottomNav[currentIndex].widget,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: bottomNav
            .map(
              (e) => BottomNavigationBarItem(
                icon: Icon(e.icon),
                label: e.appbarTitle,
              ),
            )
            .toList(),
        onTap: (index) => setState(() => currentIndex = index),
      ),
    );
  }
}
