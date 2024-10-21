import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercettl/pages/customer/component/DealOfTheDay.dart';
import 'package:ecommercettl/pages/customer/component/FindBar.dart';
import 'package:ecommercettl/pages/customer/component/HomeAppBar.dart';
import 'package:ecommercettl/pages/customer/component/ProductCard.dart';
import 'package:ecommercettl/pages/customer/component/SliderBanner.dart';
import 'package:ecommercettl/pages/customer/component/Trending.dart';
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
              borderRadius: BorderRadius.circular(8), // Apply the border radius here
              child: SliderBanner(), // Your slider banner
            ),
          ),
          Container(
            child: DealOfTheDay(remainingTime: remainingTime),
          ),
          // Fetch products from Firestore and map them to ProductCard widgets
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('products').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              // Map Firestore data to Product objects
              final products = snapshot.data!.docs.map((doc) {
                var data = doc.data() as Map<String, dynamic>;
                return Product.fromFirestore(data, doc.id);
              }).toList();

              // Display products in a GridView
              return GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                crossAxisSpacing: 5,
                mainAxisSpacing: 10,
                childAspectRatio: 0.4,
                physics: NeverScrollableScrollPhysics(),
                children: products.map((product) {
                  return ProductCard(
                    imagePath: product.imageUrls.isNotEmpty
                        ? product.imageUrls[0] // Use first image from imageUrl list
                        : 'images/dress.png', // Fallback image
                    name: product.name,
                    description: product.description,
                    price: product.price,
                    discountPercentage: 20, // Example discount
                    rating: 4.5, // Example rating
                    reviewCount: 100, // Example review count
                  );
                }).toList(),
              );
            },
          ),
          Container(
            child: Trending(lastDate: lastDate),
          ),
          // Another section to display more products
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('products').snapshots(),
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

              return GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                crossAxisSpacing: 5,
                mainAxisSpacing: 10,
                childAspectRatio: 0.4,
                physics: NeverScrollableScrollPhysics(),
                children: products.map((product) {
                  return ProductCard(
                    imagePath: product.imageUrls.isNotEmpty
                        ? product.imageUrls[0]
                        : 'images/dress.png',
                    name: product.name,
                    description: product.description,
                    price: product.price,
                    discountPercentage: 20,
                    rating: 4.5,
                    reviewCount: 100,
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
