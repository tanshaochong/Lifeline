import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'emergency.dart';

class InstructionsPage extends StatefulWidget {
  const InstructionsPage({super.key});

  @override
  State<InstructionsPage> createState() => _InstructionsPageState();
}

class _InstructionsPageState extends State<InstructionsPage> {
  int activeIndex = 0;
  final controller = CarouselController();

  // final List<String> urlImages = [
  //   'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  //   'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  //   'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  //   'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  //   'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  //   'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  // ];

  final List<Map<String, String>> urlImages = [
    {
      "url":
          'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
      "text":
          "Check for responsiveness: Shake the victim gently and shout, \"Are you okay?\"",
    },
    {
      "url":
          'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
      "text":
          "Call for help: If the victim is unresponsive, call for emergency medical services (EMS) or ask someone nearby to do so.",
    },
    {
      "url":
          'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
      "text":
          "Open the airway: Tilt the victim's head back gently and lift the chin to open their airway.",
    },
    {
      "url":
          'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
      "text":
          "Check for breathing: Look, listen, and feel for breaths. If the victim is not breathing or is only gasping, begin CPR.",
    },
    {
      "url":
          'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
      "text":
          "Perform chest compressions: Place the heel of one hand on the center of the victim's chest and the other hand on top of the first. Push down hard and fast, aiming for a rate of 100-120 compressions per minute.",
    },
    {
      "url":
          'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80',
      "text":
          "Give rescue breaths: Pinch the victim's nose closed and give two full breaths into their mouth, making sure the chest rises with each breath.",
    },
    {
      "url":
          'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80',
      "text":
          "Continue CPR: Alternate between chest compressions and rescue breaths, continuing until help arrives or the victim starts to breathe on their own.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffdaaaa),
      appBar: AppBar(
        title: const Text(
          'Instructions',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: Color(0xfffdaaaa)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: buildImageSlider()),
            const SizedBox(
              height: 24.0,
            ),
            buildIndicator(),
            const SizedBox(
              height: 24.0,
            ),
            buildButtons(),
            const SizedBox(
              height: 24.0,
            ),
            EmergencySwipeToCall(isSwiped: true),
          ],
        ),
      ),
    );
  }

  Widget buildImageSlider() => CarouselSlider.builder(
        itemCount: urlImages.length,
        itemBuilder: ((context, index, realIndex) {
          final urlImage = urlImages[index];

          return buildImage(urlImage, index);
        }),
        carouselController: controller,
        options: CarouselOptions(
            height: double.infinity,
            initialPage: 0,
            enableInfiniteScroll: false,
            enlargeCenterPage: true,
            viewportFraction: 1,
            onPageChanged: (index, reason) => {
                  setState(() => activeIndex = index),
                }),
      );

  Widget buildImage(Map urlImage, int index) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            // margin: const EdgeInsets.symmetric(horizontal: 12.0),
            color: Colors.grey,
            width: double.infinity,
            child: const Placeholder(
              fallbackHeight: 250,
            ),
            // Image.network(
            //   urlImage['url'],
            //   fit: BoxFit.cover,
            // ),
          ),
          const SizedBox(
            height: 24.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cardiopulmonary Resuscitation | Step ${index + 1}',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                width: 16,
              ),
              const Expanded(
                child: Divider(
                  thickness: 1.5,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  urlImage['text'],
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      );

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: urlImages.length,
        effect: const ExpandingDotsEffect(
          dotHeight: 7.5,
          dotWidth: 15.0,
          activeDotColor: Colors.red,
        ),
      );

  Widget buildButtons() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          OutlinedButton(
              style: OutlinedButton.styleFrom(
                fixedSize: const Size(150, 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              onPressed: previous,
              child: const Text(
                'Previous',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              )),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              fixedSize: const Size(150, 70),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            onPressed: next,
            child: const Text(
              'Next',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      );

  void previous() => controller.previousPage();
  // controller.previousPage(duration: const Duration(milliseconds: 250));

  void next() => controller.nextPage();
  // controller.nextPage(duration: const Duration(milliseconds: 250));
}
