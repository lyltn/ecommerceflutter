import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercettl/pages/customer/component/DealOfTheDay.dart';
import 'package:ecommercettl/pages/customer/component/FindBar.dart';
import 'package:ecommercettl/pages/customer/component/HomeAppBar.dart';
import 'package:ecommercettl/pages/customer/component/ProductCard.dart';
import 'package:ecommercettl/pages/customer/component/ProductSellCard.dart';
import 'package:ecommercettl/pages/customer/component/SliderBanner.dart';
import 'package:ecommercettl/pages/customer/component/Trending.dart';
import 'package:ecommercettl/pages/customer/productDetail.dart';
import 'package:flutter/material.dart';
import 'package:ecommercettl/models/Product.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollController = ScrollController();
  List<Product> products = [];
  bool isLoading = false;
  DocumentSnapshot? lastDocument;
  int limit = 10; // Number of items to load per batch
  String remainingTime = '22h 55m 20s remaining';
  String allprodcut = "Tất cả sản phẩm";

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _fetchProducts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchProducts() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    QuerySnapshot querySnapshot;
    if (lastDocument == null) {
      // Initial query to get the first batch of products
      querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .limit(limit)
          .get();
    } else {
      // Load more products starting after the last loaded document
      querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .startAfterDocument(lastDocument!)
          .limit(limit)
          .get();
    }

    if (querySnapshot.docs.isNotEmpty) {
      lastDocument = querySnapshot.docs.last;
      setState(() {
        products.addAll(querySnapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          return Product.fromFirestore(data, doc.id);
        }).toList());
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent &&
        !isLoading) {
      _fetchProducts();
    }
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HomeAppBar(),
      ),
      body: ListView(
        controller: _scrollController,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/search');
            },
            child: Findbar(isEnabled: false),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SliderBanner(),
          ),
          DealOfTheDay(remainingTime: remainingTime),
          LayoutBuilder(
            builder: (context, constraints) {
              int columns = 2;
              int dealProductCount = 4;

              if (constraints.maxWidth > 600) {
                columns = 6;
                dealProductCount = 6;
              } else if (constraints.maxWidth > 400) {
                columns = 2;
              }

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.6,
                ),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: dealProductCount,
                itemBuilder: (context, index) {
                  if (index >= products.length) {
                    return SizedBox(); // Return an empty widget if index exceeds products length
                  }
                  final product = products[index];
                  return ProductSellCard(
                    imagePath: product.imageUrls.isNotEmpty
                        ? product.imageUrls[0]
                        : 'images/dress.png',
                    name: product.name,
                    price: product.price,
                    discountPercentage: 20,
                    rating: 5.0,
                    reviewCount: 4,
                    width: MediaQuery.of(context).size.width / columns - 15,
                    height: 350,
                  );
                },
              );
            },
          ),
          Trending(),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.6,
            ),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: products.length + (isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == products.length) {
                return Center(child: CircularProgressIndicator());
              }
              if (index >= products.length) {
                return SizedBox(); // Handle out-of-range error gracefully
              }

              final product = products[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Productdetail(newProduct: product),
                    ),
                  );
                },
                child: ProductCard(
                  imagePath: product.imageUrls.isNotEmpty
                      ? product.imageUrls[0]
                      : 'images/dress.png',
                  name: product.name,
                  price: product.price,
                  sold: 3,
                  rating: 5.0,
                  reviewCount: 4,
                  width: MediaQuery.of(context).size.width / 2 - 15,
                  height: 350,
                ),
              );
            },
          ),
          if (isLoading)
            Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
