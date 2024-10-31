import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  final CollectionReference orders =
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

  Future<void> updateOrderStatus(String idOrder) {
    return orders.doc(idOrder).update({
      'status': 'Đã duyệt',
    });
  }
}
