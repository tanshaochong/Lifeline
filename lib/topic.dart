import 'package:flutter/material.dart';
import 'learning.dart';
import 'content.dart';

class TopicPage extends StatefulWidget {
  final List<Topic> topicList;
  final String title;

  const TopicPage({super.key, required this.title, required this.topicList});

  @override
  State<TopicPage> createState() => _TopicPage();
}

class _TopicPage extends State<TopicPage> {
  late List<bool> _isOpenList;
  late List<Topic> _topicList;
  late String _title;

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _topicList = widget.topicList;
    _isOpenList = List.generate(_topicList.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        body: SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              child: Column(
                children: _topicList.asMap().entries.map((entry) {
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
                                setState(() {
                                  // navigate to content page (POST completion to database)
                                  subtopic.completed = true;
                                });
                                Navigator.of(context).push(_openContentRoute(topic.title, topic.subtopics, topic.subtopics.indexOf(subtopic)));
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
}

// routing

Route _openContentRoute(String title, List<Subtopic> subtopicList, int subtopicIndex) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ContentPageView(topicTitle: title, subtopicList: subtopicList, subtopicIndex: subtopicIndex,),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var curve = Curves.easeOutCubic;
        Offset begin = const Offset(0, 1.0);
        Offset end = Offset.zero;

        var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      }
  );
}