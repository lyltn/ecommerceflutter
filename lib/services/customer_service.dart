import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercettl/models/CartModel.dart';
import 'package:ecommercettl/models/OrderDetail.dart';
import 'package:ecommercettl/models/OrderModel.dart';
import 'package:ecommercettl/models/Product.dart';
import 'package:ecommercettl/models/VoucherModel.dart';

class CustomerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addToCart(String userId, String productId, int quantity, String? selectedSize, String? selectedColor) async {
    try {
      // Create a Cart object without a cartid
      Cart cartItem = Cart(
        cartId: '', // This will be set after adding to Firestore
        cusId: userId,
        productId: productId,
        quantity: quantity,
        color: selectedColor ?? '',
        size: selectedSize ?? '',
      );

      DocumentReference docRef = await _firestore.collection('carts').add(cartItem.toFirestore());
      
      await docRef.update({'cartid': docRef.id});

      print("Item added to cart successfully with cartid: ${docRef.id}");
    } catch (e) {
      print("Failed to add item to cart: $e");
    }
  }
  
  Future<List<Voucher>> fetchVouchersByShopId(String userId) async {
    List<Voucher> vouchers = [];
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('vouchers')
          .where('userID', isEqualTo: userId)
          .get();
      print("Documents fetched: ${snapshot.docs.length}"); // Add this line
      for (var doc in snapshot.docs) {
        vouchers.add(Voucher.fromMap(doc.data() as Map<String, dynamic>, doc.id));
      }
    } catch (e) {
      print("Error fetching vouchers: $e");
    }
    return vouchers;
  }
  Future<List<Voucher>> fetchVouchersByADmin() async {
    List<Voucher> vouchers = [];
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('vouchers')
          .where('role', isEqualTo: "ADMIN")
          .get();
      print("Documents fetched admin: ${snapshot.docs.length}"); // Add this line
      for (var doc in snapshot.docs) {
        vouchers.add(Voucher.fromMap(doc.data() as Map<String, dynamic>, doc.id));
      }
    } catch (e) {
      print("Error fetching vouchers: $e");
    }
    return vouchers;
  }

    Future<void> addOrder(
    String orderCode,
    DateTime orderDate,
    String shopVoucher,
    String adminVoucher,
    double total,
    String cusId,
    String name,
    String phone,
    String address, 
    String status,
    String note
  ) async {
    // Reference to the Firestore collection
    CollectionReference ordersCollection = FirebaseFirestore.instance.collection('orders');

    // Create a new Order object
    OrderModel newOrder = OrderModel(
      orderCode: orderCode,
      orderDate: orderDate,
      shopVoucher: shopVoucher,
      adminVoucher: adminVoucher,
      total: total,
      cusId: cusId,
      name: name,
      phone: phone,
      address: address,
      status: status,
      note: note
    );

    // Convert the Order object to a map
    Map<String, dynamic> orderData = newOrder.toFirestore();

    try {
      // Add the order to Firestore
      await ordersCollection.add(orderData);
      print("Order added successfully!");
    } catch (e) {
      print("Failed to add order: $e");
    }
  }
  Future<void> addOrderDetails(
    String orderCode,
    String productId,
    String cusId,
    String size,
    String color, 
    int quantity
  ) async {
    // Reference to the Firestore collection
    CollectionReference ordersCollection = FirebaseFirestore.instance.collection('orderdetails');

    // Create a new Order object
    OrderDetail newOrder = OrderDetail(
      orderCode: orderCode,
      productId: productId,
      cusId: cusId,
      color: color,
      size: size,
      quantity: quantity
    );

    // Convert the Order object to a map
    Map<String, dynamic> orderData = newOrder.toFirestore();
    try {
      // Add the order to Firestore
      await ordersCollection.add(orderData);
      print("Order added successfully!");
    } catch (e) {
      print("Failed to add order: $e");
    }
  }

  Future<List<OrderModel>> fetchOrder(String cusId, String query) async {
    try {
      CollectionReference ordersCollection = _firestore.collection('orders');
      
      QuerySnapshot querySnapshot = await ordersCollection
          .where('cusId', isEqualTo: cusId)
          .where('status', isEqualTo: query)
          .get();
      print("cusidne: ${cusId}");
      List<OrderModel> orderList = querySnapshot.docs.map((doc) {
        return OrderModel.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
      
      return orderList;
    } catch (e) {
      // Handle any errors that occur during the fetch
      print('Error fetching orders: $e');
      return [];
    }
  }

  Future<OrderDetail?> fetchOrderDetail(String orderCode) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('orderdetails')
          .where('orderCode', isEqualTo: orderCode)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var data = snapshot.docs.first.data();
        print('Fetched order detail data: $data'); // In ra dữ liệu để kiểm tra
        return OrderDetail.fromFirestore(data);
      } else {
        print('No order detail found for orderCode: $orderCode');
      }
    } catch (e) {
      print('Error fetching order detail: $e');
    }
    return null;
  }

  Future<Product?> fetchProductById(String productId) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId) // Sử dụng doc() để lấy tài liệu theo document id
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return Product.fromFirestore(data, snapshot.id); // Trả về sản phẩm
      }
    } catch (e) {
      print('Error fetching product: $e');
    }
    return null; // Trả về null nếu không tìm thấy sản phẩm
  }
  Future<int> numberOfProduct(String ordercode) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('orderdetails')
          .where('orderCode', isEqualTo: ordercode)
          .get();
          
      // Đếm số tài liệu (documents) có orderCode bằng ordercode
      return snapshot.docs.length;
    } catch (e) {
      print('Error numberOfProduct: $e');
    }
    
    return 0; // Trả về 0 nếu có lỗi
  }
}
