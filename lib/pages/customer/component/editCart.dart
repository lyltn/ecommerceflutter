import 'package:ecommercettl/models/CartModel.dart';
import 'package:ecommercettl/models/Product.dart';
import 'package:ecommercettl/services/customer_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditCart extends StatefulWidget {
  final ValueChanged<String> onCartSizeUpdated;
  final ValueChanged<String> onCartColorUpdated;
  final ValueChanged<int> onCartQuantityUpdated;
  final Product product;
  final Cart cart;

  const EditCart({Key? key, required this.product, required this.onCartSizeUpdated, required this.onCartColorUpdated, required this.onCartQuantityUpdated, required this.cart}) : super(key: key);

  @override
  State<EditCart> createState() => _EditCartState();
}

class _EditCartState extends State<EditCart> {
  int totalQuantity = 0;
  List<String> sizes = []; // List to hold sizes
  List<String> colors = []; // List to hold colors
  String? selectedSize; // Variable to hold the selected size
  String? selectedColor; // Variable to hold the selected color
  int quantitySelected = 0;

  @override
  void initState() {
    super.initState();
    _fetchSizes(); // Fetch sizes when the widget is initialized
    _fetchColors(); // Fetch colors when the widget is initialized
    _fetchInventoryDocuments();
  }

  // Fetch the inventory documents from Firestore whenever a selection changes
  void _fetchInventoryDocuments() async {
    // Get all documents where product ID matches
    var inventorySnapshot = await FirebaseFirestore.instance
        .collection('classifys')
        .where('productid', isEqualTo: widget.product.id)
        .get();

    // Update quantity based on selection
    _updateQuantity(inventorySnapshot.docs);
  }

  // Update the total quantity based on the selected size and color
  void _updateQuantity(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    int quantitySum = 0;

    for (var doc in docs) {
      bool sizeMatches = (selectedSize == null || doc['size'] == selectedSize);
      bool colorMatches = (selectedColor == null || doc['color'] == selectedColor);

      if (sizeMatches && colorMatches) {
        quantitySum += (doc['quantity'] as num).toInt();
      }
    }

    setState(() {
      totalQuantity = quantitySum; // Update total quantity based on selections
    });
  }

  // Fetch sizes from Firestore
  void _fetchSizes() async {
    var sizeSnapshot = await FirebaseFirestore.instance
        .collection('classifys')
        .where('productid', isEqualTo: widget.product.id)
        .get();

    Set<String> uniqueSizes = {}; // Store unique sizes

    for (var doc in sizeSnapshot.docs) {
      uniqueSizes.add(doc['size']); // Add size to the Set to avoid duplicates
    }

    setState(() {
      sizes = uniqueSizes.toList(); // Convert Set to List for the UI
    });
  }

  // Fetch colors from Firestore
  void _fetchColors() async {
    var colorSnapshot = await FirebaseFirestore.instance
        .collection('classifys')
        .where('productid', isEqualTo: widget.product.id)
        .get();

    Set<String> uniqueColors = {}; // Store unique colors

    for (var doc in colorSnapshot.docs) {
      uniqueColors.add(doc['color']); // Add color to the Set to avoid duplicates
    }

    setState(() {
      colors = uniqueColors.toList(); // Convert Set to List for the UI
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300] ?? Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.product.imageUrls[0],
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
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
                            '${widget.product.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 32,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      Text("Kho: $totalQuantity"),
                    ],
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start, // Align text to the left
                children: const [
                  Text('Màu', style: TextStyle(fontSize: 14)),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                children: colors.map((color) {
                  return TextButton(
                    onPressed: () {
                      setState(() {
                        selectedColor = selectedColor == color ? null : color;
                      });
                      _fetchInventoryDocuments(); // Refetch inventory after color selection
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedColor == color ? Color(0xFF15A362) : Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      color,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 5),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start, // Align text to the left
                children: const [
                  Text('Kích thước', style: TextStyle(fontSize: 14)),
                ],
              ),
              const SizedBox(height: 5),
              Wrap(
                spacing: 8.0,
                children: sizes.map((size) {
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedSize = selectedSize == size ? null : size;
                      });
                      _fetchInventoryDocuments(); // Refetch inventory after size selection
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedSize == size ? Color(0xFF15A362) : Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      )
                    ),
                    child: Text(
                      size,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 5,),
              
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between the text and buttons
                children: [
                  const Text('Số lượng'),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (widget.cart.quantity > 0) {
                              widget.cart.quantity--; 
                            }
                          });
                        },
                      ),
                      Text(
                        '${widget.cart.quantity}', // Display current quantity
                        style: const TextStyle(fontSize: 20),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            widget.cart.quantity++; // Increase quantity
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5,),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: (selectedSize != null && selectedColor != null && widget.cart.quantity != 0) 
                      ? () async {
                          print("Color selected: ${selectedColor}");
                          print("Size selected: ${selectedSize}");
                          print("Quantity: ${widget.cart.quantity}");

                          CustomerService customerService = CustomerService();
                          String shopName = await customerService.fetchShopNameFromDatabase(widget.product.userid);
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          String? cusId = prefs.getString('cusId');
                          if (cusId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Vui lòng đăng nhập để thêm vào giỏ hàng!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            return; 
                          }
                          print("EditCartNe");
                          await customerService.updateCartById(widget.cart.cartId, widget.cart.quantity, selectedSize!,  selectedColor!);
                          widget.onCartColorUpdated(selectedColor ?? "");
                          widget.onCartSizeUpdated(selectedSize?? "");
                          widget.onCartQuantityUpdated(widget.cart.quantity ?? 0);
                          // Optionally, reset selections after adding to cart
                          setState(() {
                            selectedSize = null;
                            selectedColor = null;
                            quantitySelected = 0;
                            },
                          );

                      } 
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Vui lòng chọn màu, kích thước và số lượng muốn thêm!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                      },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      (selectedSize != null && selectedColor != null) 
                          ? Color(0xFF15A362) 
                          : Colors.grey[300] // Set to grey when disabled
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  child: Text(
                    'Xác nhận',
                    style: TextStyle(
                      color: (selectedSize != null && selectedColor != null) 
                          ? Colors.white 
                          : Colors.black54, // Change text color when disabled
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}