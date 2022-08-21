import 'package:flutter/material.dart';
import 'package:royaltouch/config/routes.dart';
import 'package:royaltouch/firebase/app_firebase_auth.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget listTile(Function onTap, Widget trailing, String title) => ListTile(
          title: Text(title),
          trailing: trailing,
          onTap: onTap,
        );

    return Drawer(
      child: ListView(
        padding: const EdgeInsets.only(top: kBottomNavigationBarHeight),
        children: [
          Image.asset(
            'assets/royal_touch.png',
          ),
          const Divider(),
          listTile(() {
            Navigator.of(context).pushNamed(AppRouter.contactUs);
          }, const Icon(Icons.contact_mail), 'Contact Us'),
          listTile(() {
            showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Sign Out'),
                content: const Text('Are you sure you want to sign out?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('CANCEL'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text('CONFIRM'),
                  ),
                ],
              ),
            ).then((value) {
              if (value != null && value) {
                Navigator.pushNamedAndRemoveUntil(
                    context, AppRouter.signIn, (route) => false);
                AppFirebaseAuth.signOut();
              }
            });
          }, const Icon(Icons.logout), 'Sign Out'),
        ],
      ),
    );
  }
}
