import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:gimmiker/data/repository/space_repository.dart';
import 'package:gimmiker/features/main/main_provider.dart';
import 'package:gimmiker/services/sign_in_service.dart';
import 'package:provider/provider.dart';
import '../../data/dataSource/space_source.dart';
import '../../data/dataSource/warehouse_source.dart';
import '../../data/model/space.dart';
import '../../data/model/user.dart';
import '../../data/model/warehouse.dart';
import '../../data/repository/warehouse_repository.dart';

class MyWarehouseProvider extends ChangeNotifier{

  final warehouseRepository = WarehouseRepository(WarehouseSource());

  List<Warehouse> _warehouses = [];
  bool _isLoading = false;
  String? _error;
  List<Warehouse> get warehouses => _warehouses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> init(BuildContext context) async{
    _setLoading(true);

    _warehouses.clear();


    final check = await checkLogin(context);
    if(!check){
      _setLoading(false);
      return;
    }

    final AppUser user = context.read<MainProvider>().currentUser!;

    if(user.myWarehouses == null){
      _setLoading(false);
      return;
    }

    for(final id in user.myWarehouses!){
      final warehouse = await warehouseRepository.getWarehouse(id.locationId,id.warehouseId);
      _warehouses.add(warehouse);
    }

    _warehouses.sort((a, b) => (b.createdAt!).compareTo(a.createdAt!));
    _setLoading(false);

  }

  void _setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}