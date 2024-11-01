import 'package:ecommercettl/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SeeOrderDetail extends StatefulWidget {
  final String orderId;

  const SeeOrderDetail({super.key, required this.orderId});

  @override
  State<SeeOrderDetail> createState() => _SeeOrderDetailState();
}

class _SeeOrderDetailState extends State<SeeOrderDetail> {
  ProductService productService = ProductService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đơn hàng'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .where('orderCode', isEqualTo: widget.orderId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var orderData =
                    snapshot.data!.docs.first.data() as Map<String, dynamic>;

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OrderDetailRow(label: 'Mã đơn hàng: ${widget.orderId}'),
                        OrderDetailRow(
                            label: 'Tên khách hàng: ${orderData['name']}'),
                        OrderDetailRow(
                            label: 'Số điện thoại: ${orderData['phone']}'),
                        OrderDetailRow(
                          label:
                              'Ngày đặt: ${DateFormat('dd MMMM yyyy, HH:mm:ss').format((orderData['orderDate'] as Timestamp).toDate())}',
                        ),
                        OrderDetailRow(
                          label: 'Địa chỉ: ${orderData['address']}',
                          isMultiline: true,
                        ),
                        OrderDetailRow(
                            label:
                                'Ghi chú: ${orderData['note'] ?? "Không có ghi chú"}'),
                        Row(
                          children: [
                            OrderDetailRow(
                                label:
                                    'Số lượng: ${(orderData['quantity'] ?? 0).toString()}'),
                            const SizedBox(width: 8),
                          ],
                        ),
                        OrderDetailRow(
                          label:
                            'Shop Voucher:  ${orderData['shopVoucher'] ?? "x"}'
                        ),
                        OrderDetailRow(
                          label:
                            'TTL Voucher:  ${orderData['adminVoucher'] ?? "x"}'
                        ),
                        OrderDetailRow(
                          label:
                            'Tình trạng:  ${orderData['status'] ?? "x"}'
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: TotalAmountRow(
                              amount: (orderData['total'] ?? 0).toString()),
                        ),
                        
                      ],
                    ),
                  ),
                );
              },
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('orderdetails')
                    .where('orderCode', isEqualTo: widget.orderId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      var data = doc.data() as Map<String, dynamic>;

                      // Fetching product details using ProductService
                      return FutureBuilder<DocumentSnapshot>(
                        future:
                            productService.getProductByIdd(data['productId']),
                        builder: (context, productSnapshot) {
                          if (!productSnapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          var productData = productSnapshot.data!.data()
                              as Map<String, dynamic>;
                          String imageUrl = productData['imageUrl']
                              [0]; // Assuming imageUrl is a list
                          String productName = productData['name'];
                          String priceProduct =
                              '${productData['price'].toString()} đ';

                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      imageUrl,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          productName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 5.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${data['color']}, ${data['size']}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              priceProduct,
                                              style: const TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'x${data['quantity'].toString()}',
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderDetailRow extends StatelessWidget {
  final String label;
  final bool isMultiline;

  const OrderDetailRow({
    Key? key,
    required this.label,
    this.isMultiline = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        label,
        style: const TextStyle(fontSize: 16),
        maxLines: isMultiline ? 3 : 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class TotalAmountRow extends StatelessWidget {
  final String amount;

  const TotalAmountRow({Key? key, required this.amount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text(
          'Tổng Tiền: ',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        Text(
          amount,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}
