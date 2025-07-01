


import '../dataSource/space_source.dart';
import '../model/space.dart';
import '../model/warehouse.dart';

class SpaceRepository{

  final SpaceSource _spaceSource;

  SpaceRepository(this._spaceSource);

  Future<List<Space>> getAllSpaces(Warehouse warehouse) async {
    return _spaceSource.getAllSpaces(warehouse);
  }

  Future<void> addAllSpaces(Warehouse warehouse, List<Space> spaces) async {
    await _spaceSource.addAllSpaces(warehouse, spaces);
  }
}