import 'package:ecommercettl/models/CartModel.dart';
import 'package:ecommercettl/models/Product.dart';
import 'package:ecommercettl/pages/customer/component/editCart.dart';
import 'package:ecommercettl/services/customer_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartItem extends StatefulWidget {
  final Cart cart;
  final ValueChanged<bool?> onChanged;
  final ValueChanged<bool> onQuantityChanged;
  final VoidCallback onDelete; // Callback to handle delete action

  const CartItem({
    Key? key,
    required this.cart,
    required this.onChanged,
    required this.onQuantityChanged,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  bool isSelected = true;
  Product? product;
  bool showEditCart = false;
  String tempColor = "";
  String tempSize = "";
  int tempQuantity = 0;

  CustomerService customerService = CustomerService();

  @override
  void initState() {
    super.initState();
    isSelected = widget.cart.isSelected;
    _loadProductData();
  }

  Future<void> _loadProductData() async {
    product = await customerService.loadProductDataById(widget.cart.productId);
    setState(() {});
  }

  void _toggleEditCart() {
    setState(() {
      showEditCart = !showEditCart;
    });
  }

  void handleColorUpdate(String? color) {
    if (color != null) {
      setState(() {
        tempColor = color;
      });
    }
  }

  void handleSizeUpdate(String? size) {
    if (size != null) {
      setState(() {
        tempSize = size;
      });
    }
  }

  void handleQuantityUpdate(int quantity) {
    if (quantity > 0) {
      setState(() {
        tempQuantity = quantity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.3;

    if (product == null) {
      return const CircularProgressIndicator();
    }

    return Dismissible(
      key: ValueKey(widget.cart.cartId), // Unique key for each item
      direction: DismissDirection.endToStart, // Swipe from right to left
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        widget.onDelete(); // Call the delete callback
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
            ),
          ],
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    isSelected = value ?? false;
                    widget.onChanged(isSelected);
                  });
                },
              ),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product?.imageUrls.isNotEmpty == true
                        ? product!.imageUrls[0]
                        : '',
                    width: width,
                    height: width * 0.9,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product?.name ?? 'Loading...',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.black.withOpacity(0.7),
                          builder: (BuildContext context) {
                            return EditCart(
                              product: product!,
                              cart: widget.cart,
                              onCartColorUpdated: handleColorUpdate,
                              onCartSizeUpdated: handleSizeUpdate,
                              onCartQuantityUpdated: handleQuantityUpdate,
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 239, 239, 239),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${tempColor.isNotEmpty ? tempColor : widget.cart.color}, ${tempSize.isNotEmpty ? tempSize : widget.cart.size}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          Icon(Icons.expand_more),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product != null
                              ? '${NumberFormat("#,###", "vi_VN").format(product!.price)}đ'
                              : '...đ',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 207, 54, 43),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (widget.cart.quantity > 1) {
                                  setState(() {
                                    widget.cart.quantity--;
                                    customerService.updateCartQuantityById(
                                        widget.cart.cartId,
                                        widget.cart.quantity);
                                    widget.onQuantityChanged(true);
                                  });
                                } else {
                                  widget.onQuantityChanged(false);
                                }
                              },
                            ),
                            Text(
                              (tempQuantity != 0
                                      ? tempQuantity
                                      : widget.cart.quantity)
                                  .toString(),
                              style: const TextStyle(fontSize: 14),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  widget.cart.quantity++;
                                  customerService.updateCartQuantityById(
                                      widget.cart.cartId, widget.cart.quantity);
                                  widget.onQuantityChanged(true);
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
