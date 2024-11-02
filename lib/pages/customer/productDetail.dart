import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercettl/models/ShopModel.dart';
import 'package:ecommercettl/models/UserModel.dart';
import 'package:ecommercettl/pages/customer/component/PhotoGallery.dart';
import 'package:ecommercettl/pages/customer/component/ProductReview.dart';
import 'package:ecommercettl/pages/customer/component/ShopPanel.dart';
import 'package:ecommercettl/pages/customer/component/TopShopProduct.dart';
import 'package:ecommercettl/pages/customer/component/addToCart.dart';
import 'package:ecommercettl/pages/customer/component/buyNow.dart';
import 'package:ecommercettl/pages/customer/component/guarantee_card.dart';
import 'package:flutter/material.dart';
import 'package:ecommercettl/models/Product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Productdetail extends StatefulWidget {
  final Product newProduct;

  const Productdetail({
    Key? key,
    required this.newProduct,
  }) : super(key: key);

  @override
  State<Productdetail> createState() => ProductdetailState();
}

class ProductdetailState extends State<Productdetail>
    with SingleTickerProviderStateMixin {
  ShopModel? _shopData;
  UserModel? _userModel;
  bool showGuarantee = false;
  bool isCollapsed = false; // New variable for collapse state
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isLoading = true;
  int _productCount = 0;
  bool isExpanded = false;
  bool showAddtoCard = false;
  bool showBuyNow = false;
  bool showAddToCartButton = false; 

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

    _initializeShopData();
    _initializeUserData();
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

  void _toggleAddToCard() {
    setState(() {
      showAddtoCard = !showAddtoCard;
      showAddToCartButton = showAddtoCard; 
      if (showAddtoCard) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }
  void _toggleBuyNow() {
    setState(() {
      showBuyNow = !showBuyNow;
      showAddToCartButton = showBuyNow; 
      if (showBuyNow) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _toggleExpand() {
    setState(() {
      isExpanded = !isExpanded; // Toggle the expand state
    });
  }

  void _toggleCollapse() {
    setState(() {
      isCollapsed = !isCollapsed; // Toggle the collapse state
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initializeShopData() async {
    final shopData = await fetchShopDetails(widget.newProduct.userid.toString());
    if (shopData != null) {
      final productCount = await countProductsForShop(widget.newProduct.userid.toString());

      setState(() {
        _shopData = shopData;
        isLoading = false; // Data loaded
        _productCount = productCount; // Update product count
      });
    } else {
      setState(() {
        isLoading = false; // Data loaded even if shopData is null
      });
    }
  }

  Future<void> _initializeUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userData = await getUser(widget.newProduct.userid);
    setState(() {
      _userModel = userData;
    });
  }

  Future<ShopModel?> fetchShopDetails(String userId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('shopRequests')
          .where('uid', isEqualTo: userId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return ShopModel.fromFirestore(snapshot.docs.first.data());
      } else {
        print("No shop data found for userId: $userId");
        return null;
      }
    } catch (e) {
      print('Error fetching shop details: $e');
      return null;
    }
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      return snapshot.exists ? UserModel.fromFirestore(snapshot) : null;
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }

  Future<int> countProductsForShop(String userId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('userid', isEqualTo: userId)
          .get();

      return snapshot.size; // Return the count of documents
    } catch (e) {
      print('Error counting products: $e');
      return 0; // Return 0 if there's an error
    }
  }

  @override
  Widget build(BuildContext context) {
    int descriptionLength = (widget.newProduct.description.length * 0.2).round();
    String truncatedDescription = widget.newProduct.description.substring(0, descriptionLength);
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
                    ProductReview(productId: widget.newProduct.id,),
                    ShopPanel(
                      shopImg: _userModel?.imgAvatar ?? '',
                      shopName: _shopData?.shopName ?? 'Unknown Shop',
                      shopAddress: _userModel?.address ?? 'Unknown Address',
                      productCount: _productCount,
                      shopId: widget.newProduct.userid
                    ),
                    const Divider(),
                    Container(
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: TopShopProduct(userId: widget.newProduct.userid, shopName: _shopData?.shopName ??'Unknown Shop',),
                      ),
                    ),

                    const Divider(),
                    
                    // Description with overlay
                    Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: 10,
                            bottom: 50,
                            right: 10,
                            left: 10,
                          ),
                          child: Text(
                            isExpanded 
                              ? widget.newProduct.description // Show full description if expanded
                              : truncatedDescription, // Show 20% of the description if collapsed
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (!isExpanded) // Show overlay only when collapsed
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(1), // Màu ở trên (đậm)
                                    Colors.black.withOpacity(0.6), // Màu ở trên (đậm)
                                    Colors.black.withOpacity(0.1), // Màu ở dưới (nhạt hơn)
                                  ],
                                ),
                              ),
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: _toggleExpand,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    elevation: 0, // No shadow
                                  ),
                                  child: const Column(
                                    mainAxisSize: MainAxisSize.min, // Cho phép kích thước nút nhỏ nhất
                                    children: [
                                      Spacer(), // Spacer sẽ đẩy văn bản xuống dưới
                                      const Text(
                                        'Xem thêm',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                        // Show "Thu gọn" button when expanded
                        if (isExpanded)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: ElevatedButton(
                                onPressed: _toggleExpand,
                                child: const Text('Thu gọn'),
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    
                    const SizedBox(height: 60),
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
                height: MediaQuery.of(context).size.height * 0.5,
                child: GuaranteeCard(
                  onAgree: _toggleGuaranteeCard,
                ),
              ),
            ),


            if (showAddtoCard)
              GestureDetector(
                onTap: _toggleAddToCard,
                child: AnimatedOpacity(
                  opacity: showAddtoCard ? 0.7 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    color: Colors.black.withOpacity(1),
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),

            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: 0,
              right: 0,
              bottom: showAddtoCard ? 1 : -MediaQuery.of(context).size.height * 0.6,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: AddToCart(
                  product: widget.newProduct,
                  onAgree: _toggleAddToCard,
                ),
              ),
            ),

            if (showBuyNow)
              GestureDetector(
                onTap: _toggleBuyNow,
                child: AnimatedOpacity(
                  opacity: showBuyNow ? 0.7 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    color: Colors.black.withOpacity(1),
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),

            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: 0,
              right: 0,
              bottom: showBuyNow ? 1 : -MediaQuery.of(context).size.height * 0.6,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: BuyNow(
                  product: widget.newProduct,
                  onAgree: _toggleBuyNow,
                  shop: _shopData ?? ShopModel(
                    email: "",
                    reviewedAt: DateTime(TimeOfDay.hoursPerDay),
                    reviewedBy: "",
                    shopDescription: "",
                    shopName: "",
                    shopid: "",
                    status: ""
                  ),
                  customer: _userModel ?? UserModel(
                    address: "",
                    dob: "",
                    email: "",
                    fullName: "",
                    id: "",
                    imgAvatar: "",
                    password: "",
                    phone: "",
                    role: "",
                    username: "",
                  ),
                ),
              ),
            ),

            if (!showAddToCartButton)
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
                          onPressed: _toggleBuyNow,
                          child: const Text("Mua Ngay"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF15A362),
                            foregroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          onPressed: _toggleAddToCard,
                          child: const Text("Thêm vào giỏ hàng"),
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
