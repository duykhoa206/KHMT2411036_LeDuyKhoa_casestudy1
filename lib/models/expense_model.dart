class Expense {
  final int? id;
  final String title;
  final double amount;
  final String date;
  final String category;
  final String type; // 'income' (Thu nhập) hoặc 'expense' (Chi tiêu)

  Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.type,
  });

  // Chuyển đối tượng Expense thành Map để lưu vào SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date,
      'category': category,
      'type': type,
    };
  }

  // Chuyển Map lấy từ SQLite ra thành đối tượng Expense
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: map['date'],
      category: map['category'],
      type: map['type'],
    );
  }
}