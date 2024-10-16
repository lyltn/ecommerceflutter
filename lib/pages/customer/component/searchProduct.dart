import 'package:flutter/material.dart';
import 'package:ecommercettl/pages/customer/component/FilterAction.dart';
import 'package:ecommercettl/pages/customer/component/FindBar.dart';
import 'package:ecommercettl/pages/customer/component/ProductCard.dart';
import 'package:ecommercettl/pages/customer/component/FilterPanel.dart'; // Import the FilterPanel
import 'package:ecommercettl/pages/customer/ProductDetail.dart'; // Import your ProductDetail page

class SearchProduct extends StatefulWidget {
  const SearchProduct({super.key});

  @override
  State<SearchProduct> createState() => SearchProductState();
}

class SearchProductState extends State<SearchProduct> with SingleTickerProviderStateMixin {
  String? searchQuery;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      setState(() {
        searchQuery = args;
      });
    }
  }

  void _toggleFilterPanel() {
    if (_controller.isDismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _closeFilterPanel() {
    if (_controller.isCompleted) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Findbar(
                          isEnabled: false,
                          searchQuery: searchQuery,
                          onTap: () => Navigator.pop(context),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: _toggleFilterPanel,
                          child: FilterAction(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                crossAxisSpacing: 5,
                mainAxisSpacing: 10,
                childAspectRatio: 0.4,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  for (int i = 0; i < 5; i++)
                    GestureDetector(
                      onTap: () {
                        // Navigate to ProductDetail page on tap
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Productdetail(
                            ),
                          ),
                        );
                      },
                      child: ProductCard(
                        imagePath: 'images/dress.png',
                        name: 'Test Product',
                        description: 'This is a test product description.',
                        price: 100.0,
                        discountPercentage: 20,
                        rating: 4.5,
                        reviewCount: 100,
                      ),
                    ),
                ],
              ),
            ],
          ),
          // Overlay for closing the filter panel
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                children: [
                  // Semi-transparent black overlay
                  if (_controller.isCompleted)
                    GestureDetector(
                      onTap: _closeFilterPanel, // Close on tapping the overlay
                      child: Container(
                        color: Colors.black.withOpacity(0.4), // Overlay color
                      ),
                    ),
                  // Sliding filter panel on the right
                  Transform.translate(
                    offset: Offset(
                      MediaQuery.of(context).size.width * _animation.value, // Move left
                      0,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight, // Align to the right
                      child: GestureDetector(
                        onHorizontalDragEnd: (details) {
                          if (details.velocity.pixelsPerSecond.dx > 0) {
                            // User swiped right, close panel
                            _closeFilterPanel();
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8, // Set width of panel to 80%
                          color: Colors.white, // Background color of the panel
                          child: FilterPanel(), // Your filter panel widget
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
