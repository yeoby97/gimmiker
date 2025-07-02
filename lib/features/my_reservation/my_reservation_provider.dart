import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/dataSource/reservation_source.dart';
import '../../data/dataSource/space_source.dart';
import '../../data/dataSource/user_source.dart';
import '../../data/dataSource/warehouse_source.dart';
import '../../data/model/reservation.dart';
import '../../data/repository/reservation_repository.dart';
import '../../data/repository/space_repository.dart';
import '../../data/repository/user_repository.dart';
import '../../data/repository/warehouse_repository.dart';
import '../main/main_provider.dart';

class MyReservationProvider extends ChangeNotifier{

  final reservationRepository = ReservationRepository(ReservationSource());
  final warehouseRepository = WarehouseRepository(WarehouseSource());
  final userRepository = UserRepository(UserSource());
  final spaceRepository = SpaceRepository(SpaceSource());


  late final List<Reservation> _reservations;
  final List<ReservationData> _reservationData = [];
  List<ReservationData> get reservationData => _reservationData;

  bool _isLoading = true;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> init(BuildContext context) async {
    isLoading = true;

    final user = context.read<MainProvider>().currentUser;
    _reservationData.clear();
    _reservationData.clear();
    _reservations = await reservationRepository.getAllReservations(user!.myReservations);

    for(final reservation in _reservations){

      final warehouse = await warehouseRepository.getWarehouse(reservation.locationId, reservation.warehouseId);
      final space = await spaceRepository.getSpace(reservation.locationId, reservation.warehouseId, reservation.spaceId);
      final user = context.read<MainProvider>().currentUser!;
      final owner = await userRepository.getUser(reservation.ownerId);

      reservationData.add(ReservationData(
        id: reservation.id!,
        warehouse: warehouse,
        space: space,
        user: user,
        owner: owner!,
        startAt: reservation.startAt,
        endAt: reservation.endAt,
        createdAt: reservation.createdAt,
      ));
    }
    isLoading = false;
  }
}