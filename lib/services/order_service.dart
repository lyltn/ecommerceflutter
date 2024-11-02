import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  static final CollectionReference orders =
      FirebaseFirestore.instance.collection('orders');

  //Create--by zungcao
  Future<void> addOrder(
    dynamic orderCode,
    dynamic orderStatusId,
    dynamic voucherCode,
    dynamic total,
    dynamic name,
    dynamic phone,
    dynamic address,
    dynamic status,
    dynamic userId,
  ) {
    return orders.add({
      'orderCode': orderCode,
      'orderDate': Timestamp.now(),
      'orderStatusId': orderStatusId,
      'voucherCode': voucherCode,
      'total': total,
      'userId': userId,
      'name': name,
      'phone': phone,
      'address': address,
      'status': status,
    });
  }

  //Read--by zungcao
  Stream<QuerySnapshot> getOrderStream() {
    final ordersStream =
        orders.orderBy('orderDate', descending: true).snapshots();
    return ordersStream;
  }

  //Delete--by zungcao
  Future<void> deleteOrder(String docId) {
    return orders.doc(docId).delete();
  }

  Future<void> updateOrderStatus(String idOrder, String status) {
    return orders.doc(idOrder).update({
      'status': status,
    });
  }

  static Future<int> getOrderCountByShopId(String shopId) async {
    final QuerySnapshot snapshot =
        await orders.where('shopId', isEqualTo: shopId).get();
    return snapshot.size;
  }

  static Future<double> getTotalByShopIdAndStatus(String shopId) async {
    double totalAmount = 0.0;

    final QuerySnapshot snapshot = await orders
        .where('shopId', isEqualTo: shopId)
        .where('status', isEqualTo: 'Đã nhận hàng đặt')
        .get();

    for (var doc in snapshot.docs) {
      totalAmount += (doc['total'] ?? 0.0) as double;
    }

    return totalAmount;
  }

  static Future<int> getTotalByShopId(String shopId) async {
    final QuerySnapshot snapshot = await orders
        .where('shopId', isEqualTo: shopId)
        .where('status', isEqualTo: 'Đã nhận hàng đặt')
        .get();
    return snapshot.size;
  }

  static Future<int> getTotalOrderCount() async {
    try {
      QuerySnapshot snapshot = await orders.get();
      return snapshot.size;
    } catch (e) {
      print("Error getting total order count: $e");
      return 0; // Trả về 0 nếu có lỗi xảy ra
    }
  }
}
