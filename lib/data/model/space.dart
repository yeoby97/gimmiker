import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

class Space {
  String id;
  double x, y, angle, width, height;
  final int num,price;
  String? user;
  DateTime? usingStart, usingEnd;
  bool istransaction = false;

  Space({
    this.id = '',
    required this.x,
    required this.y,
    required this.num,
    required this.width,
    required this.height,
    required this.price,
    this.user,
    this.usingStart,
    this.usingEnd,
    this.angle = 0.0,
    this.istransaction = false,
  });

  Map<String, dynamic> toMap() => {
    'x': x,
    'y': y,
    'angle': angle,
    'width': width,
    'height': height,
    'num': num,
    'user': user,
    'usingStart': usingStart?.toIso8601String(),
    'usingEnd': usingEnd?.toIso8601String(),
    'price': price,
  };

  factory Space.fromMap(Map<String, dynamic> map) => Space(
    id: map['id'] ?? '',
    x: map['x'],
    y: map['y'],
    angle: map['angle'],
    width: map['width'],
    height: map['height'],
    num: map['num'],
    user: map['user'],
    usingStart: map['usingStart'] != null ? DateTime.parse(map['usingStart']) : null,
    usingEnd: map['usingEnd'] != null ? DateTime.parse(map['usingEnd']) : null,
    price: map['price'],
  );

  factory Space.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    return Space.fromMap(data);
  }
}
