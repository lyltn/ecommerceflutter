import 'package:ecommercettl/pages/customer/component/ProductCard.dart';
import 'package:ecommercettl/services/customer_service.dart';
import 'package:flutter/material.dart';
import 'package:ecommercettl/pages/customer/component/FilterAction.dart';
import 'package:ecommercettl/pages/customer/component/FindBar.dart';
import 'package:ecommercettl/pages/customer/component/FilterPanel.dart';
import 'package:ecommercettl/pages/customer/productDetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercettl/models/Product.dart';

class SearchImageProduct extends StatefulWidget {
  final List<String> listProductId;
  const SearchImageProduct({super.key, required this.listProductId});

  @override
  State<SearchImageProduct> createState() => SearchProductState();
}

class SearchProductState extends State<SearchImageProduct> with SingleTickerProviderStateMixin {
  String? searchQuery;
  List<Product> listProduct = [];
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
    _fetchProducts(widget.listProductId);
  }

  void _fetchProducts(List<String> productListId) async {
    CustomerService customerService = CustomerService();
    try {
      for (var productId in productListId) {
        final product = await customerService.fetchProductById(productId);
        if (product != null) {
          setState(() {
            listProduct.add(product);
          });
        }
      }
      print("Products fetched successfully.");
    } catch (e) {
      print("Error fetching products: $e");
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
          Column(
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
              Expanded(
                child: GridView.builder(
                  itemCount: listProduct.length,
                  padding: const EdgeInsets.all(10.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns
                    crossAxisSpacing: 5, // Horizontal spacing
                    mainAxisSpacing: 10, // Vertical spacing
                    childAspectRatio: 0.6, // Aspect ratio of each item
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Productdetail(newProduct: listProduct[index]),
                          ),
                        );
                      },
                      child: ProductCard(
                        imagePath: listProduct[index].imageUrls.isNotEmpty
                            ? listProduct[index].imageUrls[0]
                            : 'images/dress.png',
                        name: listProduct[index].name,
                        price: listProduct[index].price,
                        rating: 5,
                        reviewCount: 4,
                        width: MediaQuery.of(context).size.width / 2 - 15,
                        height: 350,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          // Overlay for closing the filter panel
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                children: [
                  if (_controller.isCompleted)
                    GestureDetector(
                      onTap: _closeFilterPanel,
                      child: Container(
                        color: Colors.black.withOpacity(0.4),
                      ),
                    ),
                  Transform.translate(
                    offset: Offset(
                      MediaQuery.of(context).size.width * _animation.value,
                      0,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onHorizontalDragEnd: (details) {
                          if (details.velocity.pixelsPerSecond.dx > 0) {
                            _closeFilterPanel();
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          color: Colors.white,
                          child: FilterPanel(),
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
