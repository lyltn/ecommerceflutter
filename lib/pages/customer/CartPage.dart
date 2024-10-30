import 'package:ecommercettl/models/CartModel.dart';
import 'package:ecommercettl/pages/customer/bottomnav.dart';
import 'package:ecommercettl/pages/customer/component/CartItem.dart';
import 'package:ecommercettl/pages/customer/profile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget {
  final List<Cart> cartList;

  const CartPage({super.key, required this.cartList});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isAllSelected = false;
  double totalPrice = 0.0;
  final Map<String, bool> shopSelectionStates = {};

  void onCartItemChanged(bool? isSelected, Cart cart) {
    setState(() {
      cart.isSelected = isSelected ?? false; // Cập nhật trạng thái chọn cho sản phẩm
      calculateTotalPrice(); // Tính toán lại tổng tiền khi sản phẩm được chọn/không chọn
    });
  }

  void toggleSelectAll(bool? value) {
    setState(() {
      isAllSelected = value ?? false;
      // Cập nhật trạng thái chọn cho tất cả các shop
      for (var key in shopSelectionStates.keys) {
        shopSelectionStates[key] = isAllSelected;
        for (var item in widget.cartList.where((cart) => cart.shopId == key)) {
          item.isSelected = isAllSelected; // Cập nhật trạng thái chọn cho tất cả các sản phẩm trong shop
        }
      }
      calculateTotalPrice(); // Tính toán lại tổng tiền khi chọn tất cả
    });
  }

  void toggleSelectShop(String shopName, bool? value) {
    setState(() {
      // Cập nhật trạng thái chọn của shop
      shopSelectionStates[shopName] = value ?? false; 

      for (var item in widget.cartList.where((cart) => cart.shopName == shopName)) {
        item.isSelected = shopSelectionStates[shopName] ?? true;
      }

      // Tính toán lại tổng tiền của các sản phẩm đã chọn
      calculateTotalPrice();
    });
  }

  @override
  void initState() {
    super.initState();
    // Khởi tạo trạng thái chọn cho mỗi shop
    for (var item in widget.cartList) {
      shopSelectionStates[item.shopId] = false; // Khởi tạo thành false mặc định
    }
  }

  void calculateTotalPrice() {
    setState(() {
      totalPrice = 0;
      for (var item in widget.cartList) {
        // Kiểm tra xem sản phẩm có được chọn hay không
        if (item.isSelected) {
          totalPrice += item.price * item.quantity;
        }
      }
    });
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
                    onPressed: () {
                      // Thực hiện logic thanh toán
                    },
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
