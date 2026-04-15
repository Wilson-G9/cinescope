import 'package:flutter/material.dart';

/// Màn hình 5: PROFILE SCREEN
///
/// Kỹ thuật Navigation:
///   - Navigator.pop(context) để quay về
///   - Navigator.pushNamedAndRemoveUntil('/home', (route) => false)
///     → Đăng xuất: xóa toàn bộ navigation stack, đưa về Home
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141414),
        title: const Text(
          'Hồ sơ',
          style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Avatar
            Stack(
              children: [
                const CircleAvatar(
                  radius: 55,
                  backgroundColor: Color(0xFFE50914),
                  child: Text(
                    'PĐ',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E1E1E),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt,
                        color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Phúc Đoàn',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('phuc.doan@email.com',
                style: TextStyle(color: Colors.grey[500], fontSize: 14)),

            const SizedBox(height: 24),

            // Thống kê
            Row(
              children: [
                _buildStat('12', 'Đã xem'),
                _buildStat('5', 'Yêu thích'),
                _buildStat('3', 'Đánh giá'),
              ],
            ),

            const SizedBox(height: 28),

            // Cài đặt tài khoản
            _buildSection('Tài khoản', [
              _buildMenuItem(
                  Icons.person_outline, 'Chỉnh sửa hồ sơ', () {}),
              _buildMenuItem(Icons.lock_outline, 'Đổi mật khẩu', () {}),
              _buildMenuItem(
                  Icons.notifications_outlined, 'Thông báo', () {}),
            ]),

            const SizedBox(height: 16),

            // Cài đặt ứng dụng
            _buildSection('Ứng dụng', [
              _buildMenuItem(
                  Icons.dark_mode_outlined, 'Giao diện tối', () {}),
              _buildMenuItem(Icons.language, 'Ngôn ngữ', () {}),
              _buildMenuItem(
                  Icons.help_outline, 'Trợ giúp & Hỗ trợ', () {}),
            ]),

            const SizedBox(height: 16),

            // Nút đăng xuất
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: const Color(0xFF1E1E1E),
                      title: const Text('Đăng xuất',
                          style: TextStyle(color: Colors.white)),
                      content: const Text(
                          'Bạn có chắc muốn đăng xuất không?',
                          style: TextStyle(color: Colors.grey)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Hủy',
                              style: TextStyle(color: Colors.grey)),
                        ),
                        TextButton(
                          onPressed: () {
                            // ─── ĐIỀU HƯỚNG ĐĂNG XUẤT ──────────────────────
                            // pushNamedAndRemoveUntil xóa toàn bộ stack cũ
                            // (Profile, Home,...) và tạo stack mới chỉ có Home.
                            // Người dùng không Back lại được.
                            // ────────────────────────────────────────────────
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/home',
                              (route) => false,
                            );
                          },
                          child: const Text('Đăng xuất',
                              style:
                                  TextStyle(color: Color(0xFFE50914))),
                        ),
                      ],
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Color(0xFFE50914)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon:
                    const Icon(Icons.logout, color: Color(0xFFE50914)),
                label: const Text('Đăng xuất',
                    style: TextStyle(
                        color: Color(0xFFE50914), fontSize: 15)),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label,
                style:
                    TextStyle(color: Colors.grey[500], fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
                letterSpacing: 0.5)),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[400], size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(title,
                  style:
                      const TextStyle(color: Colors.white, fontSize: 15)),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[600], size: 20),
          ],
        ),
      ),
    );
  }
}