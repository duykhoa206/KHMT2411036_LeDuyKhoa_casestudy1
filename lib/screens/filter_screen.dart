import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  bool isAll = true;
  bool isIncome = false;
  bool isExpense = false;
  int selectedTimeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Bộ lọc', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Loại giao dịch', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            CheckboxListTile(
              title: const Text('Tất cả'),
              value: isAll,
              onChanged: (val) => setState(() => isAll = val ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              title: const Text('Thu nhập'),
              value: isIncome,
              onChanged: (val) => setState(() => isIncome = val ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              title: const Text('Chi tiêu'),
              value: isExpense,
              onChanged: (val) => setState(() => isExpense = val ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 16),
            const Text('Danh mục', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Tất cả danh mục', style: TextStyle(color: Colors.grey)),
                  Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('Khoảng thời gian', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            RadioListTile(
              title: const Text('Hôm nay'),
              value: 0,
              groupValue: selectedTimeIndex,
              onChanged: (val) => setState(() => selectedTimeIndex = val!),
              contentPadding: EdgeInsets.zero,
            ),
            RadioListTile(
              title: const Text('7 ngày qua'),
              value: 1,
              groupValue: selectedTimeIndex,
              onChanged: (val) => setState(() => selectedTimeIndex = val!),
              contentPadding: EdgeInsets.zero,
            ),
            RadioListTile(
              title: const Text('Tháng này'),
              value: 2,
              groupValue: selectedTimeIndex,
              onChanged: (val) => setState(() => selectedTimeIndex = val!),
              contentPadding: EdgeInsets.zero,
            ),
            RadioListTile(
              title: const Text('Tùy chỉnh'),
              value: 3,
              groupValue: selectedTimeIndex,
              onChanged: (val) => setState(() => selectedTimeIndex = val!),
              contentPadding: EdgeInsets.zero,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Áp dụng', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}