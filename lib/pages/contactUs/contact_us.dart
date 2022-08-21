import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:royaltouch/widgets/appbar.dart';
import 'package:royaltouch/widgets/scaffold.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  RemoteConfig remoteConfig;
  bool loading = true;
  String phone = '+1 919 525 4946', email = 'royaltouchmd2@gmail.com';
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    remoteConfig = await RemoteConfig.instance;
    final defaults = <String, dynamic>{
      'phone': phone,
      'email': email,
    };
    await remoteConfig.setDefaults(defaults);
    await remoteConfig.fetch(expiration: const Duration(hours: 5));
    await remoteConfig.activateFetched();
    phone = remoteConfig.getString('phone') ?? phone;
    email = remoteConfig.getString('email') ?? email;
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: mainAppBar(context, title: 'Contact Us'),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                ListTile(
                  title: const Text('Phone'),
                  trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                  subtitle: Text(phone),
                  onLongPress: () {
                    Clipboard.setData(ClipboardData(text: phone));
                    Flushbar<void>(
                      message: 'Copied to clipboard.',
                      duration: const Duration(seconds: 1),
                    )..show(context);
                  },
                  onTap: () async {
                    final String url = 'tel:$phone';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
                ListTile(
                  title: const Text('Email'),
                  trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                  subtitle: Text(email),
                  onLongPress: () {
                    Clipboard.setData(ClipboardData(text: email));
                    Flushbar<void>(
                      message: 'Copied to clipboard.',
                      duration: const Duration(seconds: 1),
                    )..show(context);
                  },
                  onTap: () async {
                    final Uri _emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: email,
                    );
                    if (await canLaunch(_emailLaunchUri.toString())) {
                      await launch(_emailLaunchUri.toString());
                    } else {
                      throw 'Could not launch $_emailLaunchUri';
                    }
                  },
                ),
              ],
            ),
    );
  }
}
