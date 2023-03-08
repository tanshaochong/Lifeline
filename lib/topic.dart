import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toggle_list/toggle_list.dart';

const Color appColor = Colors.blue;

class TopicPage extends StatefulWidget {
  const TopicPage({Key? key}) : super(key: key);
  @override
  _TopicPage createState() => _TopicPage();
}

class _TopicPage extends State<TopicPage> {
  List<bool> _isOpenList = List.generate(5, (_) => false);

  late List<Category> _contentList = [];

  @override
  void initState() {
    super.initState();
    _loadLearning();
  }

  Future<void> _loadLearning() async {
    final categories = await readJson();
    setState(() {
      _contentList = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Essentials'),
          foregroundColor: Colors.white,
          backgroundColor: appColor,
        ),
        body: _contentList.length != 0
            ? Padding(
                padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                child: ToggleList(
                  divider: const SizedBox(height: 10),
                  toggleAnimationDuration: const Duration(milliseconds: 300),
                  scrollPosition: AutoScrollPosition.begin,
                  trailing: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.expand_more),
                  ),
                  children: List.generate(
                    _contentList[0].topics.length,
                    (index) => ToggleListItem(
                      leading: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                        // child: Icon(Icons.circle_outlined),
                        child: Text(
                          "Topic ${index + 1}:",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontSize: 17),
                        ),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _contentList[0].topics[index].title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                      content: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(20),
                          ),
                          color: appColor.withOpacity(0.15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            _contentList[0].topics[index].subtopics.length,
                            (innerIndex) => Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    minLeadingWidth: 5,
                                    title: Text(_contentList[0]
                                        .topics[index]
                                        .subtopics[innerIndex]
                                        .title),
                                    leading: _contentList[0]
                                            .topics[index]
                                            .subtopics[innerIndex]
                                            .completed
                                        ? Icon(Icons.check_box)
                                        : Icon(Icons.check_box_outline_blank),
                                    onTap: () {
                                      setState(() {
                                        // navigate to content page
                                        _contentList[0]
                                            .topics[index]
                                            .subtopics[innerIndex]
                                            .completed = true;
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    width: double.infinity,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      isInitiallyExpanded: false,
                      onExpansionChanged: _expansionChangedCallback,
                      // onExpansionChanged: (){print("object");},
                      headerDecoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      expandedHeaderDecoration: BoxDecoration(
                        color: appColor.withOpacity(0.50),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : CircularProgressIndicator());
  }

  void _expansionChangedCallback(int index, bool newValue) {
    _isOpenList[index] = newValue;
    print(
        'Changed expansion status of item  no.${index + 1} to ${newValue ? "expanded" : "shrunk"}.');
  }
}

class Category {
  final String name;
  final List<Topic> topics;

  Category({required this.name, required this.topics});
}

class Topic {
  final String title;
  final List<Subtopic> subtopics;

  Topic({required this.title, required this.subtopics});
}

class Subtopic {
  final String title;
  final String description;
  bool completed;

  Subtopic(
      {required this.title,
      required this.description,
      required this.completed});
}

Future<List<Category>> readJson() async {
  final jsonContent = await rootBundle.loadString('assets/content.json');
  final data = json.decode(jsonContent);

  List<Category> categoryList = [];
  for (var category in data['category']) {
    List<Topic> topicList = [];
    for (var topic in category['topics']) {
      List<Subtopic> subtopicsList = [];
      for (var subtopic in topic['subtopics']) {
        subtopicsList.add(Subtopic(
            title: subtopic['title'],
            description: subtopic['content'],
            completed: subtopic['completed']));
      }
      topicList.add(Topic(title: topic['title'], subtopics: subtopicsList));
    }
    categoryList.add(Category(name: category['name'], topics: topicList));
  }

  return categoryList;
}
