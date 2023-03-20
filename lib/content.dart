import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'learning.dart';


class ContentPageView extends StatefulWidget {
  final DatabaseReference database;
  final String topicTitle;
  final List<Subtopic> subtopicList;
  final int subtopicIndex;

  const ContentPageView({super.key, required this.subtopicList, required this.subtopicIndex, required this.topicTitle, required this.database});

  @override
  State<ContentPageView> createState() => _ContentPageView();
}

class _ContentPageView extends State<ContentPageView> {
  late final String _topicTitle;
  late final List<Subtopic> _subtopicList;
  late int _subtopicIndex;
  late final DatabaseReference dbRef;

  late final _controller = PageController(initialPage: _subtopicIndex);

  bool _isFullScreen = false;

  @override
  void initState(){
    super.initState();
    _topicTitle = widget.topicTitle;
    _subtopicList = widget.subtopicList;
    _subtopicIndex = widget.subtopicIndex;
    dbRef = widget.database;

    Subtopic subtopic = _subtopicList[_subtopicIndex];

    dbRef.update({
      subtopic.topicID: true,
    });
  }

  void updateScreenTilt(bool isFullScreen) {
    setState(() {
      _isFullScreen = isFullScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        centerTitle: true,
        title: Text(_topicTitle, style: const TextStyle(color: Colors.black, fontSize: 18),),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _controller,
        children: _subtopicList.map((subtopic) =>
            ContentPage(
              subtopic: subtopic,
              onScreenTilt: (newValue) => updateScreenTilt(newValue),
            )
        ).toList(),
      ),
      bottomNavigationBar: _isFullScreen ? null :Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _subtopicIndex == 0 ? const SizedBox.shrink() : IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () {
                setState(() {
                  _subtopicIndex -= 1;
                  _controller.previousPage(duration: const Duration(milliseconds: 500), curve: Curves.ease);

                  // navigate to content page (POST completion to database)
                  dbRef.update({
                    _subtopicList[_subtopicIndex].topicID: true,
                  });
                });
              },
            ),
            _subtopicIndex == _subtopicList.length - 1 ? const SizedBox.shrink() : IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                setState(() {
                  _subtopicIndex += 1;
                  _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.ease);

                  // navigate to content page (POST completion to database)
                  dbRef.update({
                    _subtopicList[_subtopicIndex].topicID: true,
                  });
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ContentPage extends StatefulWidget {
  final Subtopic subtopic;
  final Function onScreenTilt;

  const ContentPage({super.key, required this.subtopic, required this.onScreenTilt});

  @override
  State<ContentPage> createState() => _ContentPage();
}

class _ContentPage extends State<ContentPage> {
  late YoutubePlayerController _controller;
  late YoutubePlayer _player;
  late Subtopic _subtopic;
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

    _player = YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
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
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
    ]);

    return OrientationBuilder(
      builder: (context, orientation) {
        if(orientation == Orientation.landscape && !_controller.value.isFullScreen){
          _controller.toggleFullScreenMode();
        }
        else if(orientation == Orientation.portrait && _controller.value.isFullScreen){
          _controller.toggleFullScreenMode();
        }
        try{
          return YoutubePlayerBuilder(
            onEnterFullScreen: () {
              _onScreenTilt(true);
            },
            onExitFullScreen: () {
              _onScreenTilt(false);
            },
            player: _player,
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
        }
        catch (e){
          // if we are unable to load video or any timeout errors occurred
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
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
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(25,16,25,0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,0,3),
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
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              HtmlWidget(_subtopic.description),
            ],
          ),
        ),
      ),
    );
  }
}