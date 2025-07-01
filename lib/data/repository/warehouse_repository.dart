
import '../dataSource/warehouse_source.dart';
import '../model/warehouse.dart';

class WarehouseRepository{

  final WarehouseSource _warehouseSource;
  WarehouseRepository(this._warehouseSource);

  Future<Warehouse> getWarehouse(String locationId,String warehouseId) async{
    return await _warehouseSource.getWarehouse(locationId, warehouseId);
  }

  Stream<List<Warehouse>> streamAllWarehouses(){
    return _warehouseSource.streamAllWarehouses();
  }

  Future<String> addWarehouse(Warehouse warehouse) async{
    return await _warehouseSource.addWarehouse(warehouse);
  }
}