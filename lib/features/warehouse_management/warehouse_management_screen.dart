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

  const ReservationListScreen({
    super.key,
    required this.reservationsData,
  });

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  void _showActionSheet(BuildContext context, ReservationData reservationData) {
    final provider = context.read<WarehouseManagementProvider>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "예약 처리",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text("승인"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    Navigator.pop(context);
                    provider.approve(reservationData);
                  },
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.close, color: Colors.white),
                  label: const Text("거부"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    Navigator.pop(context);
                    // rejectReservation(reservationData);
                  },
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.cancel, color: Colors.white),
                  label: const Text("취소"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  onPressed: () {
                    Navigator.pop(context);
                    // cancelReservation(reservationData);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: reservationsData.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final reservationData = reservationsData[index];
        return GestureDetector(
          onTap: () => _showActionSheet(context, reservationData),
          child: Card(
            color: Colors.blue[50],
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.blue.shade300, width: 1),
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
          ),
        );
      },
    );
  }
}