import 'package:flutter/material.dart';
import '../models/expense_model.dart';
import '../database/db_helper.dart';
import 'add_edit_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Dữ liệu từ SQLite
  List<Expense> _expenses = [];
  double _totalIncome = 0;
  double _totalExpense = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Hàm load dữ liệu thật từ SQLite và tính toán tổng thu/chi
  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper.instance.getAllExpenses();

    double income = 0;
    double expense = 0;

    for (var item in data) {
      if (item.type == 'income') {
        income += item.amount;
      } else {
        expense += item.amount;
      }
    }

    setState(() {
      _expenses = data;
      _totalIncome = income;
      _totalExpense = expense;
      _isLoading = false;
    });
  }

  // Hàm xóa giao dịch
  void _deleteExpense(int id) async {
    await DatabaseHelper.instance.deleteExpense(id);
    _loadData(); // Load lại giao diện sau khi xóa
  }

  @override
  Widget build(BuildContext context) {
    double balance = _totalIncome - _totalExpense;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Thẻ Số dư hiện tại (Xanh dương)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E67D6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'SỐ DƯ HIỆN TẠI',
                          style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.remove_red_eye, color: Colors.white70, size: 16),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${balance.toStringAsFixed(0)} đ',
                      style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: 16, height: 4, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2))),
                        const SizedBox(width: 4),
                        Container(width: 4, height: 4, decoration: BoxDecoration(color: Colors.white54, borderRadius: BorderRadius.circular(2))),
                        const SizedBox(width: 4),
                        Container(width: 4, height: 4, decoration: BoxDecoration(color: Colors.white54, borderRadius: BorderRadius.circular(2))),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 2. Thẻ Tổng thu nhập & Tổng chi tiêu
              Row(
                children: [
                  // Tổng thu nhập
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.green,
                            child: Icon(Icons.arrow_downward, color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('TỔNG THU NHẬP', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 2),
                                Text('${_totalIncome.toStringAsFixed(0)} đ', style: const TextStyle(fontSize: 13, color: Colors.green, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Tổng chi tiêu
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.redAccent,
                            child: Icon(Icons.arrow_upward, color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('TỔNG CHI TIÊU', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 2),
                                Text('${_totalExpense.toStringAsFixed(0)} đ', style: const TextStyle(fontSize: 13, color: Colors.redAccent, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 3. Tiêu đề Giao dịch gần đây
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Giao dịch gần đây',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Xem tất cả', style: TextStyle(color: Color(0xFF1E67D6))),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // 4. Danh sách giao dịch từ SQLite
              _expenses.isEmpty
                  ? const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text('Chưa có giao dịch nào trong CSDL.', style: TextStyle(color: Colors.grey)),
                ),
              )
                  : Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _expenses.length,
                  separatorBuilder: (context, index) => const Divider(height: 1, indent: 60),
                  itemBuilder: (context, index) {
                    final item = _expenses[index];
                    final isIncome = item.type == 'income';

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isIncome ? Colors.green.shade50 : Colors.red.shade50,
                        child: Icon(
                          isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                          color: isIncome ? Colors.green : Colors.redAccent,
                        ),
                      ),
                      title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: Text('${item.category}   •   ${item.date}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${isIncome ? '+' : '-'}${item.amount.toStringAsFixed(0)} đ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isIncome ? Colors.green : Colors.redAccent,
                              fontSize: 14,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 20, color: Colors.grey),
                            onPressed: () => _deleteExpense(item.id!),
                          ),
                        ],
                      ),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddEditExpenseScreen(expense: item),
                          ),
                        );

                        if (result == true) {
                          _loadData();
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // Nút FloatingActionButton (mở màn hình thêm giao dịch)
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1E67D6),
        shape: const CircleBorder(),
        onPressed: () async {
          // Sau khi thêm mới xong quay lại sẽ tự động làm tươi dữ liệu
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditExpenseScreen()),
          );
          if (result == true) {
            _loadData();
          }
        },
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: const Color(0xFF1E67D6),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Giao dịch'),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Thống kê'),
        ],
      ),
    );
  }
}