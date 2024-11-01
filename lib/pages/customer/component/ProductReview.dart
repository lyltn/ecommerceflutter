import 'package:ecommercettl/models/ReviewModel.dart';
import 'package:ecommercettl/models/UserModel.dart';
import 'package:ecommercettl/services/customer_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Make sure to import this for Firestore

import 'package:ecommercettl/models/ReviewModel.dart';
import 'package:ecommercettl/models/UserModel.dart';
import 'package:ecommercettl/services/customer_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductReview extends StatefulWidget {
  final String productId;

  ProductReview({required this.productId});

  @override
  _ProductReviewState createState() => _ProductReviewState();
}

class _ProductReviewState extends State<ProductReview> {
  bool _showAllReviews = false; // State to toggle between showing all reviews or limited reviews

  Future<List<ReviewModel>> getReviewsByShopId(String proId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('reviews')
        .where('productId', isEqualTo: proId)
        .get();
    return snapshot.docs.map((doc) => ReviewModel.fromFirestore(doc.data())).toList();
  }

  Future<UserModel> getUserById(String cusId) async {
    CustomerService customerService = CustomerService();
    UserModel? user = await customerService.getCustomerInfo(cusId);
    
    if (user != null) {
      return user; // Return the user model if found
    } else {
      throw Exception('User not found'); // Throw an exception if not found
    }
  }

  Widget _buildStarRating(double averageRating) {
    List<Widget> stars = [];
    int fullStars = averageRating.floor(); // Full stars
    bool hasHalfStar = averageRating - fullStars >= 0.5; // Check for half star

    for (int i = 0; i < 5; i++) {
      if (i < fullStars) {
        stars.add(Icon(Icons.star, color: Colors.yellow, size: 20)); // Full star
      } else if (i == fullStars && hasHalfStar) {
        stars.add(Icon(Icons.star_half, color: Colors.yellow, size: 20)); // Half star
      } else {
        stars.add(Icon(Icons.star_border, color: Colors.yellow, size: 20)); // Empty star
      }
    }
    return Row(children: stars);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Đánh giá sản phẩm',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 5),

          // FutureBuilder to fetch reviews
          FutureBuilder<List<ReviewModel>>(
            future: getReviewsByShopId(widget.productId), // Fetch reviews
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator()); // Loading indicator
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}')); // Error handling
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Chưa có đánh giá nào.')); // No reviews
              }

              final reviews = snapshot.data!; // List of reviews
              double totalRating = 0.0;
              int reviewCount = reviews.length;

              // Calculate total rating
              for (var review in reviews) {
                totalRating += review.rating;
              }

              double averageRating = reviewCount > 0 ? totalRating / reviewCount : 0.0;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display average rating with stars
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStarRating(averageRating),
                      SizedBox(height: 10),
                      Text(
                        '${averageRating.toStringAsFixed(1)}/5 ($reviewCount đánh giá)', 
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Display reviews (limit to 2 or all based on the toggle)
                  ...List.generate(_showAllReviews ? reviews.length : (reviews.length < 2 ? reviews.length : 2), (index) {
                    final review = reviews[index]; // Get individual review

                    return FutureBuilder<UserModel>(
                      future: getUserById(review.cusId), // Fetch user info
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator()); // Loading user info
                        } else if (userSnapshot.hasError) {
                          return Center(child: Text('Error loading user info: ${userSnapshot.error}'));
                        } else if (!userSnapshot.hasData) {
                          return SizedBox(); // No user data
                        }

                        final user = userSnapshot.data!; // User data

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(user.imgAvatar ?? 'images/logoCus.png'), // User avatar
                                      radius: 20,
                                    ),
                                    SizedBox(height: 5),
                                    Text(user.username, // Display user name
                                        style: TextStyle(fontWeight: FontWeight.bold)),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: List.generate(5, (starIndex) {
                                        return Icon(
                                          starIndex < review.rating ? Icons.star : Icons.star_border,
                                          color: Colors.yellow,
                                          size: 14,
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        review.review,
                                        style: TextStyle(height: 1.2),
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        children: List.generate(review.images.length, (imageIndex) {
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 10.0),
                                            child: Image.network(
                                              review.images[imageIndex],
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                  Divider(
                    color: Colors.black,
                    thickness: 0.5,
                    indent: 0,
                    endIndent: 0,
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _showAllReviews = !_showAllReviews; // Toggle the view
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_showAllReviews ? 'Ẩn bớt' : 'Xem tất cả'), // Change text based on state
                          Icon(Icons.arrow_right),
                        ],
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
}
