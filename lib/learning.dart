import 'package:flutter/material.dart';
import 'dart:math';

var rand = Random();

class Course {
  final String title;
  final String description;
  double progress;

  Course(this.title, this.description, this.progress);
}

List<Course> courses = [
  Course("Essential Skills", "Learn basic first aid knowledge", rand.nextDouble()),
  Course("Self First Aid", "Help yourself when you are alone", rand.nextDouble()),
  Course("Infant & Child First Aid", "For parents and babysitters", rand.nextDouble()),
  Course("Sports Injuries", "What all sportsmen need to know", rand.nextDouble()),
  Course("Mental Health Aid", "Identify the signs and learn to respond", rand.nextDouble()),
];

double getAverageProgress() {
  double average = 0;
  for(Course course in courses){
    average += course.progress;
  }
  return (average / courses.length) * 100;
}

class LearningPage extends StatefulWidget {
  const LearningPage({super.key});
  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {

  var currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: Card(
            color: Theme.of(context).secondaryHeaderColor,
            margin: const EdgeInsets.all(16.0),
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
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
                            courses[currentIndex].title,
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
                    "Overall Progress: ${getAverageProgress().toStringAsFixed(0)}%",
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 7),

                  LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow.shade800),
                    value: getAverageProgress() / 100,
                    backgroundColor: Colors.grey[200],
                  ),
                ],
              ),
            ),
          ),

        ),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.separated(
              itemCount: courses.length + 1,
              itemBuilder: (context, index) {
                if (index == courses.length){
                  return const SizedBox(height: 8,);
                }
                Course course = courses[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: SizedBox(
                    height: 130,
                    child: ListTile(
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            course.description,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey
                            ),
                          ),

                          const SizedBox(height: 40),

                          LinearProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow.shade600),
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
  }
}