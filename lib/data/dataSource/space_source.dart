

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/space.dart';
import '../model/warehouse.dart';

class SpaceSource{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SpaceSource();

  Future<List<Space>> getAllSpaces(Warehouse warehouse) async {
    final snapshot = await _firestore
        .collection('locations')
        .doc(warehouse.locationId)
        .collection('warehouses')
        .doc(warehouse.id)
        .collection('containers')
        .get();

    return snapshot.docs.map((doc) => Space.fromDoc(doc)).toList();
  }

  Future<void> addAllSpaces(Warehouse warehouse, List<Space> spaces) async {
    for (final space in spaces) {
      await _firestore
          .collection('locations')
          .doc(warehouse.locationId)
          .collection('warehouses')
          .doc(warehouse.id)
          .collection('containers')
          .add(space.toMap());
    }
  }
}