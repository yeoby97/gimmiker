

import 'package:cloud_firestore/cloud_firestore.dart';

class Location{
  final String? id;
  final double lat;
  final double lng;

  Location({this.id,required this.lat, required this.lng});

  Map<String, dynamic> toJson() => {
    'lat': lat,
    'lng': lng,
  };

  factory Location.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Location(
      id: doc.id,
      lat: data['lat'],
      lng: data['lng'],
    );
  }
}