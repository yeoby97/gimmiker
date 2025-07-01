import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/dataSource/space_source.dart';
import '../../../data/model/space.dart';
import '../../../data/model/warehouse.dart';
import '../../../data/repository/space_repository.dart';
import '../../warehouse_detail/warehouse_detail_provider.dart';
import '../../warehouse_detail/warehouse_detail_screen.dart';
import '../home_provider.dart';

class BottomSheetProvider extends ChangeNotifier {

  final spaceRepository = SpaceRepository(SpaceSource());

  double _sheetHeight = 300;
  double _dragStart = 0;
  final double _minHeight = 0;
  final double _maxHeight = 700;

  double get sheetHeight => _sheetHeight;
  double get minHeight => _minHeight;
  double get maxHeight => _maxHeight;
  double get dragStart => _dragStart;


  set sheetHeight(double value) {
    _sheetHeight = value.clamp(_minHeight, _maxHeight);
    notifyListeners();
  }

  set dragStart(double value) {
    _dragStart = value;
  }

  void handleDragStart(DragStartDetails details) {
    _dragStart = details.globalPosition.dy;
  }

  void handleDragUpdate(DragUpdateDetails details) {
    final delta = _dragStart - details.globalPosition.dy;
    _sheetHeight = (_sheetHeight + delta).clamp(_minHeight, _maxHeight);
    _dragStart = details.globalPosition.dy;
    notifyListeners();
  }

  void handleDragEnd(DragEndDetails details,VoidCallback onClose) {
    final velocity = details.velocity.pixelsPerSecond.dy;

    if (_sheetHeight < 200 || velocity > 700) {
      closeSheet(onClose);
    } else if (_sheetHeight > 500 || velocity < -700) {
      _sheetHeight = _maxHeight;
      notifyListeners();
    } else {
      _sheetHeight = 300;
      notifyListeners();
    }
  }

  void closeSheet(VoidCallback onClose) {
    _sheetHeight = 0;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 500), () {
      onClose();
      notifyListeners();
    });
  }

  void onPressed(BuildContext context, Warehouse warehouse,List<Space> spaces) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ChangeNotifierProvider(
              create: (_) => WarehouseDetailProvider(),
              child: WarehouseDetailScreen(
                warehouse: warehouse,
                spaces: spaces,
              ),
            ),
      ),
    );
  }
}
