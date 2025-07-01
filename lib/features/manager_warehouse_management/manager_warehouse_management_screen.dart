import 'package:flutter/material.dart';

class ManagerWarehouseManagementScreen extends StatelessWidget {
  const ManagerWarehouseManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('창고 관리자 페이지'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCardButton(
              icon: Icons.assignment_turned_in_outlined,
              title: '창고 신청 목록',
              subtitle: '사용자들의 창고 등록 요청을 확인하세요.',
              onTap: () {
                // Navigator.push(...);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ManagerWarehouseManagementScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildCardButton(
              icon: Icons.warehouse_outlined,
              title: '기존 창고 관리',
              subtitle: '등록된 창고를 조회 및 수정하세요.',
              onTap: () {
                // Navigator.push(...);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.blue[50],
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Row(
            children: [
              Icon(icon, size: 48, color: Colors.lightBlue),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        )),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.lightBlue),
            ],
          ),
        ),
      ),
    );
  }
}
