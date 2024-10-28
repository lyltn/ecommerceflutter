class Cart {
  final String cartId;
  final String cusId;  // Renamed from cusid for clarity
  final String productId;
  final int quantity;    // Changed to int for quantity representation
  final String color;
  final String size;

  Cart({
    required this.cartId,
    required this.cusId,
    required this.productId,
    required this.quantity,
    required this.color,
    required this.size,
  });

  // Factory method to create a Cart from Firestore document data
  factory Cart.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Cart(
      cartId: documentId,
      cusId: data['cusid'] ?? '', // Adjust field name if necessary
      productId: data['productid'] ?? '',
      quantity: data['quantity'] != null ? int.parse(data['quantity'].toString()) : 0, // Assuming quantity is stored as a string
      color: data['color'] ?? '',
      size: data['size'] ?? '',
    );
  }

  // Method to convert the Cart object back to a map for saving to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'cusid': cusId,          // Adjust field name if necessary
      'productid': productId,
      'quantity': quantity.toString(), // Convert int to string if necessary
      'color': color,
      'size': size,
    };
  }
}
