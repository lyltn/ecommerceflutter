import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercettl/pages/customer/component/DealOfTheDay.dart';
import 'package:ecommercettl/pages/customer/component/FindBar.dart';
import 'package:ecommercettl/pages/customer/component/HomeAppBar.dart';
import 'package:ecommercettl/pages/customer/component/ProductCard.dart';
import 'package:ecommercettl/pages/customer/component/SliderBanner.dart';
import 'package:ecommercettl/pages/customer/component/Trending.dart';
import 'package:ecommercettl/pages/customer/productDetail.dart';
import 'package:ecommercettl/widget/widget_support.dart';
import 'package:flutter/material.dart';
import 'package:ecommercettl/models/Product.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String remainingTime = '22h 55m 20s remaining';
  String lastDate = 'Last Date 29/11/2024';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HomeAppBar(),
      ),
      body: ListView(
        children: [
          GestureDetector(
            onTap: () => {
              Navigator.pushNamed(context, '/search'),
            },
            child: Findbar(isEnabled: false),
          ),
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SliderBanner(),
            ),
          ),
          Container(
            child: DealOfTheDay(remainingTime: remainingTime),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('products').limit(4).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final products = snapshot.data!.docs.map((doc) {
                var data = doc.data() as Map<String, dynamic>;
                return Product.fromFirestore(data, doc.id);
              }).toList();

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.6, // Adjust this value to change the card's aspect ratio
                ),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: products.length,
                itemBuilder: (context, index) {
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
                      discountPercentage: 20,
                      rating: 5.0,
                      reviewCount: 4,
                      width: MediaQuery.of(context).size.width / 2 - 15 , // Adjust card width
                      height: 350, // Set a fixed height for the card
                    ),
                  );
                },
              );
            },
          ),
          Container(
            child: Trending(lastDate: lastDate),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('products').limit(4).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final products = snapshot.data!.docs.map((doc) {
                var data = doc.data() as Map<String, dynamic>;
                return Product.fromFirestore(data, doc.id);
              }).toList();

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.6, // Adjust this value to change the card's aspect ratio
                ),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(
                    imagePath: product.imageUrls.isNotEmpty
                        ? product.imageUrls[0]
                        : 'images/dress.png',
                    name: product.name,
                    price: product.price,
                    discountPercentage: 20,
                    rating: 4.5,
                    reviewCount: 100,
                    width: MediaQuery.of(context).size.width / 2 - 15, // Adjust card width
                    height: 350, // Set a fixed height for the card
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}