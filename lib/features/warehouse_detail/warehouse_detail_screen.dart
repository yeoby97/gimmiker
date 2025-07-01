import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gimmiker/data/model/warehouse.dart';
import 'package:gimmiker/features/warehouse_detail/warehouse_detail_provider.dart';
import 'package:provider/provider.dart';
import '../../data/model/space.dart';
import '../../widgets/paint_widgets.dart';
import '../../widgets/warehouse_widgets.dart';

class WarehouseDetailScreen extends StatelessWidget {

  final Warehouse warehouse;
  final List<Space> spaces;

  const WarehouseDetailScreen({
    super.key,
    required this.warehouse,
    required this.spaces,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WarehouseDetailProvider>();

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageSlide(images: warehouse.images),
                  WarehouseInfoSection(warehouse: warehouse),
                  WarehouseLayoutView(
                    warehouse: warehouse,
                    spaces: spaces,
                    onBackgroundPressed: provider.onBackgroundPress,
                    selectedNum: provider.selectedSpaceNum,
                    onSpaceTap: provider.onSpacePress,
                    drawingOrTrade: DrawingOrTrade.trade,
                  ),
                  const SizedBox(height: 20),
                  _SpaceInfo(
                    selectedSpace: spaces.firstWhereOrNull(
                          (space) => space.num == provider.selectedSpaceNum,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _ReservationButton(
                    warehouse: warehouse,
                    spaces: spaces,
                  ),
                ],
              ),
            ),
          ),
          if (provider.isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

class _SpaceInfo extends StatefulWidget {
  final Space? selectedSpace;

  const _SpaceInfo({super.key, required this.selectedSpace});

  @override
  State<_SpaceInfo> createState() => _SpaceInfoState();
}

class _SpaceInfoState extends State<_SpaceInfo> {

  DateTime selectedDate = DateTime.now();
  int selectedMonths = 1;

  Future<void> _selectDate(BuildContext context) async {
    final provider = context.read<WarehouseDetailProvider>();
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: now,
      lastDate: selectedDate.add(const Duration(days: 365)),
    );
    if (picked != null) {
      selectedDate = picked;
      provider.selectedDate = picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<WarehouseDetailProvider>();

    final space = widget.selectedSpace;
    if (space == null) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text('공간 정보', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Text('번호: ${space.num}'),
        Text('가격: ${space.price}원(월)'),
        Text('가로: ${(space.width/10).toStringAsFixed(1)}m'),
        Text('세로: ${(space.height/10).toStringAsFixed(1)}m'),
        Text('면적: ${((space.width * space.height)/100).toStringAsFixed(1)}㎡'),
        const SizedBox(height: 12),
        // 날짜 선택 버튼
        Row(
          children: [
            const Text('희망 시작일: ', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(selectedDate != null
                ? '${selectedDate!.toLocal()}'.split(' ')[0]
                : '날짜를 선택하세요'),
            const SizedBox(width: 10),
            TextButton(
              onPressed: () => _selectDate(context),
              child: const Text('날짜 선택'),
            ),
          ],
        ),

        const SizedBox(height: 12),
        // 개월 수 선택 드롭다운
        Row(
          children: [
            const Text('사용 기간: ', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<int>(
              value: selectedMonths,
              items: List.generate(12, (index) {
                final month = index + 1;
                return DropdownMenuItem(
                  value: month,
                  child: Text('$month개월'),
                );
              }),
              onChanged: (value) {
                if (value != null) {
                  selectedMonths = value;
                  provider.selectedMonths = value;
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _ReservationButton extends StatelessWidget {

  final Warehouse warehouse;
  final List<Space> spaces;

  const _ReservationButton({
    super.key,
    required this.warehouse,
    required this.spaces,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<WarehouseDetailProvider>();

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () => provider.reserveButtonTap(context, warehouse, spaces),
        style: ElevatedButton.styleFrom(
          backgroundColor: provider.selectedSpaceNum != null ? Colors.blue : Colors.grey, // 버튼 배경색
          foregroundColor: Colors.white, // 텍스트 및 아이콘 색
        ),
        child: const Text('예약하기'),
      ),
    );
  }
}
