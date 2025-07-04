
import 'package:gimmiker/data/model/location.dart';
import 'package:gimmiker/data/model/space.dart';
import 'package:gimmiker/data/model/warehouse.dart';

enum UserType{user,manager}

class AppUser {
  final String uid; // 유저 아이디 null x
  final String email; // 유저 이메일 null x
  final String displayName; // 유저 이름 null x
  final String photoURL; // 프로필 UrL null x -  프로필 없더라도 기본 이미지 Url 넣어줌
  final String phoneNumber; // 휴대폰번호
  final bool advertisement; // 광고 수신 여부
  final List<MyWarehouse>? myWarehouses;
  final List<UsingSpace>? usingSpaces;
  final List<String>? myReservations;
  final List<String>? receivedReservations;
  final UserType userType;

  AppUser({
    required this.uid,
    required this.phoneNumber,
    required this.email,
    required this.displayName,
    required this.photoURL,
    required this.advertisement,
    required this.userType,
    this.myWarehouses,
    this.usingSpaces,
    this.myReservations,
    this.receivedReservations,
  });

  Map<String, dynamic> toMap() { // 클래스를 맵으로 변환(json형식)
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
      'advertisement': advertisement,
      'myWarehouses': myWarehouses?.map((e) => e.toMap()).toList(),
      'usingWarehouses': usingSpaces?.map((e) => e.toMap()).toList(),
      'myReservations': myReservations,
      'receivedReservations': receivedReservations,
      'userType': userType.name,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'],
      email: map['email'],
      displayName: map['displayName'],
      photoURL: map['photoURL'],
      phoneNumber: map['phoneNumber'],
      advertisement: map['advertisement'] ?? false,
      userType: UserType.values.firstWhere((e) => e.name == map['userType']),
      myWarehouses: map['myWarehouses'] != null
          ? (map['myWarehouses'] as List)
          .map((e) => MyWarehouse.fromMap(Map<String, dynamic>.from(e)))
          .toList()
          : [],
      usingSpaces: map['usingWarehouses'] != null
          ? (map['usingWarehouses'] as List)
          .map((e) => UsingSpace.fromMap(Map<String, dynamic>.from(e)))
          .toList()
          : [],
      myReservations: map['myReservations'] != null
          ? List<String>.from(map['myReservations'])
          : [],
      receivedReservations: map['receivedReservations'] != null
          ? List<String>.from(map['receivedReservations'])
          : [],
    );
  }

  AppUser copyWith({
    String? displayName,
    String? email,
    String? phoneNumber,
    String? photoURL,
    bool? advertisement,
    List<MyWarehouse>? myWarehouses,
    List<UsingSpace>? usingSpaces,
    List<String>? myReservations,
    List<String>? receivedReservations,
    UserType? userType,
  }) {
    return AppUser(
      uid: uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoURL: photoURL ?? this.photoURL,
      advertisement: advertisement ?? this.advertisement,
      myWarehouses: myWarehouses ?? this.myWarehouses,
      myReservations: myReservations ?? this.myReservations,
      usingSpaces: usingSpaces ?? this.usingSpaces,
      receivedReservations: receivedReservations ?? this.receivedReservations,
      userType: userType ?? this.userType,
    );
  }
}

class MyWarehouse {
  final String locationId;
  final String warehouseId;

  MyWarehouse({
    required this.locationId,
    required this.warehouseId,
  });

  Map<String, dynamic> toMap() {
    return {
      'locationId': locationId,
      'warehouseId': warehouseId,
    };
  }

  factory MyWarehouse.fromMap(Map<String, dynamic> map) {
    return MyWarehouse(
      locationId: map['locationId'],
      warehouseId: map['warehouseId'],
    );
  }

  MyWarehouse copyWith({
    String? locationId,
    String? warehouseId,
  }) {
    return MyWarehouse(
      locationId: locationId ?? this.locationId,
      warehouseId: warehouseId ?? this.warehouseId,
    );
  }
}

class UsingSpace {

  final String locationId;
  final String warehouseId;
  final String spaceId;

  UsingSpace({
    required this.locationId,
    required this.warehouseId,
    required this.spaceId,
  });

  Map<String, dynamic> toMap() {
    return {
      'locationId': locationId,
      'warehouseId': warehouseId,
      'spaceId': spaceId,
    };
  }

  factory UsingSpace.fromMap(Map<String, dynamic> map) {
    return UsingSpace(
      locationId: map['locationId'],
      warehouseId: map['warehouseId'],
      spaceId: map['spaceId'],
    );
  }

  UsingSpace copyWith({
    String? locationId,
    String? warehouseId,
    String? spaceId,
  }) {
    return UsingSpace(
      locationId: locationId ?? this.locationId,
      warehouseId: warehouseId ?? this.warehouseId,
      spaceId: spaceId ?? this.spaceId,
    );
  }
}

class UsingSpaceData{
  final Warehouse warehouse;
  final Space space;

  UsingSpaceData({
    required this.warehouse,
    required this.space,
  });
}