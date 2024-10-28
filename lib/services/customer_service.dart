import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercettl/models/CartModel.dart';
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
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in snapshot.docs) {
        vouchers.add(Voucher.fromFirestore(doc.data() as Map<String, dynamic>, doc.id));
      }
    } catch (e) {
      print("Error fetching vouchers: $e");
    }
    return vouchers;
  }

}
