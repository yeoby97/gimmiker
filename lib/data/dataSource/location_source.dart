

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/location.dart';

class LocationSource{
  final _firestore = FirebaseFirestore.instance;


  Future<Location?> getLocationFromLatLng(double lat, double lng) async {
    final snapshot = await _firestore
        .collection('locations')
        .where('lat', isEqualTo: lat)
        .where('lng', isEqualTo: lng)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return Location.fromDoc(snapshot.docs.first);
    }
    return null;
  }

  Future<String> addLocation(double lan, double lng) async {
    final doc = await _firestore.collection('locations').add({
      'lat': lan,
      'lng': lng,
    });
    return doc.id;
  }
}