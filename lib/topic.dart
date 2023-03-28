import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'learning.dart';

import 'utils/routing.dart';

class TopicPage extends StatefulWidget {
  final DatabaseReference database;
  final List<Topic> topicList;
  final String title;

  const TopicPage({super.key, required this.title, required this.topicList, required this.database});

  @override
  State<TopicPage> createState() => _TopicPage();
}

class _TopicPage extends State<TopicPage> {
  late Stream<List<Topic>> topicListStream;
  late List<bool> _isOpenList;
  late String _title;
  late DatabaseReference _dbRef;

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _isOpenList = List.generate(widget.topicList.length, (_) => false);
    topicListStream = _getCompletedStream(); // listens to changes on database
    _dbRef = widget.database;
  }

  Stream<List<Topic>> _getCompletedStream() {
    final controller = StreamController<List<Topic>>.broadcast(
      sync: true,
    );
    controller.onListen = () {
      controller.add(widget.topicList);
    };
    return controller.stream;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Topic>>(
      stream: topicListStream,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          List<Topic> topicList = snapshot.data!;
          return Scaffold(
              appBar: AppBar(
                title: Text(_title),
              ),
              body: SizedBox(
                height: double.infinity,
                child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    child: Column(
                      children: topicList.asMap().entries.map((entry) {
                        int index = entry.key;
                        Topic topic = entry.value;
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(10, 3, 10, 0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                tilePadding: const EdgeInsets.all(10),
                                leading: Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 10, 0, 10),
                                  child: Text(
                                    "Topic ${index + 1}:",
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(fontSize: 17),
                                  ),
                                ),
                                title: Text(topic.title),
                                onExpansionChanged: (isExpanded) {
                                  setState(() {
                                    _isOpenList[index] = isExpanded;
                                  });
                                },
                                initiallyExpanded: _isOpenList[index],
                                children: topic.subtopics.map((subtopic) {
                                  return ListTile(
                                    minLeadingWidth: 5,
                                    title: Text(subtopic.title,),
                                    leading: Padding(
                                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                      child: subtopic.completed
                                          ? Icon(Icons.check_box, color: Colors.green.shade300,)
                                          : const Icon(Icons.check_box_outline_blank),
                                    ),
                                    onTap: () {
                                      // navigate to content page (POST completion to database)
                                      Navigator.of(context).push(RouteUtil.contentRoute(topic.title, topic.subtopics, topic.subtopics.indexOf(subtopic), _dbRef));
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    )
                ),
              )
          );
        }
        else{
          // Display a loading spinner
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }

  @override
  void dispose() {
    // close the stream when the widget is disposed.
    topicListStream.drain();
    super.dispose();
  }
}