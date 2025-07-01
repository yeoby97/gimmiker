import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';

class Warehouse {
  final String id;
  final String locationId;
  final String address;
  final String detailAddress;
  final int count;
  final DateTime? createdAt;
  final List<String> images;
  final double lat;
  final double lng;
  final String ownerId;
  final Map<String, dynamic> layout;
  final double width;
  final double height;
  final bool approved;

  Warehouse({
    this.id = '',
    required this.locationId,
    required this.address,
    required this.detailAddress,
    required this.count,
    required this.createdAt,
    required this.images,
    required this.lat,
    required this.lng,
    required this.ownerId,
    required this.layout,
    required this.width,
    required this.height,
    this.approved = false,
  });

  factory Warehouse.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final layoutMap = Map<String, dynamic>.from(data['layout'] ?? {});

    final lines = (layoutMap['lines'] as List<dynamic>?)
        ?.map((e) => Line.fromMap(Map<String, dynamic>.from(e)))
        .toList() ?? [];

    final doors = (layoutMap['doors'] as List<dynamic>?)
        ?.map((e) {
      final map = Map<String, dynamic>.from(e);
      return Offset((map['x'] as num).toDouble(), (map['y'] as num).toDouble());
    }).toSet() ?? {};

    return Warehouse(
      id: doc.id,
      locationId: data['locationId'] ?? '',
      address: data['address'] ?? '',
      detailAddress: data['detailAddress'] ?? '',
      count: data['count'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      images: List<String>.from(data['images'] ?? []),
      lat: (data['lat'] as num).toDouble(),
      lng: (data['lng'] as num).toDouble(),
      ownerId: data['ownerId'] ?? '',
      layout: {
        'lines': lines,
        'doors': doors,
      },
      width: data['width'] ?? 0.0,
      height: data['height'] ?? 0.0,
      approved: data['approved'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {

    return {
      'locationId': locationId,
      'address': address,
      'detailAddress': detailAddress,
      'count': count,
      'createdAt': FieldValue.serverTimestamp(),
      'images': images,
      'lat': lat,
      'lng': lng,
      'ownerId': ownerId,
      'layout': {
        'lines': (layout['lines'] as List<Line>).map((line) => line.toMap()).toList(),
        'doors': (layout['doors'] as Set<Offset>).map((offset) => {
          'x': offset.dx,
          'y': offset.dy,
        }).toList(),
      },
      'width': width,
      'height': height,
      'approved': approved,
    };
  }

  Warehouse copyWith({
    String? id,
    String? locationId,
    String? address,
    String? detailAddress,
    int? count,
    DateTime? createdAt,
    List<String>? images,
    double? lat,
    double? lng,
    String? ownerId,
    Map<String, dynamic>? layout,
    double? width,
    double? height,
    bool? approved,
}){
    return Warehouse(
      id: id ?? this.id,
      locationId: locationId ?? this.locationId,
      address: address ?? this.address,
      detailAddress: detailAddress ?? this.detailAddress,
      count: count ?? this.count,
      createdAt: createdAt ?? this.createdAt,
      images: images ?? this.images,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      ownerId: ownerId ?? this.ownerId,
      layout: layout ?? this.layout,
      width: width ?? this.width,
      height: height ?? this.height,
      approved: approved ?? this.approved,
    );
  }
}

class Line {
  final Offset start;
  final Offset end;
  const Line(this.start, this.end);

  Map<String, dynamic> toMap() {
    return {
      'start': {'x': start.dx, 'y': start.dy},
      'end': {'x': end.dx, 'y': end.dy},
    };
  }

  factory Line.fromMap(Map<String, dynamic> map) {
    return Line(
      Offset(map['start']['x'], map['start']['y']),
      Offset(map['end']['x'], map['end']['y']),
    );
  }
}