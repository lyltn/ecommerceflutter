import 'package:flutter/material.dart';

class GuaranteeCard extends StatelessWidget {
  final VoidCallback onAgree;
  const GuaranteeCard({Key? key, required this.onAgree}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: const Text(
                  'An tâm mua sắm cùng TTL',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildGuaranteeItem(
                Icons.refresh,
                'Được đổi kiểm hoặc đổi ý miễn phí trong vòng 15 ngày',
                'Miễn phí trả hàng trong 15 ngày nếu đủ điều kiện phát con nguyên seal, tem và phụ kiện; sản phẩm đã dùng, đã được đổi số sẽ áp dụng phí nhất định. Ngoài ra, tất thỏa điều kiện hàng lỗi có thể đổi kiểm và được trả hàng miễn phí.',
              ),
              const SizedBox(height: 12),
              _buildGuaranteeItem(
                Icons.verified,
                'Chính hãng 100%',
                'Nhận lại gấp đôi số tiền mà bạn thanh toán cho sản phẩm không chính hãng từ TTL.',
              ),
              const SizedBox(height: 12),
              _buildGuaranteeItem(
                Icons.local_shipping,
                'Miễn phí vận chuyển',
                'Ưu đãi miễn phí vận chuyển lên tới 40.000 VNĐ cho đơn hàng của TTL từ 150.000 VNĐ.',
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onAgree, // Gọi callback khi nhấn nút đồng ý
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Đồng ý',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuaranteeItem(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.green),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}