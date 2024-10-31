import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercettl/models/CartModel.dart';
import 'package:ecommercettl/models/OrderDetail.dart';
import 'package:ecommercettl/models/OrderModel.dart';
import 'package:ecommercettl/models/Product.dart';
import 'package:ecommercettl/models/VoucherModel.dart';

class CustomerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addToCart(String userId, String productId, String shopId, String shopName, int quantity, String? selectedSize, String? selectedColor, double price) async {
    try {
      // Create a Cart object without a cartid
      Cart cartItem = Cart(
        cartId: '', // This will be set after adding to Firestore
        cusId: userId,
        productId: productId,
        shopName: shopName,
        shopId: shopId,
        quantity: quantity,
        color: selectedColor ?? '',
        size: selectedSize ?? '',
        price: price,
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
    String note,
    String? productImg,
    String? productName,
    double? productPrice,
    int? productCount,
    String? color,
    String? size,
    int? quantity

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
      note: note,
      productImg: productImg,
      productName: productName,
      productPrice: productPrice,
      productCount:  productCount,
      color: color,
      size: size,
      quantity: quantity
    );
     Map<String, dynamic> orderData = newOrder.toFirestore();
    try {
      DocumentReference docRef = await ordersCollection.add(orderData);
      print("Order added successfully with ID: ${docRef.id}");
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

  Future<List<Cart>> fetchCartListByCusId(String cusId) async {
    try {
      CollectionReference ordersCollection = _firestore.collection('carts');
      
      QuerySnapshot querySnapshot = await ordersCollection
          .where('cusid', isEqualTo: cusId)
          .get();
      
      List<Cart> cartList = querySnapshot.docs.map((doc) {
        return Cart.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      
      return cartList;
    } catch (e) {
      print("Error fetching cart list for customer ID $cusId: $e");
      return [];
    }
  }

  Future<Product?> loadProductDataById(String productId) async {
    try {
      DocumentReference productDoc = _firestore.collection('products').doc(productId);
      DocumentSnapshot doc = await productDoc.get();

      if (doc.exists) {
        Product product = Product.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
        return product;
      } else {
        return null; // Document does not exist
      }
    } catch (e) {
      print("Error fetching product data for product ID $productId: $e");
      return null;
    }
  }

  Future<String> fetchShopNameFromDatabase(String shopId) async {
    try {
      CollectionReference nameCollection = _firestore.collection('shopRequests');

      QuerySnapshot querySnapshot = await nameCollection.where('uid', isEqualTo: shopId).get();

      if (querySnapshot.docs.isNotEmpty) {
        String shopName = querySnapshot.docs.first['shopName'] as String; // Cast to String
        return shopName; // Return the shop name
      } else {
        return "Shop not found"; // Return a default message if no shop found
      }
    } catch (e) {
      print("Error fetching shop name for shop ID $shopId: $e");
      return "Error fetching shop name"; // Return an error message
    }
  }

 Future<void> updateCartQuantityById(String cartId, int newQuantity) async {
    try {
      CollectionReference cartItemsRef = _firestore.collection('carts');

      await cartItemsRef.doc(cartId).update({
        'quantity': newQuantity,
      });

      print('Cart item quantity updated successfully.');
    } catch (e) {
      print("Error updating cart item quantity: $e");
      // Handle the error (e.g., show a message to the user)
    }
  }
  Future<void> updateCartById(String cartId, int newQuantity, String newSize, String newColor) async {
    try {
      CollectionReference cartItemsRef = _firestore.collection('carts');

      await cartItemsRef.doc(cartId).update({
        'quantity': newQuantity,
        'size': newSize,
        'color': newColor
      });

      print('Cart item updated successfully.');
    } catch (e) {
      print("Error updating cart item : $e");
      // Handle the error (e.g., show a message to the user)
    }
  }
}
