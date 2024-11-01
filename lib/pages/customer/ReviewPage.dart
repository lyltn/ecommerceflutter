import 'package:ecommercettl/models/OrderDetail.dart';
import 'package:ecommercettl/models/Product.dart';
import 'package:ecommercettl/models/ReviewModel.dart';
import 'package:ecommercettl/pages/customer/bottomnav.dart';
import 'package:ecommercettl/services/customer_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Import for File
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class ReviewPage extends StatefulWidget {
  final String orderCode;
  final String cusId;
  const ReviewPage({super.key, required this.orderCode, required this.cusId});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List<OrderDetail>? orderDetails;
  List<Product?>? products; // List to hold fetched products
  List<double> ratings = [];
  List<String> reviews = [];
  List<List<XFile?>> selectedImages = []; // List of lists to hold selected images for each product
  bool isLoading = false; // Loading state variable

  @override
  void initState() {
    super.initState();
    fetchOrder();
  }

  void fetchOrder() async {
    CustomerService customerService = CustomerService();
    try {
      orderDetails = await customerService.fetchOrderDetailByOrderCode(widget.orderCode);
      if (orderDetails != null && orderDetails!.isNotEmpty) {
        products = await Future.wait(
          orderDetails!.map((orderDetail) => customerService.fetchProductById(orderDetail.productId)).toList(),
        );

        // Initialize ratings, reviews, and selected images lists
        ratings = List.filled(orderDetails!.length, 0.0);
        reviews = List.filled(orderDetails!.length, "");
        selectedImages = List.generate(orderDetails!.length, (_) => []);
      }
      setState(() {});
    } catch (e) {
      print("Error fetching order details: $e");
    }
  }

  Future<void> selectImages(int index) async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(); // Allow multiple image selection
    if (pickedFiles != null) {
      setState(() {
        for (var file in pickedFiles) {
          // Add the picked file to the selected images list if it's not already added
          if (!selectedImages[index].any((element) => element?.path == file.path)) {
            selectedImages[index].add(file); 
          }
        }
      });
    }
  }

  Future<void> uploadImagesAndSaveReviews() async {
    CollectionReference reviewsCollection = FirebaseFirestore.instance.collection('reviews');
    setState(() {
      isLoading = true; // Set loading state to true
    });

    try {
      for (int index = 0; index < orderDetails!.length; index++) {
        if (reviews[index].isNotEmpty) {
          List<String> imageUrls = [];

          // Upload images to Firebase Storage and get URL
          for (var imageFile in selectedImages[index]) {
            if (imageFile != null) {
              String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '_' + imageFile.name;
              Reference storageRef = FirebaseStorage.instance.ref().child('reviews/$fileName');

              // Upload file to Firebase Storage
              await storageRef.putFile(File(imageFile.path));
              String downloadUrl = await storageRef.getDownloadURL();
              imageUrls.add(downloadUrl); // Add URL to the list
            }
          }

          // Create ReviewModel with color and size from order
          ReviewModel reviewModel = ReviewModel(
            productId: orderDetails![index].productId,
            rating: ratings[index],
            review: reviews[index],
            images: imageUrls, // Store image URLs
            color: orderDetails![index].color, // Get color from order
            size: orderDetails![index].size,   // Get size from order
            cusId: widget.cusId
          );

          // Save to Firestore
          await reviewsCollection.add(reviewModel.toFirestore());
        }
      }
      CustomerService customerService = CustomerService();
      await customerService.updateOrderReviews(widget.orderCode);
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Đánh giá đã được gửi thành công!'),
      ));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNav(tempIndex: 2,),)); // Pop to the previous screen
    } catch (e) {
      print("Error saving reviews: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Đã xảy ra lỗi khi gửi đánh giá!'),
      ));
    } finally {
      setState(() {
        isLoading = false; // Set loading state to false after completion
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Đánh giá sản phẩm',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            InkWell(
              onTap: () {
                if (!isLoading) { // Only allow sending if not loading
                  uploadImagesAndSaveReviews(); // Save reviews when tapped
                }
              },
              child: Text(
                'Gửi',
                style: TextStyle(
                  fontSize: 16,
                  color: const Color.fromARGB(255, 188, 69, 9),
                ),
              ),
            ),
          ],
        ),
      ),
      body: isLoading ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: double.infinity, // Constrain width to prevent infinite size
          child: Column(
            children: [
              if (orderDetails == null) ...[
                Center(child: CircularProgressIndicator()),
              ] else if (orderDetails!.isEmpty) ...[
                Center(child: Text("No order details found.")),
              ] else ...[
                for (int index = 0; index < orderDetails!.length; index++) ...[
                  ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: products![index]?.imageUrls != null
                          ? Image.network(
                              products![index]!.imageUrls[0]!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : Container(width: 50, height: 50, color: Colors.grey),
                    ),
                    title: Text(
                      products![index]?.name ?? "Unknown Product",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text("Màu: ${orderDetails![index].color}, Size: ${orderDetails![index].size}"),
                  ),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
                  ),
                  // Row for rating, image selection, and review input
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the start
                      children: [
                        // Star rating label
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start, // Aligns stars to the start
                          children: [
                            Text(
                              'Chất lượng sản phẩm: ',
                              maxLines: 1,
                            ),
                            // Stars
                            Row(
                              children: [
                                for (int starIndex = 1; starIndex <= 5; starIndex++) ...[
                                  InkWell(
                                    child: Icon(
                                      starIndex <= ratings[index] ? Icons.star : Icons.star_border,
                                      color: Colors.amber,
                                      size: 30,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        ratings[index] = starIndex.toDouble();
                                      });
                                    },
                                  ),
                                  SizedBox(width: 4,)
                                ],
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16), 
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5, // Set width to half the screen width
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white, // No background color
                                  foregroundColor: Color(0xFF15A362), // Text color
                                  side: BorderSide(color: Color(0xFF15A362), width: 1), // Red border
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero, // No rounded corners
                                  ),
                                ),
                                onPressed: () => selectImages(index),
                                child: Padding(
                                  padding: EdgeInsets.all(6),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
                                    children: [
                                      Icon(Icons.camera_alt, size: 24), // Camera icon
                                      SizedBox(height: 4), // Space between icon and text
                                      Text('Thêm hình ảnh', textAlign: TextAlign.center), // Button text
                                    ],
                                  ),
                                )
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 16), // Spacing

                  // GridView for selected images
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(), // Disable scrolling
                    shrinkWrap: true, // Size grid based on children
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Number of columns in grid
                      mainAxisSpacing: 8, // Spacing between rows
                      crossAxisSpacing: 8, // Spacing between columns
                    ),
                    itemCount: selectedImages[index].length, // Count of selected images
                    itemBuilder: (context, imageIndex) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8.0), // Round corners
                        child: Image.file(
                          File(selectedImages[index][imageIndex]!.path),
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16), // Spacing

                  // TextField for review input
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      maxLines: 3, // Max lines for the text field
                      onChanged: (value) {
                        reviews[index] = value; // Update review text
                      },
                      decoration: InputDecoration(
                        labelText: 'Nhập nhận xét của bạn...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
