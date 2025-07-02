import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/dataSource/space_source.dart';
import '../../data/dataSource/warehouse_source.dart';
import '../../data/model/user.dart';
import '../../data/repository/space_repository.dart';
import '../../data/repository/warehouse_repository.dart';
import '../main/main_provider.dart';

class MyUsingSpaceProvider extends ChangeNotifier{

  final spaceRepository = SpaceRepository(SpaceSource());
  final warehouseRepository = WarehouseRepository(WarehouseSource());

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<UsingSpaceData> _usingSpaces = [];

  List<UsingSpaceData> get usingSpaces => _usingSpaces;

  Future<void> init(BuildContext context) async{
    _setLoading(true);

    final AppUser user = context.read<MainProvider>().currentUser!;

    for(final ids in user.usingSpaces!){
      final warehouse = await warehouseRepository.getWarehouse(ids.locationId,ids.warehouseId);
      final space = await spaceRepository.getSpace(ids.locationId,ids.warehouseId,ids.spaceId);

      _usingSpaces.add(UsingSpaceData(warehouse: warehouse, space: space));
    }

    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}