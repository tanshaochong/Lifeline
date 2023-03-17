import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter/scheduler.dart';

import 'learning.dart';


class ContentPageView extends StatefulWidget {
  final List<Subtopic> subtopicList;
  final int subtopicIndex;

  const ContentPageView({super.key, required this.subtopicList, required this.subtopicIndex});

  @override
  State<ContentPageView> createState() => _ContentPageView();
}

class _ContentPageView extends State<ContentPageView> with AutomaticKeepAliveClientMixin{
  late final List<Subtopic> _subtopicList = widget.subtopicList;
  late int _subtopicIndex = widget.subtopicIndex;

  late final _controller = PageController(initialPage: _subtopicIndex);

  bool _isFullScreen = false;

  void updateScreenTilt(bool isFullScreen) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isFullScreen = isFullScreen;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: _isFullScreen ? null : AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.clear, color: Colors.grey,),
        ),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _controller,
        children: _subtopicList.map((subtopic) =>
            ContentPage(
              subtopic: subtopic,
              isFullScreen: _isFullScreen,
              onScreenTilt: (newValue) => updateScreenTilt(newValue),
            )
        ).toList(),
      ),
      bottomNavigationBar: _isFullScreen ? null :Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _subtopicIndex == 0 ? const SizedBox.shrink() : IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () {
                setState(() {
                  _subtopicIndex -= 1;
                  _controller.previousPage(duration: const Duration(milliseconds: 500), curve: Curves.ease);
                });
              },
            ),
            _subtopicIndex == _subtopicList.length - 1 ? const SizedBox.shrink() : IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                setState(() {
                  _subtopicIndex += 1;
                  _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.ease);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ContentPage extends StatefulWidget {
  final Subtopic subtopic;
  final bool isFullScreen;
  final Function onScreenTilt;

  const ContentPage({super.key, required this.subtopic, required this.isFullScreen, required this.onScreenTilt});

  @override
  State<ContentPage> createState() => _ContentPage();
}

class _ContentPage extends State<ContentPage> {
  late YoutubePlayerController _controller;
  late Subtopic _subtopic;
  late bool _isFullScreen;
  late Function _onScreenTilt;

  @override
  void initState(){
    _subtopic = widget.subtopic;
    _onScreenTilt = widget.onScreenTilt;
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
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          // This will make the video go into full screen mode when the device is rotated to landscape.
          // _isFullScreen = true;
          _onScreenTilt(true);
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
        } else {
          // This will restore the system UI overlays when the device is rotated to portrait.
          // _isFullScreen = false;
          _onScreenTilt(false);
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
                    // _isFullScreen = _controller.value.isFullScreen;
                    _onScreenTilt(_controller.value.isFullScreen);
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
                ContentBody(subtopic: _subtopic),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ContentBody extends StatelessWidget {
  const ContentBody({
    super.key,
    required Subtopic subtopic,
  }) : _subtopic = subtopic;

  final Subtopic _subtopic;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25,16,25,16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      _subtopic.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        _subtopic.videoDuration,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            HtmlWidget(
              '<div><p>${_subtopic.description}</p></div>',
            ),
          ],
        ),
      ),
    );
  }
}