

import 'package:flutter/cupertino.dart';
import 'package:gimmiker/data/model/reservation.dart';
import 'package:gimmiker/data/repository/user_repository.dart';
import 'package:provider/provider.dart';

import '../../data/dataSource/reservation_source.dart';
import '../../data/dataSource/space_source.dart';
import '../../data/dataSource/user_source.dart';
import '../../data/dataSource/warehouse_source.dart';
import '../../data/model/space.dart';
import '../../data/model/user.dart';
import '../../data/model/warehouse.dart';
import '../../data/repository/reservation_repository.dart';
import '../../data/repository/space_repository.dart';
import '../../data/repository/warehouse_repository.dart';
import '../main/main_provider.dart';

class WarehouseManagementProvider extends ChangeNotifier{

  final spaceRepository = SpaceRepository(SpaceSource());
  final reservationRepository = ReservationRepository(ReservationSource());
  final userRepository = UserRepository(UserSource());
  final warehouseRepository = WarehouseRepository(WarehouseSource());


  List<Space>? spaces;
  List<Reservation> reservations = [];
  List<ReservationData> reservationsData = [];

  void init(BuildContext context,Warehouse warehouse)async{

    final AppUser user = context.read<MainProvider>().currentUser!;

    spaces = await spaceRepository.getAllSpaces(warehouse);

    if(user.receivedReservations != null){
      reservations = await reservationRepository.getAllReservations(user.receivedReservations);
    }

    reservations = reservations
        .where((element) => element.warehouseId == warehouse.id)
        .toList();

    for(Reservation reservation in reservations){
      final warehouse = await warehouseRepository.getWarehouse(reservation.locationId, reservation.warehouseId);
      final space = spaces!.firstWhere((element) => element.id == reservation.spaceId);
      final user = context.read<MainProvider>().currentUser!;
      final owner = await userRepository.getUser(reservation.ownerId);

      reservationsData.add(ReservationData(
        warehouse: warehouse,
        space: space,
        user: user,
        owner: owner!,
        startAt: reservation.startAt,
        endAt: reservation.endAt,
        createdAt: reservation.createdAt,
      ));
    }
    notifyListeners();
  }


}