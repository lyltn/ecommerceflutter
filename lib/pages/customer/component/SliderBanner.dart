import 'package:flutter/material.dart';

class SliderBanner extends StatefulWidget {
  @override
  _SliderBannerState createState() => _SliderBannerState();
}

class _SliderBannerState extends State<SliderBanner> {
  final PageController _pageController = PageController(); // Controller for slider
  int _currentPage = 0; // To keep track of the current page

  List<String> images = [
    'images/banner.png', // Replace with your image paths
    'images/banner.png',
    'images/banner.png',
  ];

  @override
  void initState() {
    super.initState();
    // Optional: Auto-slide the banner every 3 seconds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 3), () {
        _autoSlide();
      });
    });
  }

  void _autoSlide() {
    if (_currentPage < images.length - 1) {
      _currentPage++;
    } else {
      _currentPage = 0;
    }

    _pageController.animateToPage(
      _currentPage,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );

    Future.delayed(Duration(seconds: 3), () {
      _autoSlide(); // Repeat the auto-slide
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Slider banner
        Container(
          height: 200.0, // Height of the banner
          child: PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (int index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.asset(
                images[index], // Display image
                fit: BoxFit.cover,
                width: double.infinity,
              );
            },
          ),
        ),
        // Indicator for the slider (optional)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            images.length,
            (index) => Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index
                    ? const Color.fromARGB(255, 20, 155, 24) // Active indicator color
                    : Colors.grey, // Inactive indicator color
              ),
            ),
          ),
        ),
      ],
    );
  }
}
