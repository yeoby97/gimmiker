
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/model/space.dart';
import '../../../data/model/warehouse.dart';
import '../../../widgets/warehouse_widgets.dart';
import '../home_provider.dart';
import 'bottom_sheet_provider.dart';

class CustomBottomSheet extends StatefulWidget {

  final Warehouse warehouse;
  final List<Space> spaces;
  final bool isInitial;

  const CustomBottomSheet({
    super.key,
    required this.warehouse,
    required this.spaces,
    this.isInitial = true,
  });

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> with SingleTickerProviderStateMixin{
  late AnimationController _fadeController;

  @override
  void initState() {
    // TODO: implement initState

    final provider = context.read<BottomSheetProvider>();

    _fadeController  = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    // 초기 애니메이션 효과 처리
    if (widget.isInitial) {
      provider.sheetHeight = 0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => provider.sheetHeight = 300);
          _fadeController.forward(); // 페이드 인 시작
        }
      });
    } else {
      _fadeController.forward(); // 바로 표시
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BottomSheetProvider>();
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        height: provider.sheetHeight,
        curve: Curves.easeInOut,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, -4),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: FadeTransition(
          opacity: CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                _BuildDragHandle(
                  onVerticalDragStart: provider.handleDragStart,
                  onVerticalDragUpdate: provider.handleDragUpdate,
                  onVerticalDragEnd: (details) => provider.handleDragEnd(details, () {
                    final homeProvider = context.read<HomeProvider>();
                    homeProvider.isBottomSheetOpen = false;
                    homeProvider.selectedWarehouse = null;
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: WarehouseContents(
                    warehouse: widget.warehouse,
                    onPressed: () => provider.onPressed(context, widget.warehouse, widget.spaces),
                    spaces: widget.spaces,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BuildDragHandle extends StatelessWidget {
  final void Function(DragStartDetails)? onVerticalDragStart;
  final void Function(DragUpdateDetails)? onVerticalDragUpdate;
  final void Function(DragEndDetails)? onVerticalDragEnd;

  const _BuildDragHandle({
    super.key,
    required this.onVerticalDragStart,
    required this.onVerticalDragUpdate,
    required this.onVerticalDragEnd});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: onVerticalDragStart,
      onVerticalDragUpdate: onVerticalDragUpdate,
      onVerticalDragEnd: onVerticalDragEnd,
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 36,
        alignment: Alignment.center,
        child: Container(
          width: 40,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
