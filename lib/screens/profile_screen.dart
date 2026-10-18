import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cá nhân', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Thông tin tài khoản
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.person, size: 35, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Nguyễn Văn A',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'nguyenvana@example.com',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Danh sách các tùy chọn
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildMenuItem(Icons.person_outline, 'Thông tin cá nhân', () {}),
                  _buildMenuItem(Icons.settings_outlined, 'Cài đặt ngân sách', () {}),
                  _buildMenuItem(Icons.list_alt, 'Danh mục chi tiêu', () {}),
                  _buildMenuItem(Icons.cloud_upload_outlined, 'Sao lưu dữ liệu', () {}),
                  _buildMenuItem(Icons.lock_outline, 'Đổi mật khẩu', () {}),
                  _buildMenuItem(Icons.logout, 'Đăng xuất', () {}, textColor: Colors.red, iconColor: Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {Color textColor = Colors.black, Color iconColor = Colors.black54}) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}