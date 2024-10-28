class Product {
  final String id;
  final String name;
  final String description;
  final String brandid;
  final String categoryid;
  final String sex;
  final double affiliate;
  final double price;
  final List<String> imageUrls;
  final String userid;
  final String status;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.brandid,
    required this.categoryid,
    required this.sex,
    required this.affiliate,
    required this.price,
    required this.imageUrls,
    required this.userid,
    required this.status,
  });

  @override
  String toString() {
    
    return 'Product(id: $id ,name: $name ,description: $description, brandid: $brandid, categoryid: $categoryid, sex: $sex, affiliate: $affiliate, price: $price, imageUrls: $imageUrls, userid: $userid, status: $status)';
  }

  // Factory method to create a Product from Firestore document data
  factory Product.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Product(
      id: documentId,
      name: data['name'] ?? 'No Name',
      description: data['description'] ?? 'No Description',
      brandid: data['brandid'] ?? '',
      categoryid: data['categoryid'] ?? '',
      sex: data['sex'] ?? '',
      affiliate: data['affiliate'] ?? '',
      price: data['price'] != null ? double.parse(data['price'].toString()) : 0.0,
      imageUrls: data['imageUrl'] != null ? List<String>.from(data['imageUrl']) : [],
      userid: data['userid'] ?? '',
      status: data['status'] ?? 'inactive',
    );
  }

  // Method to convert the Product object back to a map for saving to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'brandid': brandid,
      'categoryid': categoryid,
      'sex': sex,
      'affiliate': affiliate,
      'price': price,
      'imageUrl': imageUrls,
      'userid': userid,
      'status': status,
    };
  }
}
