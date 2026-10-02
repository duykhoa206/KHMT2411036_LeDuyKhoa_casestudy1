import 'package:flutter/material.dart';
import 'add_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Danh sách dữ liệu mẫu giao dịch gần đây
  final List<Map<String, dynamic>> recentTransactions = [
    {
      'title': 'Ăn trưa',
      'category': 'Ăn uống',
      'date': '03/09/2024',
      'amount': '-50.000 đ',
      'isExpense': true,
      'icon': Icons.restaurant,
      'color': Colors.orange,
    },
    {
      'title': 'Xăng xe',
      'category': 'Di chuyển',
      'date': '03/09/2024',
      'amount': '-100.000 đ',
      'isExpense': true,
      'icon': Icons.directions_car,
      'color': Colors.blue,
    },
    {
      'title': 'Lương tháng 9',
      'category': 'Thu nhập',
      'date': '01/09/2024',
      'amount': '+8.000.000 đ',
      'isExpense': false,
      'icon': Icons.attach_money,
      'color': Colors.green,
    },
    {
      'title': 'Mua sắm',
      'category': 'Mua sắm',
      'date': '31/08/2024',
      'amount': '-300.000 đ',
      'isExpense': true,
      'icon': Icons.shopping_cart,
      'color': Colors.purple,
    },
    {
      'title': 'Học phí',
      'category': 'Giáo dục',
      'date': '30/08/2024',
      'amount': '-500.000 đ',
      'isExpense': true,
      'icon': Icons.school,
      'color': Colors.teal,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
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
                    const Text(
                      '5.000.000 đ',
                      style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    // Dấu chấm chỉ số trang slide
                    // Dấu chấm chỉ số trang slide
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
                              children: const [
                                Text('TỔNG THU NHẬP', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                                SizedBox(height: 2),
                                Text('8.000.000 đ', style: TextStyle(fontSize: 13, color: Colors.green, fontWeight: FontWeight.bold)),
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
                              children: const [
                                Text('TỔNG CHI TIÊU', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                                SizedBox(height: 2),
                                Text('3.000.000 đ', style: TextStyle(fontSize: 13, color: Colors.redAccent, fontWeight: FontWeight.bold)),
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

              // 3. Tiêu đề Giao dịch gần đây & Xem tất cả
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

              // 4. Danh sách giao dịch gần đây
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentTransactions.length,
                  separatorBuilder: (context, index) => const Divider(height: 1, indent: 60),
                  itemBuilder: (context, index) {
                    final item = recentTransactions[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: (item['color'] as Color).withOpacity(0.15),
                        child: Icon(item['icon'], color: item['color']),
                      ),
                      title: Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: Text('${item['category']}     ${item['date']}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      trailing: Text(
                        item['amount'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: item['isExpense'] ? Colors.redAccent : Colors.green,
                          fontSize: 14,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // Nút FloatingActionButton (Dấu + thêm giao dịch)
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1E67D6),
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),

      // Thanh điều hướng dưới cùng (Bottom Navigation)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: const Color(0xFF1E67D6),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Giao dịch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Thống kê',
          ),
        ],
      ),
    );
  }
}