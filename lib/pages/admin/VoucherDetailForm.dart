import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VoucherDetailForm extends StatelessWidget {
  final Map<String, dynamic> data;
  final String docId;

  VoucherDetailForm({required this.data, required this.docId});

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết Voucher'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                initialValue: data['voucherCode']?.toString() ?? '',
                decoration: InputDecoration(labelText: 'Voucher ID'),
                readOnly: true,
              ),
              TextFormField(
                initialValue: data['discount']?.toString() ?? '',
                decoration: InputDecoration(labelText: 'Discount'),
                readOnly: true,
              ),
              TextFormField(
                initialValue: data['condition']?.toString() ?? '',
                decoration: InputDecoration(labelText: 'Condition'),
                readOnly: true,
              ),
              TextFormField(
                initialValue: data['startDate'] != null
                    ? _formatDate(data['startDate'].toDate())
                    : '',
                decoration: InputDecoration(labelText: 'Start Date'),
                readOnly: true,
              ),
              TextFormField(
                initialValue: data['endDate'] != null
                    ? _formatDate(data['endDate'].toDate())
                    : '',
                decoration: InputDecoration(labelText: 'End Date'),
                readOnly: true,
              ),
              TextFormField(
                initialValue: data['maxDiscount']?.toString() ?? '',
                decoration: InputDecoration(labelText: 'Max Discount'),
                readOnly: true,
              ),
              TextFormField(
                initialValue: data['status']?.toString() ?? '',
                decoration: InputDecoration(labelText: 'Status'),
                readOnly: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
