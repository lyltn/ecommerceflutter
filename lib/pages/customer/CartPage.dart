import 'package:ecommercettl/models/CartModel.dart';
import 'package:ecommercettl/models/Product.dart';
import 'package:ecommercettl/models/UserModel.dart';
import 'package:ecommercettl/pages/customer/CheckOutCart.dart';
import 'package:ecommercettl/pages/customer/bottomnav.dart';
import 'package:ecommercettl/pages/customer/component/CartItem.dart';
import 'package:ecommercettl/pages/customer/profile.dart';
import 'package:ecommercettl/services/customer_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget {
  final List<Cart> cartList;
  final UserModel customer;

  const CartPage({super.key, required this.cartList, required this.customer});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isAllSelected = false;
  double totalPrice = 0.0;
  final Map<String, bool> shopSelectionStates = {};
  List<Product?> productList = []; // Changed to non-final to allow modifications
  final CustomerService customerService = CustomerService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    for (var item in widget.cartList) {
      shopSelectionStates[item.shopId] = false;
    }
    fetchProducts();
  }


  Future<void> fetchProducts() async {
    setState(() {
      isLoading = true;
    });
    List<Product?> fetchedProducts = [];
    for (var item in widget.cartList) {
      var product = await customerService.fetchProductById(item.productId);
      fetchedProducts.add(product);
    }
    setState(() {
      productList = fetchedProducts;
      isLoading = false;
    });
  }

  void onCartItemChanged(bool? isSelected, Cart cart) {
    setState(() {
      cart.isSelected = isSelected ?? false;
      calculateTotalPrice();
    });
  }

  void toggleSelectAll(bool? value) {
    setState(() {
      isAllSelected = value ?? false;
      for (var key in shopSelectionStates.keys) {
        shopSelectionStates[key] = isAllSelected;
        for (var item in widget.cartList.where((cart) => cart.shopId == key)) {
          item.isSelected = isAllSelected;
        }
      }
      calculateTotalPrice();
    });
  }

  void toggleSelectShop(String shopName, bool? value) {
    setState(() {
      shopSelectionStates[shopName] = value ?? false;
      for (var item in widget.cartList.where((cart) => cart.shopName == shopName)) {
        item.isSelected = shopSelectionStates[shopName] ?? false;
      }
      calculateTotalPrice();
    });
  }

  List<Product?> getSelectedProducts() {
    List<Product?> selectedProducts = [];
    print("productlistneeeeeeeeeeee${productList}");
    for (var cart in widget.cartList.where((item) => item.isSelected)) {
      var product = productList.firstWhere(
        (p) => p?.id == cart.productId,
        orElse: () => null,
      );
      if (product != null) {
        selectedProducts.add(product);
      }
    }
    return selectedProducts;
  }

  void calculateTotalPrice() {
    totalPrice = widget.cartList
        .where((item) => item.isSelected)
        .fold(0, (sum, item) => sum + item.price * item.quantity);
  }

  void proceedToCheckout() {
    final selectedItems = widget.cartList.where((item) => item.isSelected).toList();
    final selectedProducts = getSelectedProducts();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckOutCart(listCart: selectedItems, listProduct: selectedProducts, customer: widget.customer,),
      ),
    );
  }

  void handleQuantityChange(bool isSuccess) {
    if (isSuccess) {
      calculateTotalPrice(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    final shopGroups = <String, List<Cart>>{};

    for (var item in widget.cartList) {
      shopGroups.putIfAbsent(item.shopName, () => []).add(item);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 25,
            color: Color.fromARGB(255, 200, 51, 40),
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => (BottomNav(tempIndex: 3,))),
            );
          },
        ),
        title: Row(
          children: [
            const Text(
              'Giỏ hàng',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 5), // Thêm khoảng cách giữa các văn bản nếu cần
            Text(
              '(${widget.cartList.length})',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    ...shopGroups.entries.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0.0),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: shopSelectionStates[entry.key] ?? false,
                                  onChanged: (value) => toggleSelectShop(entry.key, value),
                                ),
                                InkWell(
                                  onTap: () {
                                    // Bạn có thể điều hướng đến trang chi tiết của shop nếu cần
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        entry.key,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(
                                        Icons.chevron_right,
                                        color: Colors.grey.withOpacity(0.7),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          ...entry.value.map((cartItem) {
                            return CartItem(
                              cart: cartItem,
                              onChanged: (isSelected) => onCartItemChanged(isSelected, cartItem),
                              onQuantityChanged: handleQuantityChange,
                            );
                          }),
                          const SizedBox(height: 12),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tổng thanh toán:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${NumberFormat("#,###", "vi_VN").format(totalPrice)}đ', // Hiển thị tổng tiền đã định dạng
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: proceedToCheckout ,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Mua hàng',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
