import 'package:flutter/material.dart';
import '../models/expense_model.dart';
import '../database/db_helper.dart';
import 'add_edit_expense_screen.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  List<Expense> _allTransactions = [];
  List<Expense> _filteredTransactions = [];
  bool _isLoading = true;
  int _selectedTab = 0; // 0: Tất cả, 1: Thu nhập, 2: Chi tiêu
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper.instance.getAllExpenses();
    setState(() {
      _allTransactions = data;
      _filterData();
      _isLoading = false;
    });
  }

  void _filterData() {
    _filteredTransactions = _allTransactions.where((tx) {
      // Lọc theo tab (Thu/Chi/Tất cả)
      bool matchesTab = true;
      if (_selectedTab == 1) {
        matchesTab = tx.type == 'income';
      } else if (_selectedTab == 2) {
        matchesTab = tx.type == 'expense';
      }

      // Lọc theo từ khóa tìm kiếm (tiêu đề hoặc danh mục)
      bool matchesSearch = tx.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          tx.category.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesTab && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Giao dịch',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // Thanh tìm kiếm
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                    _filterData();
                  });
                },
                decoration: const InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: 'Tìm kiếm giao dịch...',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Các nút Tab lọc (Tất cả, Thu nhập, Chi tiêu)
            Row(
              children: [
                _buildTabButton('Tất cả', 0),
                const SizedBox(width: 8),
                _buildTabButton('Thu nhập', 1),
                const SizedBox(width: 8),
                _buildTabButton('Chi tiêu', 2),
              ],
            ),
            const SizedBox(height: 16),

            // Danh sách hiển thị
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredTransactions.isEmpty
                  ? const Center(child: Text('Không tìm thấy giao dịch nào.', style: TextStyle(color: Colors.grey)))
                  : ListView.separated(
                itemCount: _filteredTransactions.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = _filteredTransactions[index];
                  final isIncome = item.type == 'income';

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: isIncome ? Colors.green.shade50 : Colors.red.shade50,
                      child: Icon(
                        isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                        color: isIncome ? Colors.green : Colors.redAccent,
                      ),
                    ),
                    title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text('${item.category} • ${item.date}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    trailing: Text(
                      '${isIncome ? '+' : '-'}${item.amount.toStringAsFixed(0)} đ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isIncome ? Colors.green : Colors.redAccent,
                        fontSize: 14,
                      ),
                    ),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddEditExpenseScreen(expense: item),
                        ),
                      );
                      if (result == true) {
                        _loadTransactions();
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    bool isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
            _filterData();
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1E67D6) : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}