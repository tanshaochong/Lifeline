import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:math';
import 'utils/routing.dart';

import 'package:firebase_database/firebase_database.dart';

var rand = Random();

class LearningPage extends StatefulWidget {
  final User? user;
  const LearningPage({super.key, required this.user});
  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage>
    with AutomaticKeepAliveClientMixin {
  late Future<List<Category>> _contentList;
  late final User? _user = widget.user;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  late final DatabaseReference dbRef =
      database.ref().child('users').child(_user!.uid); // user data reference

  late StreamSubscription
      _subscription; // live listen to real time database for completion changes

  @override
  void initState() {
    super.initState();
    _contentList = _loadLearning();
  }

  // load learning content once on page init
  Future<List<Category>> _loadLearning() async {
    final categories = await readJson(_user?.uid);
    return categories;
  }

  // load completion data
  Future<void> loadCompletion(List<Category> contentList) async {
    // get user completion data
    final snapshot = await dbRef.child('courses_completion').get();

    for (var category in contentList) {
      double totalSubtopicCount = 0, totalCompletionCount = 0;
      for (var topic in category.topics) {
        double subtopicCount = 0, subtopicCompletionCount = 0;
        for (var subtopic in topic.subtopics) {
          subtopic.completed = snapshot.child(subtopic.topicID).value as bool;

          if (subtopic.completed) {
            subtopicCompletionCount++;
          }
          subtopicCount++;
        }
        topic.subtopicProgress =
            subtopicCompletionCount / (subtopicCount == 0 ? 1 : subtopicCount);

        totalSubtopicCount += subtopicCount;
        totalCompletionCount += subtopicCompletionCount;
      }
      category.progress = totalCompletionCount /
          (totalSubtopicCount == 0 ? 1 : totalSubtopicCount);
    }

    // update learning completion
    setState(() {
      _contentList = _contentList;
    });
  }

  @override
  void dispose() {
    // stop async calls to database
    _subscription.cancel();
    super.dispose();
  }

  var currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
        future: _contentList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Category> contentList = snapshot.data!;
            _subscription = dbRef.onValue.listen((event) {
              loadCompletion(contentList);
            });
            return Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Card(
<<<<<<< HEAD
                    color: Colors.red.shade50,
=======
                    color: Colors.blue.shade50,
>>>>>>> 027d713f8500f4ecbbf6029f97f687d288ebfb87
                    margin: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: InkWell(
                      onTap: () {
<<<<<<< HEAD
                        Navigator.of(context).push(RouteUtil.topicRoute(
=======
                        Navigator.of(context).push(_topicRoute(
>>>>>>> 027d713f8500f4ecbbf6029f97f687d288ebfb87
                            contentList[currentIndex],
                            dbRef.child('courses_completion')));
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
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      contentList[currentIndex].name,
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
                              "Overall Progress: ${getAverageProgress(contentList).toStringAsFixed(0)}%",
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 7),
                            LinearProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.yellow.shade800),
                              value: getAverageProgress(contentList) / 100,
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
                      itemCount: contentList.length + 1,
                      itemBuilder: (context, index) {
                        if (index == contentList.length) {
                          return const SizedBox(
                            height: 8,
                          );
                        }
                        Category course = contentList[index];
                        return Card(
<<<<<<< HEAD
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: SizedBox(
                              height: 110,
                              child: ListTile(
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      course.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      course.description,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                    const SizedBox(height: 20),
                                    LinearProgressIndicator(
                                      minHeight: 3,
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
                                  Navigator.of(context).push(
                                      RouteUtil.topicRoute(course,
                                          dbRef.child('courses_completion')));
                                },
                              ),
                            ));
=======
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: SizedBox(
                            height: 110,
                            child: ListTile(
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    course.description,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 20),
                                  LinearProgressIndicator(
                                    minHeight: 3,
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
                                Navigator.of(context).push(_topicRoute(
                                    course, dbRef.child('courses_completion')));
                              },
                            ),
                          ),
                        );
>>>>>>> 027d713f8500f4ecbbf6029f97f687d288ebfb87
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

  @override
  bool get wantKeepAlive => true;
}

<<<<<<< HEAD
=======
// Routing animation

Route _topicRoute(Category course, DatabaseReference dbRef) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => TopicPage(
          title: course.name, topicList: course.topics, database: dbRef),
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

>>>>>>> 027d713f8500f4ecbbf6029f97f687d288ebfb87
// Helper Functions and Classes

class Category {
  final String name;
  final String description;
  final List<Topic> topics;
  double progress = 0.0;

  Category(
      {required this.name, required this.description, required this.topics}) {
    // progress = rand.nextDouble();
  }
}

class Topic {
  final String title;
  final List<Subtopic> subtopics;
  double subtopicProgress = 0.0;

  Topic({required this.title, required this.subtopics});
}

class Subtopic {
  final String topicID;
  final String title;
  final String description;
  final String videoLink;
  final String videoDuration;
  late bool completed;

  Subtopic(
      {required this.topicID,
      required this.title,
      required this.description,
      required this.videoLink,
      required this.videoDuration});
}

double getAverageProgress(List<Category> content) {
  double average = 0;
  for (Category course in content) {
    average += course.progress;
  }
  return (average / content.length) * 100;
}

Future<List<Category>> readJson(String? userId) async {
  // load learning content from json
  final jsonContent = await rootBundle.loadString('assets/content.json');
  final data = json.decode(jsonContent);

  List<Category> categoryList = [];
  for (var category in data['category']) {
    List<Topic> topicList = [];
    for (var topic in category['topics']) {
      List<Subtopic> subtopicsList = [];
      for (var subtopic in topic['subtopics']) {
        subtopicsList.add(Subtopic(
          topicID: subtopic['topicID'],
          title: subtopic['title'],
          description: subtopic['content'],
          videoLink: subtopic['video'],
          videoDuration: subtopic['duration'],
        ));
      }
      Topic loadedTopic =
          Topic(title: topic['title'], subtopics: subtopicsList);
      topicList.add(loadedTopic);
    }
    Category loadedCategory = Category(
        name: category['name'],
        description: category['description'],
        topics: topicList);
    categoryList.add(loadedCategory);
  }

  return categoryList;
}
