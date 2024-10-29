import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercettl/models/CartModel.dart';
import 'package:ecommercettl/models/OrderDetail.dart';
import 'package:ecommercettl/models/OrderModel.dart';
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
    double total, // Assuming total is a double
    String cusId,
    String name,
    String phone,
    String address, // Fixed typo from 'adress' to 'address'
    String status,
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
}
