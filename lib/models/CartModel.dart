class Cart {
  final String cartId;
  final String cusId;     // Customer ID
  final String productId;
  final String shopId;
  final String shopName;
  int quantity;     // Quantity as an integer
  final String color;
  final String size;
  final double price;
  bool isSelected;

  Cart({
    required this.cartId,
    required this.cusId,
    required this.productId,
    required this.shopId,
    required this.shopName,
    required this.quantity,
    required this.color,
    required this.size,
    required this.price,
    this.isSelected = false,
  });

  // Factory method to create a Cart from Firestore document data
  factory Cart.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Cart(
      cartId: documentId,
      cusId: data['cusid'] ?? '',
      productId: data['productid'] ?? '',
      shopId: data['shopid'] ?? '',
      shopName: data['shopName'],
      quantity: (data['quantity'] is int) 
          ? data['quantity'] 
          : int.tryParse(data['quantity'].toString()) ?? 0, // Flexible parsing
      color: data['color'] ?? '',
      size: data['size'] ?? '',
      price: data['price'] ?? 0
    );
  }

  // Method to convert the Cart object back to a map for saving to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'cusid': cusId,
      'productid': productId,
      'shopid': shopId,
      'shopName': shopName,
      'quantity': quantity,    // Store as int for simplicity
      'color': color,
      'size': size,
      'price': price
    };
  }
}
