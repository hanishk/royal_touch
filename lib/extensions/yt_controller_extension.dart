import 'package:youtube_player_flutter/youtube_player_flutter.dart';

extension MuteController on YoutubePlayerController {
  static bool _muteVal = true;

  void _updateMute() {
    _muteVal = !_muteVal;
  }

  void toggleMute() {
    if (isMute()) {
      unMute();
    } else {
      mute();
    }
    _updateMute();
  }

  bool isMute() => _muteVal;
}
