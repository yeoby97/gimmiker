

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gimmiker/data/dataSource/warehouse_source.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../data/dataSource/space_source.dart';
import '../../data/model/space.dart';
import '../../data/model/warehouse.dart';
import '../../data/repository/space_repository.dart';
import '../../data/repository/warehouse_repository.dart';

class HomeProvider extends ChangeNotifier{

  final _warehouseRepository = WarehouseRepository(WarehouseSource());
  final _spaceRepository = SpaceRepository(SpaceSource());

  bool _isBottomSheetOpen = false;
  bool get isBottomSheetOpen => _isBottomSheetOpen;
  set isBottomSheetOpen(bool value) {
    _isBottomSheetOpen = value;
    notifyListeners();
  }

  GoogleMapController? _mapController;
  GoogleMapController get mapController => _mapController!;
  set mapController(GoogleMapController? value) {
    _mapController = value;
  }

  final Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;

  Warehouse? _selectedWarehouse;
  Warehouse? get selectedWarehouse => _selectedWarehouse;
  set selectedWarehouse(Warehouse? value) {
    _selectedWarehouse = value;
    notifyListeners();
  }

  late final Stream<List<Warehouse>> _warehouseStream;
  late final StreamSubscription<List<Warehouse>> _subscription;
  HomeProvider() {
    init();
  }

  List<Space> _spaces = [];
  List<Space> get spaces => _spaces;

  void init(){
    _warehouseStream = _warehouseRepository.streamAllWarehouses();
    _subscription =  _warehouseStream.listen((warehouseList) {
      for (final warehouse in warehouseList) {
        final markerId = MarkerId(warehouse.id);
        final marker = Marker(
          markerId: markerId,
          position: LatLng(warehouse.lat, warehouse.lng),
          onTap: () async{
            _selectedWarehouse = warehouse;
            _spaces.clear();
            _spaces = await _spaceRepository.getAllSpaces(warehouse);
            _isBottomSheetOpen = true;
            notifyListeners();
          },
        );
        _markers.add(marker);
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _subscription.cancel();
    _mapController?.dispose();
    super.dispose();
  }
}