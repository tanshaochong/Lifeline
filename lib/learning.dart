import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:math';
import 'topic.dart';

var rand = Random();

class LearningPage extends StatefulWidget {
  const LearningPage({super.key});
  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  late List<Category> _contentList;

  Future<List<Category>> _loadLearning() async {
    final categories = await readJson();
    return categories;
  }

  var currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadLearning(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _contentList = snapshot.data!;
            return Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Card(
                    color: Theme.of(context).secondaryHeaderColor,
                    margin: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TopicPage(
                                    title: _contentList[currentIndex].name,
                                    topicList:
                                        _contentList[currentIndex].topics)));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.play_circle_outline,
                                  color: Colors.blue,
                                  size: 40,
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Current Course",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      _contentList[currentIndex].name,
                                      // courses[currentIndex].title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    const Text(
                                      "Pick up where you left off",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Text(
                              "Overall Progress: ${getAverageProgress(_contentList).toStringAsFixed(0)}%",
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 7),
                            LinearProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.yellow.shade800),
                              value: getAverageProgress(_contentList) / 100,
                              backgroundColor: Colors.grey[200],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(
                          decelerationRate: ScrollDecelerationRate.fast,
                          parent: AlwaysScrollableScrollPhysics()),
                      itemCount: _contentList.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _contentList.length) {
                          return const SizedBox(
                            height: 8,
                          );
                        }
                        // Course course = courses[index];
                        Category course = _contentList[index];
                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: SizedBox(
                            height: 130,
                            child: ListTile(
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    course.description,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 40),
                                  LinearProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.yellow.shade600),
                                    value: course.progress,
                                    backgroundColor: Colors.grey[200],
                                  ),
                                ],
                              ),
                              trailing: const Icon(Icons.more_horiz),
                              onTap: () {
                                // Navigate to course details page
                                setState(() {
                                  currentIndex = index;
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TopicPage(
                                            title: course.name,
                                            topicList: course.topics)));
                              },
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 8,
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Display a loading spinner
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

// Routing animation

Route _topicRoute(Category course) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          TopicPage(title: course.name, topicList: course.topics),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      });
}

// Helper Functions and Classes

class Category {
  final String name;
  final String description;
  final List<Topic> topics;
  double progress = 0.0;

  Category(
      {required this.name, required this.description, required this.topics}) {
    progress = rand.nextDouble();
  }
}

class Topic {
  final String title;
  final List<Subtopic> subtopics;
  double subtopicProgress = 0.0;

  Topic({required this.title, required this.subtopics});
}

class Subtopic {
  final String title;
  final String description;
  final String videoLink;
  final String videoDuration;
  bool completed;

  Subtopic(
      {required this.title,
      required this.description,
      required this.completed});
}

double getAverageProgress(List<Category> content) {
  double average = 0;
  for (Category course in content) {
    average += course.progress;
  }
  return (average / content.length) * 100;
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
      Topic loadedTopic =
          Topic(title: topic['title'], subtopics: subtopicsList);
      loadedTopic.subtopicProgress =
          subtopicCompletionCount / (subtopicCount == 0 ? 1 : subtopicCount);
      topicList.add(loadedTopic);

      totalSubtopicCount += subtopicCount;
      totalCompletionCount += subtopicCompletionCount;
    }
    categoryList.add(Category(
        name: category['name'],
        description: category['description'],
        topics: topicList));
  }

  return categoryList;
}
