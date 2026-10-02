import 'package:flutter/material.dart';
import '../models/expense_model.dart';
import '../database/db_helper.dart';

class AddEditExpenseScreen extends StatefulWidget {
  final Expense? expense; // Nếu null là Thêm mới, nếu có dữ liệu là Sửa

  const AddEditExpenseScreen({super.key, this.expense});

  @override
  State<AddEditExpenseScreen> createState() => _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState extends State<AddEditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late double _amount;
  late String _category;
  late String _type;
  late String _date;

  final List<String> _categories = ['Ăn uống', 'Di chuyển', 'Mua sắm', 'Lương', 'Giải trí', 'Khác'];

  @override
  void initState() {
    super.initState();
    _title = widget.expense?.title ?? '';
    _amount = widget.expense?.amount ?? 0.0;
    _category = widget.expense?.category ?? _categories.first;
    _type = widget.expense?.type ?? 'expense';
    _date = widget.expense?.date ?? DateTime.now().toString().split(' ')[0];
  }

  void _saveExpense() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final expense = Expense(
        id: widget.expense?.id,
        title: _title,
        amount: _amount,
        date: _date,
        category: _category,
        type: _type,
      );

      if (widget.expense == null) {
        await DatabaseHelper.instance.insertExpense(expense);
      } else {
        await DatabaseHelper.instance.updateExpense(expense);
      }

      if (mounted) Navigator.pop(context, true); // Trả về true để reload Dashboard
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.expense != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Sửa Giao Dịch' : 'Thêm Giao Dịch'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Tên giao dịch', border: OutlineInputBorder()),
                validator: (val) => val == null || val.trim().isEmpty ? 'Vui lòng nhập tên giao dịch' : null,
                onSaved: (val) => _title = val!.trim(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _amount == 0 ? '' : _amount.toStringAsFixed(0),
                decoration: const InputDecoration(labelText: 'Số tiền (VNĐ)', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Vui lòng nhập số tiền';
                  if (double.tryParse(val) == null || double.parse(val) <= 0) return 'Số tiền không hợp lệ';
                  return null;
                },
                onSaved: (val) => _amount = double.parse(val!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Danh mục', border: OutlineInputBorder()),
                items: _categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                onChanged: (val) => setState(() => _category = val!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _type,
                decoration: const InputDecoration(labelText: 'Loại giao dịch', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'expense', child: Text('Chi tiêu (-)')),
                  DropdownMenuItem(value: 'income', child: Text('Thu nhập (+)')),
                ],
                onChanged: (val) => setState(() => _type = val!),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                onPressed: _saveExpense,
                child: Text(isEditing ? 'CẬP NHẬT' : 'THÊM MỚI', style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}