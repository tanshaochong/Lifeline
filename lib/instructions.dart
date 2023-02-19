import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class InstructionsPage extends StatefulWidget {
  const InstructionsPage({super.key});

  @override
  State<InstructionsPage> createState() => _InstructionsPageState();
}

class _InstructionsPageState extends State<InstructionsPage> {
  int activeIndex = 0;
  final controller = CarouselController();

  final List<String> urlImages = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instructions'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildImageSlider(),
            const SizedBox(
              height: 24.0,
            ),
            buildIndicator(),
            const SizedBox(
              height: 24.0,
            ),
            buildButtons(),
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
            height: 400,
            initialPage: 0,
            enableInfiniteScroll: false,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) => {
                  setState(() => activeIndex = index),
                }),
      );

  Widget buildImage(String urlImage, int index) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 12.0),
        color: Colors.grey,
        width: double.infinity,
        child: Image.network(
          urlImage,
          fit: BoxFit.cover,
        ),
      );

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: urlImages.length,
        effect: const ExpandingDotsEffect(
          dotHeight: 10.0,
          dotWidth: 10.0,
          activeDotColor: Colors.red,
        ),
      );

  Widget buildButtons() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                fixedSize: const Size(100, 100),
              ),
              onPressed: previous,
              child: const Icon(
                Icons.arrow_back,
                size: 32,
              )),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                fixedSize: const Size(100, 100),
              ),
              onPressed: next,
              child: const Icon(
                Icons.arrow_forward,
                size: 32,
              )),
        ],
      );

  void previous() => controller.previousPage();

  void next() => controller.nextPage();
}
