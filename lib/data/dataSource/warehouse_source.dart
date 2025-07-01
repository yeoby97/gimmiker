import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/warehouse.dart';

class WarehouseSource{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  WarehouseSource();

  Future<Warehouse> getWarehouse(String locationId,String warehouseId) async {
    final doc = await _firestore.collection('locations').doc(locationId).collection('warehouses').doc(warehouseId).get();
    return Warehouse.fromDoc(doc);
  }

  Stream<List<Warehouse>> streamAllWarehouses() {
    return _firestore.collectionGroup('warehouses').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Warehouse.fromDoc(doc);
      }).toList();
    });
  }

  Future<String> addWarehouse(Warehouse warehouse) async {
    final doc = await _firestore.collection('locations')
                .doc(warehouse.locationId).collection('warehouses')
                .add(warehouse.toMap());
    return doc.id;
  }
}