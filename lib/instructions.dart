import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'emergency.dart';
import 'utils/instruction_service.dart';

class InstructionsPage extends StatefulWidget {
  const InstructionsPage({
    super.key,
    required this.instructions,
    required this.name,
    this.showSwipeToCall = true,
  });

  final List<Instruction> instructions;
  final String name;
  final bool showSwipeToCall;

  @override
  State<InstructionsPage> createState() => _InstructionsPageState();
}

class _InstructionsPageState extends State<InstructionsPage> {
  int activeIndex = 0;
  final controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Instructions',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.clear, color: Colors.grey,),
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
        decoration: BoxDecoration(color: Colors.grey.shade50),
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
            if (widget.showSwipeToCall) EmergencySwipeToCall(),
          ],
        ),
      ),
    );
  }

  Widget buildImageSlider() => CarouselSlider.builder(
        itemCount: widget.instructions.length,
        itemBuilder: ((context, index, realIndex) {
          final instruction = widget.instructions[index];

          return buildImage(instruction, index);
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

  Widget buildImage(Instruction instruction, int index) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            // margin: const EdgeInsets.symmetric(horizontal: 12.0),
            color: Colors.grey.shade50,
            width: double.infinity,
            child: Image.network(
              instruction.url,
              height: 250,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(
            height: 24.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.name} | Step ${index + 1}',
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
            child: Center(
              child: Text(
                instruction.text,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: widget.instructions.length,
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
