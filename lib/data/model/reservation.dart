import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gimmiker/data/model/space.dart';
import 'package:gimmiker/data/model/user.dart';
import 'package:gimmiker/data/model/warehouse.dart';

class Reservation {
  final String? id;
  final String locationId;
  final String warehouseId;
  final String spaceId;
  final String userId;
  final String ownerId;
  final DateTime createdAt;
  final DateTime startAt;
  final DateTime endAt;

  Reservation({
    this.id,
    required this.locationId,
    required this.warehouseId,
    required this.spaceId,
    required this.userId,
    required this.ownerId,
    required this.createdAt,
    required this.startAt,
    required this.endAt,
  });

  factory Reservation.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Reservation(
      id: doc.id,
      locationId: data['locationId'],
      warehouseId: data['warehouseId'],
      spaceId: data['spaceId'],
      userId: data['userId'],
      ownerId: data['ownerId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      startAt: (data['startAt'] as Timestamp).toDate(),
      endAt: (data['endAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'locationId': locationId,
      'warehouseId': warehouseId,
      'spaceId': spaceId,
      'userId': userId,
      'ownerId': ownerId,
      'createdAt': createdAt,
      'startAt': startAt,
      'endAt': endAt,
    };
  }
}

class ReservationData{
  final String id;
  final Warehouse warehouse;
  final Space space;
  final AppUser user;
  final AppUser owner;
  final DateTime startAt;
  final DateTime endAt;
  final DateTime createdAt;

  ReservationData({
    required this.id,
    required this.warehouse,
    required this.space,
    required this.user,
    required this.owner,
    required this.startAt,
    required this.endAt,
    required this.createdAt,
  });
}