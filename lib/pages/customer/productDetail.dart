import 'package:ecommercettl/pages/customer/component/PhotoGallery.dart';
import 'package:ecommercettl/pages/customer/component/ProductReview.dart';
import 'package:ecommercettl/pages/customer/component/guarantee_card.dart';
import 'package:flutter/material.dart';
import 'package:ecommercettl/models/Product.dart';


class Productdetail extends StatefulWidget {
  final Product newProduct;

  const Productdetail({
    Key? key,
    required this.newProduct
  }) : super(key: key);

  @override
  State<Productdetail> createState() => ProductdetailState();
}

class ProductdetailState extends State<Productdetail>
    with SingleTickerProviderStateMixin {
  bool showGuarantee = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  void _toggleGuaranteeCard() {
    setState(() {
      showGuarantee = !showGuarantee;
      if (showGuarantee) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.8,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: PhotoGallery(imagePaths: widget.newProduct.imageUrls),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'đ',
                                style: TextStyle(
                                  fontSize: 26,
                                  color: Colors.red,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.red,
                                ),
                              ),
                              Text(
                                '${widget.newProduct.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 32,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.newProduct.name,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const Divider(),
                          GestureDetector(
                            onTap: _toggleGuaranteeCard,
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.verified_user_outlined,
                                  color: Color(0xFF015A362),
                                ),
                                Expanded(
                                  child: Text(
                                    'Đổi ý miễn phí 15 ngày - Chính hãng 100% - .... ',
                                    style: TextStyle(fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                    ProductReview(),
                  ],
                ),
              ),
            ),

            // Overlay for the GuaranteeCard
            if (showGuarantee)
              GestureDetector(
                onTap: _toggleGuaranteeCard,
                child: AnimatedOpacity(
                  opacity: showGuarantee ? 0.7 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    color: Colors.black.withOpacity(1),
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),

            // Animated GuaranteeCard
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: 0,
              right: 0,
              bottom: showGuarantee ? 1 : -MediaQuery.of(context).size.height * 0.5,
              child: Container(
                height: MediaQuery.of(context).size.height *0.5 ,
                child: GuaranteeCard(
                  onAgree: _toggleGuaranteeCard,
                ),
              ),
            ),

            // Positioned buttons at the bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF15A362),
                          side: const BorderSide(color: Color(0xFF15A362)),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        onPressed: () {
                          // Action for button 1
                        },
                        child: const Text('Button 1'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF15A362),
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFF15A362)),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        onPressed: () {
                          // Action for button 2
                        },
                        child: const Text('Button 2'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
