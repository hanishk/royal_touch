import 'package:flutter/material.dart';
import 'package:royaltouch/firebase/models.dart';
import 'package:royaltouch/widgets/buttons.dart';
import 'package:royaltouch/widgets/service_details.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AppointmentsScaffold extends StatefulWidget {
  const AppointmentsScaffold(this.services, this.children,
      {this.showBackButton = true});
  final AllServices services;
  final List children;
  final bool showBackButton;

  @override
  _AppointmentsScaffoldState createState() => _AppointmentsScaffoldState();
}

class _AppointmentsScaffoldState extends State<AppointmentsScaffold> {
  final _scrollController = ScrollController();
  bool _isScrolled = false;
  YoutubePlayerController _ytController;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _ytController = widget.services.youtubeVideoUrl != null
        ? YoutubePlayerController(
            initialVideoId: widget.services.youtubeVideoUrl.split('/').last,
            flags: const YoutubePlayerFlags(
              autoPlay: true,
              loop: true,
              mute: true,
            ),
          )
        : null;
  }

  void _scrollListener() {
    if (_scrollController.offset > size(context).height * 0.28) {
      if (!_isScrolled) {
        setState(() => _isScrolled = true);
      }
    } else {
      if (_isScrolled) {
        setState(() => _isScrolled = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            iconTheme: const IconThemeData(color: Colors.white),
            leading: widget.showBackButton ?? false
                ? AppButtons.appBarBackButtons(context)
                : null,
            backgroundColor: Colors.white,
            elevation: 2.0,
            title: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _isScrolled ? 1.0 : 0.0,
              curve: Curves.ease,
              child: _isScrolled
                  ? Padding(
                      padding: const EdgeInsets.only(right: 24.0),
                      child: getServiceName(
                        widget.services,
                        asTitle: false,
                      ),
                    )
                  : Container(),
            ),
            pinned: true,
            floating: false,
            primary: true,
            centerTitle: false,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              collapseMode: CollapseMode.pin,
              background: widget.services.youtubeVideoUrl != null
                  ? YoutubePlayer(
                      controller: _ytController,
                      thumbnail: getSerivceImage(
                        context: context,
                        service: widget.services,
                        height: size(context).height * 0.3,
                      ),
                      showVideoProgressIndicator: true,
                    )
                  : getSerivceImage(
                      context: context,
                      service: widget.services,
                      height: size(context).height * 0.3,
                    ),
            ),
            expandedHeight: size(context).height * 0.3,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              widget.children,
            ),
          ),
        ]);
  }
}
