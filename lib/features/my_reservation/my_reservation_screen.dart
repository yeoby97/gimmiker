import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'my_reservation_provider.dart';

class MyReservationScreen extends StatefulWidget {
  const MyReservationScreen({super.key});

  @override
  State<MyReservationScreen> createState() => _MyReservationScreenState();
}

class _MyReservationScreenState extends State<MyReservationScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MyReservationProvider>().init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MyReservationProvider>();

    if (provider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final reservations = provider.reservationData;
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 예약 목록'),
      ),
      body: reservations.isEmpty
          ? const Center(child: Text('예약 내역이 없습니다.'))
          : ListView.builder(
        itemCount: reservations.length,
        itemBuilder: (context, index) {
          final item = reservations[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: item.warehouse.images.isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.warehouse.images.first,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              )
                  : const Icon(Icons.home_work, size: 40),
              title: Text('${item.warehouse.address} - ${item.space.num}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('예약 기간: ${_formatDate(item.startAt)} ~ ${_formatDate(item.endAt)}'),
                  Text('예약자: ${item.user.email}'),
                  Text('소유자: ${item.owner.email}'),
                ],
              ),
              onTap: () {
                // TODO: 상세 페이지 이동 구현
              },
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    // 원하는 형식으로 포맷 (예: 2025-07-02)
    return '${date.year}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}';
  }
}