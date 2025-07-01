import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gimmiker/features/warehouse_management/warehouse_management_provider.dart';
import 'package:gimmiker/widgets/warehouse_widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../data/model/reservation.dart';
import '../../data/model/warehouse.dart';
import '../../widgets/paint_widgets.dart';

class WarehouseManagementScreen extends StatefulWidget {
  final Warehouse warehouse;

  const WarehouseManagementScreen({super.key, required this.warehouse});

  @override
  State<WarehouseManagementScreen> createState() => _WarehouseManagementScreenState();
}

class _WarehouseManagementScreenState extends State<WarehouseManagementScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.microtask((){
      final provider = context.read<WarehouseManagementProvider>();
      provider.init(context, widget.warehouse);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WarehouseManagementProvider>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageSlide(images: widget.warehouse.images),
              const SizedBox(height: 10),
              WarehouseInfoSection(warehouse: widget.warehouse),
              const SizedBox(height: 12),
              const Text('예약 가능한 공간', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              WarehouseLayoutView(
                warehouse: widget.warehouse,
                spaces: provider.spaces ?? [],
                drawingOrTrade: DrawingOrTrade.trade,
              ),
              const SizedBox(height: 12),
              ReservationListScreen(reservationsData: provider.reservationsData)
            ],
          ),
        ),
      ),
    );
  }
}

class ReservationListScreen extends StatelessWidget {
  final List<ReservationData> reservationsData;

  const ReservationListScreen({super.key, required this.reservationsData,});

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: reservationsData.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final reservationData = reservationsData[index];
        return Card(
          color: Colors.blue[50], // 카드 배경을 연한 파랑으로
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.blue.shade300, width: 1), // 테두리
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "이메일: ${reservationData.user.email}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.phone, color: Colors.blue, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      reservationData.user.phoneNumber,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.home_work_outlined, color: Colors.blue, size: 20),
                    const SizedBox(width: 6),
                    Text("창고 번호: ${reservationData.space.num}"),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.date_range, color: Colors.blue, size: 20),
                    const SizedBox(width: 6),
                    Text("시작일: ${formatDate(reservationData.startAt)}"),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_month, color: Colors.blue, size: 20),
                    const SizedBox(width: 6),
                    Text("종료일: ${formatDate(reservationData.endAt)}"),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
