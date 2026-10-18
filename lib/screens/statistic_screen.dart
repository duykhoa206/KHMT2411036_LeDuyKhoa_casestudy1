import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/expense_model.dart';
import '../database/db_helper.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  int _selectedTab = 0; // 0: Tháng này, 1: Tháng trước, 2: Năm nay
  bool _isLoading = true;

  List<Expense> _allExpenses = [];
  Map<String, double> _categoryTotals = {};
  double _totalExpense = 0;

  // Danh sách màu sắc tương ứng cho các danh mục
  final Map<String, Color> _categoryColors = {
    'Ăn uống': Colors.redAccent,
    'Mua sắm': Colors.pinkAccent,
    'Đi lại': Colors.green,
    'Học tập': Colors.blue,
    'Giải trí': Colors.orange,
    'Khác': Colors.purple,
  };

  @override
  void initState() {
    super.initState();
    _loadStatisticsData();
  }

  Future<void> _loadStatisticsData() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper.instance.getAllExpenses();

    // Lọc chỉ lấy các giao dịch chi tiêu ('expense')
    _allExpenses = data.where((item) => item.type == 'expense').toList();

    _processData();
    setState(() => _isLoading = false);
  }

  void _processData() {
    // Ở đây bạn có thể lọc theo _selectedTab (Tháng này / Tháng trước / Năm nay) nếu cần.
    // Tạm thời tính tổng toàn bộ dữ liệu chi tiêu:
    _categoryTotals.clear();
    _totalExpense = 0;

    for (var item in _allExpenses) {
      _totalExpense += item.amount;
      _categoryTotals[item.category] = (_categoryTotals[item.category] ?? 0) + item.amount;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Thống kê',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Các nút lọc thời gian (Tháng này, Tháng trước, Năm nay)[cite: 8]
            Row(
              children: [
                _buildFilterButton('Tháng này', 0),
                const SizedBox(width: 8),
                _buildFilterButton('Tháng trước', 1),
                const SizedBox(width: 8),
                _buildFilterButton('Năm nay', 2),
              ],
            ),
            const SizedBox(height: 24),

            // 2. Biểu đồ tròn (Donut Chart) và Tổng chi tiêu ở giữa[cite: 8]
            Container(
              height: 240,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: _totalExpense == 0
                  ? const Center(child: Text('Chưa có dữ liệu chi tiêu', style: TextStyle(color: Colors.grey)))
                  : Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 70,
                      sections: _categoryTotals.entries.map((entry) {
                        final category = entry.key;
                        final amount = entry.value;
                        final percentage = (_totalExpense > 0) ? (amount / _totalExpense) * 100 : 0.0;
                        final color = _categoryColors[category] ?? Colors.grey;

                        // Thêm từ khóa return ở đây:
                        return PieChartSectionData(
                          color: color,
                          value: amount,
                          title: '',
                          radius: 25,
                        );
                      }).toList(),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${_totalExpense.toStringAsFixed(0)} đ',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Tổng chi tiêu',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. Danh sách chi tiết các danh mục[cite: 8]
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _categoryTotals.length,
                separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
                itemBuilder: (context, index) {
                  final entry = _categoryTotals.entries.elementAt(index);
                  final category = entry.key;
                  final amount = entry.value;
                  final percentage = (_totalExpense > 0) ? (amount / _totalExpense) * 100 : 0.0;
                  final color = _categoryColors[category] ?? Colors.grey;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            category,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                        ),
                        Text(
                          '${amount.toStringAsFixed(0)} đ',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 45,
                          child: Text(
                            '${percentage.toStringAsFixed(0)}%',
                            textAlign: TextAlign.right,
                            style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String title, int index) {
    bool isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
            // Có thể thêm logic lọc theo thời gian tại đây nếu cần
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1E67D6) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade300),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}