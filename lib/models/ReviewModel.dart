class ReviewModel {
  final String productId;
  final String color;
  final String size;
  final double rating;
  final String review;
  final List<String> images; // Danh sách URL hình ảnh
  final String cusId;

  ReviewModel({
    required this.productId,
    required this.color,
    required this.size,
    required this.rating,
    required this.review,
    required this.images,
    required this.cusId
  });

  // Phương thức tạo một đối tượng ReviewModel từ dữ liệu Firestore
  factory ReviewModel.fromFirestore(Map<String, dynamic> data) {
    return ReviewModel(
      productId: data['productId'] ?? '',
      color: data['color'] ?? '',
      size: data['size'] ?? '',
      rating: data['rating']?.toDouble() ?? 0.0,
      review: data['review'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      cusId: data['cusId']
    );
  }

  // Phương thức chuyển đổi ReviewModel thành Map để lưu vào Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'productId': productId,
      'color': color,
      'size': size,
      'rating': rating,
      'review': review,
      'images': images,
      'cusId': cusId,
    };
  }
}
