import 'package:ecommercettl/pages/customer/component/DealOfTheDay.dart';
import 'package:ecommercettl/pages/customer/component/FindBar.dart';
import 'package:ecommercettl/pages/customer/component/HomeAppBar.dart';
import 'package:ecommercettl/pages/customer/component/ProductCard.dart';
import 'package:ecommercettl/pages/customer/component/SearchScreen.dart';
import 'package:ecommercettl/pages/customer/component/SliderBanner.dart';
import 'package:ecommercettl/pages/customer/component/Trending.dart';
import 'package:ecommercettl/widget/widget_support.dart';
import 'package:flutter/material.dart';

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
      body: ListView (
        children: [
          GestureDetector(
            onTap: () => {
              Navigator.pushNamed(context, '/search'),
            },
            child: Findbar(isEnabled: false,),
          ), // Wrap Findbar with GestureDetector
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8), // Apply the border radius here
              child: SliderBanner(), // Your slider banner
            ),
          ),
          Container(
            child: DealOfTheDay(remainingTime: remainingTime),
          ),
          GridView.count(
            crossAxisCount: 2 ,
            shrinkWrap: true,
            crossAxisSpacing: 5,
            mainAxisSpacing: 10,
            childAspectRatio: 0.4,
            physics: NeverScrollableScrollPhysics(),
            children: [
              for(int i=0;i<=3;i++)
              ProductCard(
              imagePath: 'images/dress.png',
              name: 'Test Product',
              description: 'This is a test product description.',
              price: 100.0,
              discountPercentage: 20,
              rating: 4.5,
              reviewCount: 100,
              ),
            ],
          ),
          Container(
            child: Trending(lastDate: lastDate),
          ),
          GridView.count(
            crossAxisCount: 2 ,
            shrinkWrap: true,
            crossAxisSpacing: 5,
            mainAxisSpacing: 10,
            childAspectRatio: 0.4,
            physics: NeverScrollableScrollPhysics(),
            children: [
              for(int i=0;i<=3;i++)
              ProductCard(
              imagePath: 'images/dress.png',
              name: 'Test Product',
              description: 'This is a test product description.',
              price: 100.0,
              discountPercentage: 20,
              rating: 4.5,
              reviewCount: 100,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
