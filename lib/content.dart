import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'learning.dart';

class ContentPage extends StatefulWidget {
  final Subtopic subtopic;

  const ContentPage({super.key, required this.subtopic});

  @override
  State<ContentPage> createState() => _ContentPage();
}

class _ContentPage extends State<ContentPage> {
  late YoutubePlayerController _controller;
  late Subtopic _subtopic;

  bool _isFullScreen = false;

  @override
  void initState(){
    _subtopic = widget.subtopic;
    final videoID = YoutubePlayer.convertUrlToId(_subtopic.videoLink);
    _controller = YoutubePlayerController(
        initialVideoId: videoID!,
        flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false
        )
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isFullScreen ? null : AppBar(
        title: Text(_subtopic.title),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.landscape) {
            // This will make the video go into full screen mode when the device is rotated to landscape.
            _isFullScreen = true;
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
          } else {
            // This will restore the system UI overlays when the device is rotated to portrait.
            _isFullScreen = false;
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
          }
          return YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              onReady: () {
                _controller.addListener(() {
                  if (_controller.value.isFullScreen != _isFullScreen) {
                    setState(() {
                      _isFullScreen = _controller.value.isFullScreen;
                    });
                    if (_controller.value.isFullScreen) {
                      // Go into full screen mode when the full screen button is pressed or the device is rotated to landscape.
                      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
                    } else {
                      // restore the system UI overlays when the full screen mode is exited or the device is rotated to portrait.
                      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
                    }
                  }
                });
              },
              onEnded: (data) {
                Navigator.of(context).pop();
              },
              bottomActions: [
                CurrentPosition(),
                ProgressBar(
                  isExpanded: true,
                  colors: const ProgressBarColors(
                    playedColor: Colors.amber,
                    handleColor: Colors.amberAccent,
                  ),
                ),
                const PlaybackSpeedButton(),
                FullScreenButton(),
              ],
            ),
            builder: (context, player){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  player,
                ],
              );
            },
          );
        },
      )
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
