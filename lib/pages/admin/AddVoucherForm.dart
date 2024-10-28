import 'package:ecommercettl/models/VoucherModel.dart';
import 'package:ecommercettl/services/user_service.dart';
import 'package:ecommercettl/services/voucher_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddVoucherForm extends StatefulWidget {
  @override
  _AddVoucherFormState createState() => _AddVoucherFormState();
}

class _AddVoucherFormState extends State<AddVoucherForm> {
  final _formKey = GlobalKey<FormState>();
  final VoucherService voucherService = VoucherService();
  final UserService userService = UserService();

  final TextEditingController _voucherIdController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _maxDiscountController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  final _focusNodes = List<FocusNode>.generate(7, (_) => FocusNode());
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

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
    if (!RegExp(r'^[1-9]\d*$').hasMatch(value)) {
      return 'Giảm giá chỉ có thể là số nguyên dương, không có ký tự trắng';
    }
    return null;
  }

  String? _validateCondition(String? value) {
    if (value == null || value.isEmpty) {
      return 'Điều kiện không được để trống';
    }
    if (!RegExp(r'^[1-9]\d*(\.\d+)?$').hasMatch(value)) {
      return 'Điều kiện chỉ có thể là số nguyên dương hoặc số thập phân, không có ký tự trắng';
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
    if (!RegExp(r'^[1-9]\d*(\.\d+)?$').hasMatch(value)) {
      return 'Giảm giá tối đa chỉ có thể là số nguyên dương hoặc số thập phân, không có ký tự trắng';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm Voucher'),
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
                ),
                TextFormField(
                  controller: _discountController,
                  decoration: InputDecoration(labelText: 'Giảm giá'),
                  validator: _validateDiscount,
                  textInputAction: TextInputAction.next,
                  focusNode: _focusNodes[1],
                ),
                TextFormField(
                  controller: _conditionController,
                  decoration: InputDecoration(labelText: 'Điều kiện'),
                  validator: _validateCondition,
                  textInputAction: TextInputAction.next,
                  focusNode: _focusNodes[2],
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
                ),
                TextFormField(
                  controller: _maxDiscountController,
                  decoration: InputDecoration(labelText: 'Giảm giá tối đa'),
                  validator: _validateMaxDiscount,
                  textInputAction: TextInputAction.next,
                  focusNode: _focusNodes[5],
                ),
                TextFormField(
                  controller: _statusController,
                  decoration: InputDecoration(labelText: 'Trạng thái'),
                  validator: _validateStatus,
                  textInputAction: TextInputAction.done,
                  focusNode: _focusNodes[6],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.green,
          ),
          onPressed: () async {
            String? role = await userService.getUserRole();
            if (_formKey.currentState!.validate()) {
              Voucher voucher = Voucher(
                voucherID: _voucherIdController.text,
                discount: int.parse(_discountController.text),
                condition: double.parse(_conditionController.text),
                startDate: _dateFormat.parse(_startDateController.text),
                endDate: _dateFormat.parse(_endDateController.text),
                maxDiscount: double.parse(_maxDiscountController.text),
                userID: FirebaseAuth.instance.currentUser!.uid,
                status: _statusController.text.toLowerCase() == 'true',
                role: role ?? "",
              );
              await voucherService.addVoucher(voucher);
              Navigator.of(context).pop();
            }
          },
          child: Text('Lưu'),
        ),
      ),
    );
  }
}
