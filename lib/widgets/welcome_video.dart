import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:royaltouch/firebase/app_cloud_firestore.dart';
import 'package:royaltouch/firebase/app_firebase_auth.dart';
import 'package:royaltouch/pages/appointments/model.dart';
import 'package:royaltouch/widgets/buttons.dart';
import 'package:royaltouch/widgets/service_details.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:royaltouch/extensions/yt_controller_extension.dart';

class WelcomeVideo extends StatefulWidget {
  @override
  _WelcomeVideoState createState() => _WelcomeVideoState();
}

class _WelcomeVideoState extends State<WelcomeVideo> {
  RemoteConfig remoteConfig;
  bool loading = true;
  String url = 'https://youtu.be/26T3Qe9ArZc';
  YoutubePlayerController _ytController;
  bool mute = true;
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    remoteConfig = await RemoteConfig.instance;
    final defaults = <String, dynamic>{
      'video_url': url,
    };
    await remoteConfig.setDefaults(defaults);
    await remoteConfig.fetch(expiration: const Duration(hours: 5));
    await remoteConfig.activateFetched();
    url = remoteConfig.getString('video_url') ?? url;
    _ytController = url.isNotEmpty
        ? YoutubePlayerController(
            initialVideoId: url.split('/').last,
            flags: YoutubePlayerFlags(
              autoPlay: true,
              loop: true,
              mute: mute,
            ),
          )
        : null;
    setState(() => loading = false);
  }

  @override
  void dispose() {
    super.dispose();
    _ytController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String path = AppCloudFirestore.allUsers +
        '/' +
        AppFirebaseAuth.auth.currentUser.email +
        '/appointments';
    return StreamBuilder<QuerySnapshot>(
        stream: AppCloudFirestore.getAppointmentsStream(path),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container();
          }
          List<AppointmentModel> list =
              snapshot.data.docs.map<AppointmentModel>((e) {
            {
              final Map map = e.data();
              map.addAll(<String, dynamic>{'doc_path': path + '/' + e.id});
              return AppointmentModel.fromJson(map);
            }
          }).toList();
          list = list.where((element) => element.createdAt != null).toList();
          list.sort(
              (a, b) => a.createdAt.toDate().compareTo(b.createdAt.toDate()));

          list = list.reversed.toList();
          if (list.isEmpty) {
            return !loading
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: borderRadius),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: borderRadius,
                          child: YoutubePlayer(
                            controller: _ytController,
                            showVideoProgressIndicator: true,
                            actionsPadding: onlyHorizontal,
                            topActions: [
                              Expanded(
                                flex: 1,
                                child: Container(),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                    icon: Icon(_ytController.isMute()
                                        ? Icons.volume_up
                                        : Icons.volume_mute),
                                    color: Theme.of(context).cardColor,
                                    onPressed: () => setState(
                                        () => _ytController.toggleMute())),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : Container();
          }
          return Container();
        });
  }
}
