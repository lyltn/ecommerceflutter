import 'package:ecommercettl/pages/admin/voucher_list.dart';
import 'package:ecommercettl/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ecommercettl/models/VoucherModel.dart';
import 'package:ecommercettl/services/voucher_service.dart';

class EditVoucherForm extends StatefulWidget {
  final Map<String, dynamic> data;
  final String docId;

  EditVoucherForm({required this.data, required this.docId});

  @override
  _EditVoucherFormState createState() => _EditVoucherFormState();
}

class _EditVoucherFormState extends State<EditVoucherForm> {
  final _formKey = GlobalKey<FormState>();
  final VoucherService voucherService = VoucherService();
  UserService userService = UserService();

  late TextEditingController _voucherIdController;
  late TextEditingController _discountController;
  late TextEditingController _conditionController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _maxDiscountController;
  late TextEditingController _statusController;

  final _focusNodes = List<FocusNode>.generate(7, (_) => FocusNode());
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();

    _voucherIdController =
        TextEditingController(text: widget.data['voucherCode']?.toString());
    _discountController =
        TextEditingController(text: widget.data['discount']?.toString());
    _conditionController =
        TextEditingController(text: widget.data['condition']?.toString());
    _startDateController = TextEditingController(
        text: widget.data['startDate'] != null
            ? _dateFormat.format(widget.data['startDate'].toDate())
            : '');
    _endDateController = TextEditingController(
        text: widget.data['endDate'] != null
            ? _dateFormat.format(widget.data['endDate'].toDate())
            : '');
    _maxDiscountController =
        TextEditingController(text: widget.data['maxDiscount']?.toString());
    _statusController =
        TextEditingController(text: widget.data['status']?.toString());
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.text = _dateFormat.format(picked);
    }
  }

  String? _validateVoucherId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mã voucher không được để trống';
    }
    if (!RegExp(r'^[A-Z0-9]+$').hasMatch(value)) {
      return 'Mã voucher chỉ bao gồm chữ cái in hoa và số, không có khoảng trắng';
    }
    return null;
  }

  String? _validateDiscount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Giảm giá không được để trống';
    }
    if (int.tryParse(value) == null || int.tryParse(value)! <= 0) {
      return 'Giảm giá chỉ có thể là số nguyên dương';
    }
    return null;
  }

  String? _validateCondition(String? value) {
    if (value == null || value.isEmpty) {
      return 'Điều kiện không được để trống';
    }
    if (double.tryParse(value) == null || double.tryParse(value)! <= 0) {
      return 'Điều kiện chỉ có thể là số dương';
    }
    return null;
  }

  String? _validateStartDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ngày bắt đầu không được để trống';
    }
    try {
      DateTime date = _dateFormat.parse(value);
      if (date.isAfter(DateTime.now())) {
        return 'Ngày bắt đầu phải nhỏ hơn hoặc bằng ngày hiện tại';
      }
    } catch (e) {
      return 'Ngày bắt đầu không hợp lệ';
    }
    return null;
  }

  String? _validateEndDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ngày kết thúc không được để trống';
    }
    try {
      DateTime endDate = _dateFormat.parse(value);
      DateTime startDate = _dateFormat.parse(_startDateController.text);
      if (endDate.isBefore(startDate)) {
        return 'Ngày kết thúc phải lớn hơn hoặc bằng Ngày bắt đầu';
      }
    } catch (e) {
      return 'Ngày kết thúc không hợp lệ';
    }
    return null;
  }

  String? _validateMaxDiscount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Giảm giá tối đa không được để trống';
    }
    if (double.tryParse(value) == null || double.tryParse(value)! <= 0) {
      return 'Giảm giá tối đa chỉ có thể là số dương';
    }
    return null;
  }

  String? _validateStatus(String? value) {
    if (value == null || value.isEmpty) {
      return 'Trạng thái không được để trống';
    }
    if (value.toLowerCase() != 'true' && value.toLowerCase() != 'false') {
      return 'Trạng thái chỉ được nhập true hoặc false';
    }
    return null;
  }

  @override
  void dispose() {
    _voucherIdController.dispose();
    _discountController.dispose();
    _conditionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _maxDiscountController.dispose();
    _statusController.dispose();
    _focusNodes.forEach((node) => node.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa Voucher'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _voucherIdController,
                  decoration: InputDecoration(labelText: 'Mã voucher'),
                  validator: _validateVoucherId,
                  textInputAction: TextInputAction.next,
                  focusNode: _focusNodes[0],
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_focusNodes[1]);
                  },
                ),
                TextFormField(
                  controller: _discountController,
                  decoration: InputDecoration(labelText: 'Giảm giá'),
                  validator: _validateDiscount,
                  textInputAction: TextInputAction.next,
                  focusNode: _focusNodes[1],
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_focusNodes[2]);
                  },
                ),
                TextFormField(
                  controller: _conditionController,
                  decoration: InputDecoration(labelText: 'Điều kiện'),
                  validator: _validateCondition,
                  textInputAction: TextInputAction.next,
                  focusNode: _focusNodes[2],
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_focusNodes[3]);
                  },
                ),
                TextFormField(
                  controller: _startDateController,
                  decoration: InputDecoration(
                    labelText: 'Ngày bắt đầu',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () {
                        _selectDate(context, _startDateController);
                      },
                    ),
                  ),
                  validator: _validateStartDate,
                  textInputAction: TextInputAction.next,
                  focusNode: _focusNodes[3],
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_focusNodes[4]);
                  },
                ),
                TextFormField(
                  controller: _endDateController,
                  decoration: InputDecoration(
                    labelText: 'Ngày kết thúc',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () {
                        _selectDate(context, _endDateController);
                      },
                    ),
                  ),
                  validator: _validateEndDate,
                  textInputAction: TextInputAction.next,
                  focusNode: _focusNodes[4],
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_focusNodes[5]);
                  },
                ),
                TextFormField(
                  controller: _maxDiscountController,
                  decoration: InputDecoration(labelText: 'Giảm giá tối đa'),
                  validator: _validateMaxDiscount,
                  textInputAction: TextInputAction.next,
                  focusNode: _focusNodes[5],
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_focusNodes[6]);
                  },
                ),
                TextFormField(
                  controller: _statusController,
                  decoration: InputDecoration(labelText: 'Trạng thái'),
                  validator: _validateStatus,
                  textInputAction: TextInputAction.done,
                  focusNode: _focusNodes[6],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    String? role = await userService.getUserRole();
                    if (_formKey.currentState!.validate()) {
                      Voucher updatedVoucher = Voucher(
                        voucherID: _voucherIdController.text,
                        discount: int.parse(_discountController.text),
                        condition: double.parse(_conditionController.text),
                        startDate: _dateFormat.parse(_startDateController.text),
                        endDate: _dateFormat.parse(_endDateController.text),
                        maxDiscount: double.parse(_maxDiscountController.text),
                        userID: FirebaseAuth.instance.currentUser!.uid,
                        status: _statusController.text.toLowerCase() == 'true',
                        role: role!,
                      );
                      // Hành động lưu
                      await voucherService.updateVoucher(
                          widget.docId, updatedVoucher);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Lưu thành công')),
                      );
                    }
                  },
                  child: Text('Lưu'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
